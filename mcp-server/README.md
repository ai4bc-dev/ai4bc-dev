# BC MCP Server

MCP (Model Context Protocol) server, který exponuje Business Central OData API pro AI asistenty.

## Nástroje

- `get_customer` — informace o zákazníkovi
- `list_open_sales_orders` — otevřené prodejní objednávky
- `get_item_inventory` — stav skladu položky

## Instalace

```bash
npm install
npm run build
```

## Konfigurace v Claude Code

Přidejte do `.claude/settings.json`:

```json
{
  "mcpServers": {
    "bc-connector": {
      "command": "npx",
      "args": ["tsx", "./mcp-server/src/index.ts"],
      "env": {
        "BC_BASE_URL": "https://api.businesscentral.dynamics.com/v2.0/...",
        "BC_COMPANY_ID": "your-company-guid",
        "AZURE_TENANT_ID": "your-tenant-id",
        "AZURE_CLIENT_ID": "your-client-id",
        "AZURE_CLIENT_SECRET": "your-client-secret"
      }
    }
  }
}
```

## Azure App Registration

1. Azure Portal → Azure AD → App registrations → New
2. Název: "BC MCP Connector"
3. Certificates & secrets → New client secret
4. API permissions → Dynamics 365 BC → `app_access`
5. Admin consent

## Viz kniha

Kapitola 37: MCP servery a custom tooling pro BC
