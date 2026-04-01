# RAG Indexer pro Business Central data

Indexuje servisní tikety (nebo jiná BC data) do Azure AI Search pro sémantické vyhledávání.

## Použití

```bash
pip install -r requirements.txt
# Upravte konfiguraci na začátku bc_rag_indexer.py
python bc_rag_indexer.py
```

## Konfigurace

Upravte konstanty na začátku `bc_rag_indexer.py`:
- `BC_BASE_URL` — URL vašeho BC OData API
- `AZURE_OPENAI_ENDPOINT` — endpoint Azure OpenAI pro embeddings
- `SEARCH_ENDPOINT` — endpoint Azure AI Search
- API klíče pro všechny služby

## Viz kniha

Kapitola 34: RAG — Jak naučit AI vaše BC data
