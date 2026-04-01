# AI for BC Developers — Companion Code & Materials

Code samples, templates, and diagrams from the book **AI pro BC vývojáře** (AI for BC Developers) by Miloš Mikulášek.

🇨🇿 [Česká verze README](docs/cs/README.md) | 🇬🇧 English (this file) | 🇩🇪 [Deutsch](docs/de/README.md) | 🇪🇸 [Español](docs/es/README.md)

## 📁 Repository Structure

```
al-extension/            Complete demo AL extension for BC v27+
python/
  rag-indexer/            RAG indexer: BC data → Azure AI Search
  email-order-agent/      AI agent: email → sales order in BC
mcp-server/              MCP server for BC OData API (TypeScript)
docs/
  cs/                    Czech: prompts, diagrams
  en/                    English: prompts, diagrams
  de/                    German (coming soon)
  es/                    Spanish (coming soon)
```

## 🚀 Quick Start

### AL Extension (Business Central v27+)

1. Open `al-extension/` in VS Code
2. Configure Azure OpenAI endpoint in BC → AI Categorization Setup
3. Store API key via "Set API Key" button
4. Run item categorization or AI search

### RAG Indexer (Python)

```bash
cd python/rag-indexer
pip install -r requirements.txt
python bc_rag_indexer.py
```

### MCP Server (Node.js/TypeScript)

```bash
cd mcp-server
npm install
# Add to .claude/settings.json (see mcp-server/README.md)
```

### Email-to-Order Agent (Azure Function)

```bash
cd python/email-order-agent
pip install -r requirements.txt
# Deploy as Azure Function
```

## 📋 Requirements

- **AL Extension:** VS Code + AL Language Extension, BC v27+ sandbox
- **Python:** Python 3.10+, Azure subscription
- **MCP Server:** Node.js 20+, Azure AD App Registration
- **All:** Azure OpenAI Service resource with a deployed model

## 📖 Book Chapters → Code Mapping

| Folder | Book Chapters |
|--------|--------------|
| `al-extension/` | Ch. 12–13 (Workshop), Ch. 27–29 (Demos) |
| `python/rag-indexer/` | Ch. 34 (RAG) |
| `python/email-order-agent/` | Ch. 35 (AI Agents) |
| `mcp-server/` | Ch. 37 (MCP Servers) |
| `docs/*/prompt-*` | Ch. 5–6 (Prompt Engineering), Appendix B |
| `docs/*/diagram*` | All chapters (12 diagrams) |

## ⚖️ License

Code: [MIT License](LICENSE)
Text & diagrams: © 2026 Miloš Mikulášek. All rights reserved.

## 🔗 Links

- **Book:** [ai4bc.dev](https://ai4bc.dev)
- **Author:** milos.mikulasek@ai4bc.dev
