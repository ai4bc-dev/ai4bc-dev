"""Klient pro Business Central OData API."""

import requests
from azure.identity import ClientSecretCredential

class BCClient:
    def __init__(self, base_url: str, company_id: str,
                 tenant_id: str, client_id: str, client_secret: str):
        self.base_url = f"{base_url}/api/v2.0/companies({company_id})"
        self.credential = ClientSecretCredential(
            tenant_id, client_id, client_secret
        )

    def _get_headers(self):
        token = self.credential.get_token(
            "https://api.businesscentral.dynamics.com/.default"
        )
        return {
            "Authorization": f"Bearer {token.token}",
            "Content-Type": "application/json",
            "Accept": "application/json"
        }

    def get_customer_by_name(self, name: str) -> dict | None:
        """Najde zákazníka podle jména (partial match)."""
        resp = requests.get(
            f"{self.base_url}/customers?$filter=contains(displayName,'{name}')",
            headers=self._get_headers()
        )
        resp.raise_for_status()
        results = resp.json().get("value", [])
        return results[0] if results else None

    def get_customer_balance(self, customer_no: str) -> dict:
        """Vrátí zůstatek a kreditní limit zákazníka."""
        resp = requests.get(
            f"{self.base_url}/customers?$filter=number eq '{customer_no}'",
            headers=self._get_headers()
        )
        resp.raise_for_status()
        customer = resp.json()["value"][0]
        return {
            "number": customer["number"],
            "name": customer["displayName"],
            "balance": customer.get("balanceDue", 0),
            "credit_limit": customer.get("creditLimit", 0)
        }

    def create_sales_order(self, customer_no: str,
                           items: list[dict]) -> dict:
        """Vytvoří prodejní objednávku s řádky."""
        # Vytvoříme hlavičku
        order_resp = requests.post(
            f"{self.base_url}/salesOrders",
            json={"customerNumber": customer_no},
            headers=self._get_headers()
        )
        order_resp.raise_for_status()
        order = order_resp.json()
        order_id = order["id"]

        # Přidáme řádky
        for item in items:
            line_resp = requests.post(
                f"{self.base_url}/salesOrders({order_id})/salesOrderLines",
                json={
                    "itemId": item["item_no"],
                    "quantity": item["quantity"]
                },
                headers=self._get_headers()
            )
            line_resp.raise_for_status()

        return {
            "order_number": order["number"],
            "customer": customer_no,
            "lines": len(items)
        }
```
```python
"""OpenAI agent pro zpracování objednávek z emailů."""

import json
from openai import AzureOpenAI
from bc_client import BCClient

# Definice nástrojů pro agenta
TOOLS = [
    {
        "type": "function",
        "function": {
            "name": "get_customer_by_name",
            "description": "Najde zákazníka v BC podle jména.",
            "parameters": {
