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
                "type": "object",
                "properties": {
                    "name": {"type": "string", "description": "Jméno zákazníka"}
                },
                "required": ["name"]
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "get_customer_balance",
            "description": "Zjistí zůstatek a kreditní limit zákazníka.",
            "parameters": {
                "type": "object",
                "properties": {
                    "customer_no": {"type": "string", "description": "Číslo zákazníka"}
                },
                "required": ["customer_no"]
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "create_sales_order",
            "description": "Vytvoří prodejní objednávku v BC.",
            "parameters": {
                "type": "object",
                "properties": {
                    "customer_no": {"type": "string"},
                    "items": {
                        "type": "array",
                        "items": {
                            "type": "object",
                            "properties": {
                                "item_no": {"type": "string"},
                                "quantity": {"type": "number"}
                            }
                        }
                    }
                },
                "required": ["customer_no", "items"]
            }
        }
    }
]

SYSTEM_PROMPT = """Jsi AI agent pro zpracování emailových objednávek v Business Central.

Tvůj workflow:
1. Z emailu extrahuj jméno zákazníka a položky s množstvím
2. Najdi zákazníka v BC podle jména
3. Zkontroluj kreditní limit
4. Pokud je vše OK, vytvoř objednávku
5. Pokud něco nesedí, vrať chybovou zprávu s popisem problému

DŮLEŽITÉ:
- Pokud zákazník není nalezen, NEVYTVÁŘEJ objednávku. Vrať chybu.
- Pokud kreditní limit je překročen, NEVYTVÁŘEJ objednávku. Vrať upozornění.
- Vždy vrať strukturovaný výsledek: úspěch nebo chyba s důvodem."""


class OrderAgent:
    def __init__(self, openai_client: AzureOpenAI, bc_client: BCClient,
                 max_value: float = 50000):
        self.openai = openai_client
        self.bc = bc_client
        self.max_value = max_value

    def process_email(self, email_text: str) -> dict:
        """Zpracuje email s objednávkou — hlavní entry point."""
        messages = [
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": f"Zpracuj tento email s objednávkou:\n\n{email_text}"}
        ]

        # Agent loop — iteruje dokud nedojde k výsledku
        for iteration in range(10):  # Max 10 iterací jako pojistka
            response = self.openai.chat.completions.create(
                model="gpt-4o-mini",
                messages=messages,
                tools=TOOLS,
                tool_choice="auto"
            )

            message = response.choices[0].message

            # Pokud agent nechce volat nástroj, máme výsledek
            if not message.tool_calls:
                return {
                    "status": "completed",
                    "result": message.content,
                    "iterations": iteration + 1
                }

            # Agent chce volat nástroj(e)
            messages.append(message)

            for tool_call in message.tool_calls:
                result = self._execute_tool(
                    tool_call.function.name,
                    json.loads(tool_call.function.arguments)
                )
                messages.append({
                    "role": "tool",
                    "tool_call_id": tool_call.id,
                    "content": json.dumps(result)
                })

        return {"status": "error", "result": "Agent překročil maximální počet iterací"}

    def _execute_tool(self, name: str, args: dict) -> dict:
        """Vykoná volání nástroje."""
        try:
            if name == "get_customer_by_name":
                customer = self.bc.get_customer_by_name(args["name"])
                if customer:
                    return {"found": True, "number": customer["number"],
                            "name": customer["displayName"]}
                return {"found": False, "message": f"Zákazník '{args['name']}' nenalezen"}

            elif name == "get_customer_balance":
                return self.bc.get_customer_balance(args["customer_no"])

            elif name == "create_sales_order":
                return self.bc.create_sales_order(
                    args["customer_no"], args["items"]
                )

            return {"error": f"Neznámý nástroj: {name}"}

        except Exception as e:
            return {"error": str(e)}
```
```python
"""Azure Function: email trigger pro order processing."""

import os
import json
import logging
import azure.functions as func
from openai import AzureOpenAI
from bc_client import BCClient
from openai_agent import OrderAgent

app = func.FunctionApp()

@app.function_name(name="ProcessOrderEmail")
@app.route(route="process-order", methods=["POST"])
def process_order_email(req: func.HttpRequest) -> func.HttpResponse:
    """HTTP trigger pro zpracování emailu s objednávkou."""
    logging.info("Přijat email ke zpracování")

    try:
        body = req.get_json()
        email_text = body.get("email_text", "")
        if not email_text:
            return func.HttpResponse(
                json.dumps({"error": "Chybí email_text"}),
                status_code=400
            )

        # Inicializace klientů
        openai_client = AzureOpenAI(
            azure_endpoint=os.environ["AZURE_OPENAI_ENDPOINT"],
            api_key=os.environ["AZURE_OPENAI_KEY"],
            api_version="2025-01-01-preview"
        )

        bc_client = BCClient(
            base_url=os.environ["BC_BASE_URL"],
            company_id=os.environ["BC_COMPANY_ID"],
            tenant_id=os.environ["AZURE_TENANT_ID"],
            client_id=os.environ["AZURE_CLIENT_ID"],
            client_secret=os.environ["AZURE_CLIENT_SECRET"]
        )

        # Zpracování
        agent = OrderAgent(openai_client, bc_client)
