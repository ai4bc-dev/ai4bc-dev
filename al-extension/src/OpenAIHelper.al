namespace BCDemoAI;

// =============================================================================
// codeunit 50100 "OpenAI Helper"
//
// Účel: Volání Azure OpenAI Chat Completions API z AL kódu.
// Lekce: Modul 3 – lekce 2, 3, 4, 5
//
// Použití:
//   var
//       OpenAIHelper: Codeunit "OpenAI Helper";
//       Odpoved: Text;
//   begin
//       Odpoved := OpenAIHelper.CallChatCompletionSimple('Kategorizuj tuto položku: ' + Item.Description);
//   end;
//
// Konfigurace: Endpoint URL a API klíč se ukládají přes codeunit "OpenAI Setup Mgt."
// NIKDY nekódujte API klíč přímo do zdrojového kódu!
// =============================================================================
codeunit 50100 "OpenAI Helper"
{
    // Hlavní procedura: volání Azure OpenAI Chat Completions API
    // SystemPrompt: instrukce pro AI (role, kontext, formát odpovědi)
    // UserPrompt: konkrétní dotaz nebo data ke zpracování
    // MaxTokens: maximální délka odpovědi (výchozí: 500)
    // Vrací: text odpovědi AI nebo vyvolá chybu při selhání
    procedure CallChatCompletion(SystemPrompt: Text; UserPrompt: Text; MaxTokens: Integer): Text
    var
        Client: HttpClient;
        RequestMsg: HttpRequestMessage;
        ResponseMsg: HttpResponseMessage;
        RequestBody: HttpContent;
        RequestHeaders: HttpHeaders;
        ContentHeaders: HttpHeaders;
        JsonBody: JsonObject;
        JsonMessages: JsonArray;
        JsonSystemMsg: JsonObject;
        JsonUserMsg: JsonObject;
        ResponseText: Text;
        RequestBodyText: Text;
        EndpointUrl: Text;
        ApiKey: Text;
        StatusCode: Integer;
    begin
        // Získat konfiguraci (endpoint URL a API klíč) ze setup tabulky
        GetOpenAIConfig(EndpointUrl, ApiKey);

        // Sestavit pole zpráv – systémová instrukce + uživatelský dotaz
        // Tato struktura je standard ChatCompletion API
        JsonSystemMsg.Add('role', 'system');
        JsonSystemMsg.Add('content', SystemPrompt);
        JsonMessages.Add(JsonSystemMsg);

        JsonUserMsg.Add('role', 'user');
        JsonUserMsg.Add('content', UserPrompt);
        JsonMessages.Add(JsonUserMsg);

        // Sestavit tělo požadavku
        // Poznámka: 'model' ignoruje Azure (tam záleží na deployment URL),
        // ale uvádíme ho pro čitelnost a kompatibilitu
        JsonBody.Add('model', 'gpt-4o-mini');
        JsonBody.Add('messages', JsonMessages);
        JsonBody.Add('max_tokens', MaxTokens);
        // temperature 0.2 = konzistentní, deterministické odpovědi (vhodné pro kategorizaci)
        // Pro kreativní úkoly zvyšte na 0.7–1.0
        JsonBody.Add('temperature', 0.2);

        // Převést JSON na text a vložit do těla požadavku
        JsonBody.WriteTo(RequestBodyText);
        RequestBody.WriteFrom(RequestBodyText);

        // Nastavit Content-Type hlavičku na těle požadavku
        RequestBody.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/json');

        // Sestavit HTTP požadavek
        RequestMsg.SetRequestUri(EndpointUrl);
        RequestMsg.Method := 'POST';

        // Přidat autentizační hlavičku – Azure OpenAI používá 'api-key', ne 'Authorization: Bearer'
        RequestMsg.GetHeaders(RequestHeaders);
        RequestHeaders.Add('api-key', ApiKey);

        RequestMsg.Content := RequestBody;

        // Odeslat požadavek
        if not Client.Send(RequestMsg, ResponseMsg) then
            Error('Nepodařilo se připojit k Azure OpenAI API. Zkontrolujte síťové připojení a endpoint URL.');

        // Zkontrolovat HTTP status kód
        StatusCode := ResponseMsg.HttpStatusCode();
        if StatusCode <> 200 then begin
            ResponseMsg.Content.ReadAs(ResponseText);
            Error('Azure OpenAI API vrátilo chybu %1: %2', StatusCode, ResponseText);
        end;

        // Přečíst a parsovat odpověď
        ResponseMsg.Content.ReadAs(ResponseText);
        exit(ParseChatResponse(ResponseText));
    end;

    // Zjednodušená verze pro rychlé použití bez systémového promptu
    // Vhodné pro jednoduché úkoly kde nepotřebujete přesnou instrukci
    procedure CallChatCompletionSimple(UserPrompt: Text): Text
    begin
        exit(CallChatCompletion(
            'Jsi asistent pro Business Central. Odpovídej stručně a věcně.',
            UserPrompt,
            500
        ));
    end;

    // Parsování JSON odpovědi z Azure OpenAI
    // Struktura odpovědi: { "choices": [ { "message": { "content": "..." } } ] }
    local procedure ParseChatResponse(ResponseText: Text): Text
    var
        JsonResponse: JsonObject;
        JsonChoicesToken: JsonToken;
        JsonChoices: JsonArray;
        JsonFirstChoice: JsonToken;
        JsonMessage: JsonToken;
        JsonContent: JsonToken;
        ResultText: Text;
    begin
        // Parsovat kořenový JSON objekt
        if not JsonResponse.ReadFrom(ResponseText) then
            Error('Nepodařilo se parsovat odpověď z Azure OpenAI API.');

        // Získat token pro pole "choices"
        if not JsonResponse.Get('choices', JsonChoicesToken) then
            Error('Odpověď Azure OpenAI neobsahuje pole "choices".');

        JsonChoices := JsonChoicesToken.AsArray();

        // Vzít první choice (index 0) – pro Chat Completions je vždy jen jedna
        if not JsonChoices.Get(0, JsonFirstChoice) then
            Error('Pole "choices" je prázdné – API nevrátilo žádnou odpověď.');

        // Navigovat do choices[0].message.content
        if not JsonFirstChoice.AsObject().Get('message', JsonMessage) then
            Error('Odpověď neobsahuje pole "message".');

        if not JsonMessage.AsObject().Get('content', JsonContent) then
            Error('Odpověď neobsahuje pole "content".');

        ResultText := JsonContent.AsValue().AsText();

        // Ořezat bílé znaky ze začátku a konce (AI občas přidá newline)
        exit(ResultText.Trim());
    end;

    // Načtení konfigurace z setup tabulky
    // V produkčním nasazení implementujte codeunit "OpenAI Setup Mgt."
    // který čte z BC setup tabulky nebo Isolated Storage
    local procedure GetOpenAIConfig(var EndpointUrl: Text; var ApiKey: Text)
    var
        OpenAISetupMgt: Codeunit "OpenAI Setup Mgt.";  // codeunit 50101 – viz README
    begin
        OpenAISetupMgt.GetConfig(EndpointUrl, ApiKey);

        // Základní validace – raději selhat s jasnou chybou než s kryptickým 401
        if EndpointUrl = '' then
            Error('Azure OpenAI endpoint URL není nakonfigurován. Jděte do nastavení AI integrace.');
        if ApiKey = '' then
            Error('Azure OpenAI API klíč není nakonfigurován. Jděte do nastavení AI integrace.');
    end;
}
