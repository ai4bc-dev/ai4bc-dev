# Prompt šablony pro BC konzultanty

> Knihovna šablon pro každodenní konzultantskou práci s AI.
> Zkopíruj, vyplň [závorky], pošli do Claude nebo ChatGPT.

---

## Šablona 1: Funkční specifikace ze zákazníkových poznámek

```
Jsem BC konzultant. Zákazník mi popsal tento požadavek:
[vlož zákazníkovy poznámky, email nebo zápis ze schůzky]

Vytvoř funkční specifikaci:
1. Záhlaví (název, zákazník, datum, verze – vyplň z dostupného kontextu nebo ponech jako placeholder)
2. Aktuální stav (jak to v BC funguje dnes)
3. Požadovaný stav (co se má změnit)
4. Business pravidla (podmínky a logika)
5. Edge cases a výjimky
6. Dopad na ostatní části systému
7. Otevřené otázky (co ještě potřebuji od zákazníka)

Formát: Markdown. Jazyk: česky.
```

---

## Šablona 2: Testovací scénáře ze specifikace

```
Ze této funkční specifikace vygeneruj kompletní sadu testovacích scénářů:
[vlož specifikaci]

Zahrnuj:
- Happy path
- Alternativní validní průběhy
- Chybové stavy
- Edge cases (hraniční hodnoty)

Každý scénář:
- ID: TS-[číslo]
- Název: [popis]
- Předpoklady: [co musí platit]
- Kroky: [numbered]
- Očekávaný výsledek: [co nastane]
```

---

## Šablona 2b: Iterace testovacích scénářů – zákazníkova specifika

```
K těmto testovacím scénářům přidej scénáře pro tyto specifické situace zákazníka:
[vlož stávající sadu scénářů]

Zákazníkova specifika:
- [specifická konfigurace nebo podmínka 1]
- [specifická konfigurace nebo podmínka 2]
- [specifická konfigurace nebo podmínka 3]

Zachovej formát a ID schéma stávající sady.
```

---

## Šablona 2c: Export testovacích scénářů do CSV

```
Převeď tyto testovací scénáře do formátu vhodného pro Excel – CSV formát s oddělovačem středník.
[vlož testovací scénáře]

Sloupce: ID, Název, Modul, Předpoklady, Kroky (jeden řádek s číslováním), Očekávaný výsledek, Priorita
```

---

## Šablona 3: Analýza zákazníkova požadavku

```
Zákazník mi poslal tento požadavek:
[vlož text]

Jako zkušený BC konzultant analyzuj:
1. Co zákazník pravděpodobně chce (technicky)
2. Implicitní předpoklady (co říká, ale neřekl)
3. Otázky pro zákazníka před implementací
4. Potenciální problémy s BC
5. Odhadovaný rozsah změn

BC verze: [verze]
```

---

## Šablona 3b: Příprava discovery workshopu

```
Zákazník chce provést discovery workshop na téma: [téma]
Mám tyto informace o zákazníkovi a jeho prostředí: [co víš]

Navrhni:
1. Strukturu workshopu (agenda, časový plán)
2. Klíčové otázky, které bych měl položit
3. Oblasti, kde BC typicky naráží na problémy pro tento typ požadavku
4. Dokumenty nebo data, která bych měl zákazníka poprosit přinést
```

---

## Šablona 3c: Zákazníkův požadavek jako user story

```
Zákazníkův požadavek byl: [text]
Přeformuluj ho jako user story ve formátu:
"Jako [role], chci [akce], abych [business hodnota]."
Přidej Acceptance Criteria (min. 5 bodů).
```

---

## Šablona 4: Uživatelský návod

```
Napiš uživatelský návod pro BC proces:
[popis procesu]

Cílová skupina: [kdo to bude číst]
BC verze: [verze]

Formát:
1. Úvod (k čemu slouží)
2. Kdy použít
3. Postup krok za krokem
4. Časté chyby a řešení
5. Poznámky a tipy

Jazyk: jednoduchý, bez IT žargonu.
```

---

## Šablona 4b: Aktualizace existující dokumentace

```
Toto je existující uživatelský návod:
[vlož text]

Zákazník přidal tuto změnu: [popis změny].

Aktualizuj návod o tuto změnu tak, aby byl konzistentní se stávajícím textem a formátem.
```

---

## Šablona 4c: Release notes z git logu

```
Toto jsou git commity za posledních [X] dní:
[vlož git log výstup]

Vytvoř release notes pro zákazníka v business jazyce.
Formát:
- Verze a datum
- Nové funkce (popis pro uživatele, ne pro vývojáře)
- Opravené chyby (pokud jsou relevantní pro uživatele)
- Změny v nastavení (pokud jsou potřeba akce ze strany zákazníka)

Zákazník není technický. Nevysvětluj jak věci fungují interně.
```

---

## Šablona 5: Zápis ze schůzky

```
Napiš formální zápis ze schůzky z těchto poznámek:
[vlož hrubé poznámky]

Formát:
1. Datum, účastníci, místo
2. Program
3. Projednané body
4. Rozhodnutí
5. Akční body (co, kdo, do kdy)
6. Termín příští schůzky

Tón: formální, česky.
```

---

## Šablona 6: Email zákazníkovi o problému nebo zpoždění

```
Napiš profesionální email zákazníkovi:
Situace: [popis problému nebo zpoždění]
Co chci sdělit: [klíčové body]
Co nechci říct: [citlivá témata]
Tón: [profesionální přátelský / formální]
```

---

## Šablona 6b: Odmítnutí mimo-scope požadavku

```
Zákazník požaduje: [co chce]
Proč to nemůžeme dodat: [technický nebo business důvod]
Co mu místo toho nabídneme: [alternativa]

Napiš email, který odmítne požadavek profesionálně, vysvětlí proč, a nabídne alternativu. Zákazník nesmí mít pocit, že ho odmítáme, ale musí pochopit omezení.
```

---

## Šablona 6c: Týdenní status report

```
Napiš týdenní status report projektu pro zákazníka:

Projekt: [název]
Stav: [% dokončení nebo fáze]
Co bylo hotovo tento týden: [body]
Co bude hotovo příští týden: [body]
Rizika nebo problémy: [pokud jsou]
Požadované rozhodnutí nebo informace od zákazníka: [pokud jsou]

Formát: Krátký email, ne více než jedna stránka, přátelský tón.
```

---

## Šablona 7: Troubleshooting BC chyby

```
Zákazník dostává tuto BC chybu:
[přesný text chyby]

BC verze: [verze]
Kdy nastává: [popis akce]
Relevantní konfigurace: [pokud víš]

Analyzuj příčiny (seřaď od nejpravděpodobnější) a navrhni postup diagnostiky.
```

---

## Šablona 7b: Troubleshooting s kontextem customizace

```
Zákazník má tyto nestandardní konfigurace:
- [customizace nebo extension]
- [specifické nastavení]

Při [akce] dochází k tomuto chování: [popis].

Které části systému by to mohlo způsobovat? Jak bych postupoval při diagnostice?
```

---

## Šablona 7c: Diagnostické instrukce pro zákazníka

```
Zákazník popisuje tento problém: [popis].
Zákazník není technický.

Navrhni kroky, které mu můžu dát jako instrukce pro základní diagnostiku.
Kroky musí být jednoduché a popsané v neIT jazyce.
```

---

## Šablona 8: SQL dotaz pro BC data

```
Potřebuji SQL dotaz pro BC databázi:
[popis co chci zjistit]

BC verze: [verze]
Podmínky: [filtry, časové rozsahy]

Napiš SELECT dotaz s vysvětlením použitých tabulek a jejich vztahů.
```

---

## Šablona 8b: Optimalizace pomalého SQL dotazu

```
Tento SQL dotaz na BC databázi je pomalý (běží [X]+ sekund):
[vlož dotaz]

BC verze: [verze], odhadovaný počet záznamů v hlavní tabulce: [odhad]

Analyzuj proč je pomalý a navrhni optimalizaci. Vysvětli každou změnu.
```

---

## Šablona 8c: Diagnostika datových anomálií

```
Zákazník hlásí: [popis nesouladu nebo anomálie v datech].

Navrhni SQL dotazy pro diagnostiku:
1. [oblast 1 k ověření]
2. [oblast 2 k ověření]
3. [oblast 3 k ověření]

BC verze: [verze]
```
