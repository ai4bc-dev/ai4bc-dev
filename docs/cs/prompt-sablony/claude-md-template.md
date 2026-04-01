# [Název projektu] — CLAUDE.md šablona

## Projekt
[Krátký popis co extension dělá, pro jakého zákazníka, v jaké verzi BC]
BC verze: [27]. Publisher: [firma]. Prefix: [ZZ_].

## Klíčové tabulky
- Table [50100]: [Název] — [popis, klíčová pole]
- Table [50101]: [Název] — [popis, klíčová pole]

## Konvence
- Naming prefix: [ZZ_]
- Komentáře: [česky / anglicky]
- Error handling: Error() pro business chyby, TestField() pro validace
- Procedury: PascalCase
- Testy: [povinné / volitelné], prefix Test_

## Co Claude NEMÁ dělat bez souhlasu
- Nemodifikovat existující veřejné procedury
- Nepoužívat přímý SQL ani RecordRef
- Nevytvářet nové tabulky
- Neměnit objektová čísla ani ID ranges
- Neodstraňovat existující kód

## Typické úkoly
- [Přidávání nových ... ]
- [Oprava bugů v ... ]
- [Psaní dokumentace pro ... ]
