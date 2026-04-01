import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  ListToolsRequestSchema,
  CallToolRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";
import { ClientSecretCredential } from "@azure/identity";

// === Konfigurace z environment variables ===
const BC_BASE_URL = process.env.BC_BASE_URL!;
const BC_COMPANY_ID = process.env.BC_COMPANY_ID!;
const AZURE_TENANT_ID = process.env.AZURE_TENANT_ID!;
const AZURE_CLIENT_ID = process.env.AZURE_CLIENT_ID!;
const AZURE_CLIENT_SECRET = process.env.AZURE_CLIENT_SECRET!;

// === OAuth token provider ===
const credential = new ClientSecretCredential(
  AZURE_TENANT_ID,
  AZURE_CLIENT_ID,
  AZURE_CLIENT_SECRET
);

async function getToken(): Promise<string> {
  const token = await credential.getToken(
    "https://api.businesscentral.dynamics.com/.default"
  );
  return token.token;
}

// === BC API helper ===
async function callBCApi(endpoint: string): Promise<any> {
  const token = await getToken();
  const url = `${BC_BASE_URL}/api/v2.0/companies(${BC_COMPANY_ID})/${endpoint}`;

  const response = await fetch(url, {
    headers: {
      Authorization: `Bearer ${token}`,
      Accept: "application/json",
    },
  });

  if (!response.ok) {
    const errorText = await response.text();
    throw new Error(
      `BC API error ${response.status}: ${errorText.substring(0, 200)}`
    );
  }

  return response.json();
}

// === MCP Server ===
const server = new Server(
  { name: "bc-connector", version: "1.0.0" },
  { capabilities: { tools: {} } }
);

// Registrace nástrojů
server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: "get_customer",
      description:
        "Vrátí detailní informace o zákazníkovi z Business Central " +
        "podle jeho čísla. Použij, když potřebuješ jméno, adresu, " +
        "kreditní limit nebo platební podmínky zákazníka.",
      inputSchema: {
        type: "object" as const,
        properties: {
          customer_no: {
            type: "string",
            description: "Číslo zákazníka v BC, například C10000",
          },
        },
        required: ["customer_no"],
      },
    },
    {
      name: "list_open_sales_orders",
      description:
        "Vrátí seznam otevřených prodejních objednávek. " +
        "Můžeš filtrovat podle zákazníka. Použij, když potřebuješ " +
        "zjistit stav objednávek nebo najít konkrétní objednávku.",
      inputSchema: {
        type: "object" as const,
        properties: {
          customer_no: {
            type: "string",
            description:
              "Volitelné: číslo zákazníka pro filtrování. " +
              "Pokud není zadáno, vrátí všechny otevřené objednávky.",
          },
          top: {
            type: "number",
            description: "Maximální počet výsledků (výchozí 20)",
          },
        },
      },
    },
    {
      name: "get_item_inventory",
      description:
        "Vrátí informace o položce včetně dostupného množství na skladě. " +
        "Použij, když potřebuješ zjistit stav zásob konkrétní položky.",
      inputSchema: {
        type: "object" as const,
        properties: {
          item_no: {
            type: "string",
            description: "Číslo položky v BC, například 1000",
          },
        },
        required: ["item_no"],
      },
    },
  ],
}));

// Obsluha volání nástrojů
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    switch (name) {
      case "get_customer": {
        const customerNo = args?.customer_no as string;
        const data = await callBCApi(
          `customers?$filter=number eq '${customerNo}'`
        );
        const customer = data.value?.[0];
        if (!customer) {
          return {
            content: [
              {
                type: "text" as const,
                text: `Zákazník ${customerNo} nebyl nalezen v BC.`,
              },
            ],
          };
        }
        return {
          content: [
            {
              type: "text" as const,
              text: JSON.stringify(customer, null, 2),
            },
          ],
        };
      }

      case "list_open_sales_orders": {
        const customerNo = args?.customer_no as string;
        const top = (args?.top as number) || 20;
        let filter = `status eq 'Open'`;
        if (customerNo) {
          filter += ` and sellToCustomerNumber eq '${customerNo}'`;
        }
        const data = await callBCApi(
          `salesOrders?$filter=${encodeURIComponent(filter)}&$top=${top}`
        );
        return {
          content: [
            {
              type: "text" as const,
              text: JSON.stringify(data.value, null, 2),
            },
          ],
        };
      }

      case "get_item_inventory": {
        const itemNo = args?.item_no as string;
        const data = await callBCApi(
          `items?$filter=number eq '${itemNo}'`
        );
        const item = data.value?.[0];
        if (!item) {
          return {
            content: [
              {
                type: "text" as const,
                text: `Položka ${itemNo} nebyla nalezena v BC.`,
              },
            ],
          };
        }
        return {
          content: [
            {
              type: "text" as const,
              text: JSON.stringify(
                {
                  number: item.number,
                  displayName: item.displayName,
                  inventory: item.inventory,
                  unitPrice: item.unitPrice,
                  blocked: item.blocked,
                },
                null,
                2
              ),
            },
          ],
        };
      }

      default:
        return {
          content: [
            {
              type: "text" as const,
              text: `Neznámý nástroj: ${name}`,
            },
          ],
          isError: true,
        };
    }
  } catch (error: any) {
    return {
      content: [
        {
          type: "text" as const,
          text: `Chyba při volání BC: ${error.message}`,
        },
      ],
      isError: true,
    };
  }
});

// Spuštění
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("BC MCP Server spuštěn");
}

main().catch(console.error);
