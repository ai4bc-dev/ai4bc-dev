"""
RAG Indexer pro Business Central data.
Exportuje servisní tikety z BC, vygeneruje embeddings
a uloží do Azure AI Search.
"""

import json
import requests
from openai import AzureOpenAI
from azure.search.documents import SearchClient
from azure.search.documents.indexes import SearchIndexClient
from azure.search.documents.indexes.models import (
    SearchIndex, SimpleField, SearchableField,
    SearchFieldDataType, VectorSearch,
    HnswAlgorithmConfiguration, VectorSearchProfile,
    SearchField
)
from azure.core.credentials import AzureKeyCredential

# === Konfigurace ===
BC_BASE_URL = "https://api.businesscentral.dynamics.com/v2.0/{tenant_id}/{environment}/api/v2.0"
BC_COMPANY_ID = "your-company-id"
BC_AUTH_TOKEN = "Bearer your-oauth-token"

AZURE_OPENAI_ENDPOINT = "https://your-ai.openai.azure.com/"
AZURE_OPENAI_KEY = "your-openai-key"
EMBEDDING_DEPLOYMENT = "text-embedding-3-small"

SEARCH_ENDPOINT = "https://your-search.search.windows.net"
SEARCH_KEY = "your-search-key"
INDEX_NAME = "bc-service-tickets"

# === 1. Export dat z BC ===
def fetch_service_tickets():
    """Načte servisní tikety z BC přes OData API."""
    url = f"{BC_BASE_URL}/companies({BC_COMPANY_ID})/serviceOrders"
    headers = {
        "Authorization": BC_AUTH_TOKEN,
        "Accept": "application/json"
    }

    tickets = []
    while url:
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        data = response.json()

        for item in data.get("value", []):
            tickets.append({
                "id": item["number"],
                "description": item.get("description", ""),
                "resolution": item.get("resolutionCode", ""),
                "customer": item.get("customerName", ""),
                "status": item.get("status", ""),
                "date": item.get("orderDate", ""),
                # Sestavíme text pro embedding
                "content": f"Tiket {item['number']}: {item.get('description', '')}. "
                           f"Zákazník: {item.get('customerName', '')}. "
                           f"Řešení: {item.get('resolutionCode', '')}."
            })

        # Stránkování
        url = data.get("@odata.nextLink")

    print(f"Načteno {len(tickets)} tiketů z BC")
    return tickets


# === 2. Generování embeddings ===
def generate_embeddings(tickets):
    """Vygeneruje embedding pro každý tiket."""
    client = AzureOpenAI(
        azure_endpoint=AZURE_OPENAI_ENDPOINT,
        api_key=AZURE_OPENAI_KEY,
        api_version="2025-01-01-preview"
    )

    for i, ticket in enumerate(tickets):
        response = client.embeddings.create(
            input=ticket["content"],
            model=EMBEDDING_DEPLOYMENT
        )
        ticket["embedding"] = response.data[0].embedding

        if (i + 1) % 100 == 0:
            print(f"  Embeddings: {i + 1}/{len(tickets)}")

    print(f"Vygenerováno {len(tickets)} embeddings")
    return tickets


# === 3. Vytvoření indexu v Azure AI Search ===
def create_search_index():
    """Vytvoří vektorový index v Azure AI Search."""
    client = SearchIndexClient(
        endpoint=SEARCH_ENDPOINT,
        credential=AzureKeyCredential(SEARCH_KEY)
    )

    fields = [
        SimpleField(name="id", type=SearchFieldDataType.String,
                     key=True, filterable=True),
        SearchableField(name="content", type=SearchFieldDataType.String),
        SimpleField(name="customer", type=SearchFieldDataType.String,
                     filterable=True),
        SimpleField(name="status", type=SearchFieldDataType.String,
                     filterable=True),
        SimpleField(name="date", type=SearchFieldDataType.String,
                     filterable=True, sortable=True),
        SearchField(
            name="embedding",
            type=SearchFieldDataType.Collection(SearchFieldDataType.Single),
            searchable=True,
            vector_search_dimensions=1536,  # text-embedding-3-small
            vector_search_profile_name="vector-profile"
        ),
    ]

    vector_search = VectorSearch(
        algorithms=[HnswAlgorithmConfiguration(name="hnsw-config")],
        profiles=[VectorSearchProfile(
            name="vector-profile",
            algorithm_configuration_name="hnsw-config"
        )]
    )

    index = SearchIndex(
        name=INDEX_NAME,
        fields=fields,
        vector_search=vector_search
    )

    client.create_or_update_index(index)
    print(f"Index '{INDEX_NAME}' vytvořen/aktualizován")


# === 4. Nahrání dat do indexu ===
def upload_to_index(tickets):
    """Nahraje tikety s embeddings do Azure AI Search."""
    client = SearchClient(
        endpoint=SEARCH_ENDPOINT,
        index_name=INDEX_NAME,
        credential=AzureKeyCredential(SEARCH_KEY)
    )

    # Upload po dávkách po 100
    batch_size = 100
    for i in range(0, len(tickets), batch_size):
        batch = tickets[i:i + batch_size]
        documents = [
            {
                "id": t["id"],
                "content": t["content"],
                "customer": t["customer"],
                "status": t["status"],
                "date": t["date"],
                "embedding": t["embedding"]
            }
            for t in batch
        ]
        client.upload_documents(documents)
        print(f"  Nahráno {min(i + batch_size, len(tickets))}/{len(tickets)}")

    print("Upload dokončen")


# === 5. Vyhledávání ===
def search(query: str, top_k: int = 5):
    """Vyhledá nejpodobnější tikety k dotazu."""
    # Vygenerujeme embedding dotazu
    oai_client = AzureOpenAI(
        azure_endpoint=AZURE_OPENAI_ENDPOINT,
        api_key=AZURE_OPENAI_KEY,
        api_version="2025-01-01-preview"
    )
    query_embedding = oai_client.embeddings.create(
        input=query,
        model=EMBEDDING_DEPLOYMENT
    ).data[0].embedding

    # Vyhledáme v indexu
    search_client = SearchClient(
        endpoint=SEARCH_ENDPOINT,
        index_name=INDEX_NAME,
        credential=AzureKeyCredential(SEARCH_KEY)
    )

    results = search_client.search(
        search_text=None,
        vector_queries=[{
            "vector": query_embedding,
            "k_nearest_neighbors": top_k,
            "fields": "embedding"
        }]
    )

    return [{"id": r["id"], "content": r["content"], "score": r["@search.score"]}
