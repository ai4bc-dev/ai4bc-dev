# Business Central v době AI — doprovodné materiály

Ukázkový kód, šablony a diagramy ke knize **Business Central v době AI** od Miloše Mikuláška.

## 📁 Struktura

```
al-extension/            Kompletní demo AL extension pro BC v27
python/
  rag-indexer/            RAG indexer pro BC data → Azure AI Search
  email-order-agent/      AI agent: email → prodejní objednávka v BC
mcp-server/              MCP server pro BC OData API (TypeScript)
docs/cs/
  prompt-sablony/        Prompt šablony pro BC vývojáře a konzultanty
  diagramy/              12 SVG diagramů z knihy
```

## 🚀 Rychlý start

### AL Extension

1. Otevřete `al-extension/` ve VS Code
2. Nastavte Azure OpenAI endpoint v BC → Nastavení AI kategorizace
3. Uložte API klíč přes "Nastavit API klíč"
4. Spusťte kategorizaci položek nebo AI vyhledávání

### Prompt šablony

Šablony jsou v `docs/cs/prompt-sablony/`:
- `bc-dev-prompts.md` — 12 šablon pro vývojáře
- `bc-consultant-prompts.md` — šablony pro konzultanty
- `claude-md-template.md` — šablona CLAUDE.md pro BC projekty

## 📖 Vztah ke knize

| Složka | Kapitoly |
|--------|----------|
| `al-extension/` | Kap. 12–13 (Workshop), Kap. 27–29 (Demo) |
| `python/rag-indexer/` | Kap. 34 (RAG) |
| `python/email-order-agent/` | Kap. 35 (AI agenti) |
| `mcp-server/` | Kap. 37 (MCP servery) |

## ⚖️ Licence

Kód: MIT License. Text a diagramy: © 2026 Miloš Mikulášek.

## 🔗 Odkazy

- **Kniha:** [ai4bc.dev](https://ai4bc.dev)
- **Autor:** milos.mikulasek@ai4bc.dev
