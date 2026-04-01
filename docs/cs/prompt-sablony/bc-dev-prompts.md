# Prompt šablony pro BC vývojáře

> Knihovna připravených šablon pro každodenní AL vývoj s AI.
> Zkopíruj šablonu, vyplň [závorky], pošli do Claude nebo ChatGPT.

---

## Šablona 1: Nový AL codeunit

```
Jsem BC vývojář, pracuji v Business Central verzi [verze].
Projekt: [krátký popis projektu nebo extension]

Potřebuji napsat codeunit, který [popis funkce].

Kontext:
- Relevantní tabulky: [seznam tabulek s popisem]
- Workflow: [popis kdy a jak se codeunit volá]
- Edge cases: [seznam výjimek nebo speciálních situací]
- Existující vzor v projektu: [popis nebo příklad existujícího kódu]

Konvence:
- Naming prefix: [prefix]
- Komentáře: [česky/anglicky]
- Error handling: [Error() / TestField() / vlastní]

Napiš kompletní AL kód s komentáři.
```

---

## Šablona 2: Debug runtime chyby

```
Mám AL kód, který způsobuje tuto runtime chybu:
[přesná chybová hláška]

Kód kde k chybě dochází:
[vlož relevantní kód]

BC verze: [verze]
Kontext: [kdy přesně k chybě dochází]

Analyzuj příčinu, navrhni opravu a vysvětli co ji způsobovalo.
```

---

## Šablona 3: Debug compile chyby

```
Dostávám tyto compile chyby při buildování AL extension:
[vlož seznam chyb s čísly řádků]

Relevantní kód:
[vlož kód]

BC verze: [verze]

Oprav chyby a vysvětli každou opravu.
```

---

## Šablona 4: Code review

```
Proveď code review tohoto AL kódu:
[vlož kód]

Zaměř se na:
1. Výkon – zbytečné DB dotazy, chybějící SetLoadFields
2. Error handling – jsou pokryty edge cases?
3. Bezpečnost – jsou správně kontrolována oprávnění?
4. Maintainability – čitelnost, komentáře, naming
5. BC best practices – konzistence s AL konvencemi v [verze]

Pro každý nalezený problém: Popis + navrhovaná oprava + příklad.
```

---

## Šablona 5: Refactoring

```
Tento AL kód funguje, ale [problém: je příliš dlouhý / duplicitní / obtížně čitelný].

Kód:
[vlož kód]

Cíl refactoringu: [konkrétní cíl]
Omezení: [co nemůžeš změnit – veřejné rozhraní, existující data]
BC verze: [verze]

Navrhni refactoring. Pro každou změnu: co měníš a proč.
```

---

## Šablona 6: Nová table extension

```
Potřebuji přidat pole do standardní BC tabulky [název tabulky] přes table extension.

Pole:
- [název pole] ([datový typ], [délka]): [popis účelu]

Konvence:
- Prefix polí: [prefix]
- DataClassification: [CustomerContent / SystemMetadata / dle pravidel GDPR]
- BC verze: [verze]

Napiš table extension.
```

---

## Šablona 7: Event subscriber

```
Potřebuji event subscriber pro [název eventu] v [codeunit/table/page].

Co má subscriber dělat: [popis]
Relevantní tabulky nebo data: [seznam]
Podmínky: [kdy má logika spustit]

BC verze: [verze]
Naming prefix: [prefix]

Napiš event subscriber s business logikou.
```

---

## Šablona 8: Analýza zákazníkova požadavku

```
Zákazník mi poslal tento požadavek pro BC:
[vlož text emailu nebo popisu]

Analyzuj a navrhni:
1. Kompletní seznam věcí k implementaci
2. Jaké BC objekty budu potřebovat
3. Edge cases, které zákazník pravděpodobně nepřemýšlel
4. Otázky pro zákazníka před implementací

BC verze: [verze]
```

---

## Šablona 9: Technická dokumentace kódu

```
Napiš technickou dokumentaci pro tento AL kód:
[vlož kód]

Dokumentace má obsahovat:
- Účel a funkce
- Popis vstupních parametrů a návratové hodnoty
- Business logika krok za krokem
- Known limitations a edge cases
- Příklad použití

Formát: Markdown. Jazyk: česky.
```

---

## Šablona 10: Generování testovacích dat

```
Potřebuji AL kód pro vytvoření testovacích dat:
[popis testovacího scénáře]

Potřebné záznamy:
- [tabulka]: [počet, klíčové hodnoty]

Závislosti: [musí existovat Y před X]
BC verze: [verze]

Napiš procedure nebo codeunit pro vytvoření dat.
```
