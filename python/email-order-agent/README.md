# Email-to-Order AI Agent pro Business Central

Azure Function, která zpracovává emaily s objednávkami a automaticky vytváří záznamy v BC.

## Architektura

1. Email přijde → Azure Function se spustí
2. OpenAI agent extrahuje data z emailu (zákazník, položky, množství)
3. Agent iterativně volá BC API (najdi zákazníka → zkontroluj kredit → vytvoř objednávku)
4. Výsledek: objednávka v BC nebo eskalace na člověka

## Soubory

- `function_app.py` — Azure Function HTTP trigger
- `bc_client.py` — BC OData API klient s OAuth
- `openai_agent.py` — OpenAI agent s function calling

## Deploy

```bash
pip install -r requirements.txt
func azure functionapp publish <název-vaší-function-app>
```

## Viz kniha

Kapitola 35: AI agenti — Automatizace komplexních BC procesů
