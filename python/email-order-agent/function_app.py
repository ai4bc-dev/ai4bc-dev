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
        result = agent.process_email(email_text)

        logging.info(f"Výsledek: {result['status']} po {result.get('iterations', '?')} iteracích")

        return func.HttpResponse(
            json.dumps(result, ensure_ascii=False),
            mimetype="application/json"
        )

    except Exception as e:
        logging.error(f"Chyba: {e}")
        return func.HttpResponse(
            json.dumps({"error": str(e)}),
            status_code=500
        )
