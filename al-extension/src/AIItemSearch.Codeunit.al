codeunit 50111 "AI Item Search Helper"
{
    // AI vyhledávání v přirozeném jazyce
    // Viz kapitola 28: Demo – AI-powered vyhledávání v BC

    procedure ExtractSearchParameters(NaturalLanguageQuery: Text): JsonObject
    var
        OpenAIHelper: Codeunit "OpenAI Helper";
        SystemPrompt: Text;
        AIResponse: Text;
        ResultJson: JsonObject;
    begin
        SystemPrompt := 'Jsi asistent pro vyhledávání v skladovém systému Business Central. ' +
            'Uživatel popíše co hledá, ty extrahuješ klíčová slova a parametry. ' +
            'Vždy odpovídej POUZE validním JSON objektem v tomto formátu: ' +
            '{"keywords": ["slovo1", "slovo2"], "category_hint": "nazev_kategorie_nebo_null", ' +
            '"description_filter": "klicove_slovo_pro_LIKE_filtr"}.';

        AIResponse := OpenAIHelper.CallChatCompletion(
            SystemPrompt, NaturalLanguageQuery, 200);

        if not ResultJson.ReadFrom(AIResponse) then begin
            // Fallback: pokud AI nevrátila validní JSON, použijeme přímé vyhledávání
            ResultJson.Add('description_filter', NaturalLanguageQuery);
        end;

        exit(ResultJson);
    end;

    procedure ApplySearchFilter(var Item: Record Item; SearchParams: JsonObject)
    var
        DescriptionFilterToken: JsonToken;
        CategoryHintToken: JsonToken;
        DescriptionFilter: Text;
        CategoryHint: Text;
    begin
        if SearchParams.Get('description_filter', DescriptionFilterToken) then begin
            DescriptionFilter := DescriptionFilterToken.AsValue().AsText();
            if DescriptionFilter <> '' then
                Item.SetFilter(Description, '@*' + DescriptionFilter + '*');
        end;

        if SearchParams.Get('category_hint', CategoryHintToken) then begin
            CategoryHint := CategoryHintToken.AsValue().AsText();
            if (CategoryHint <> '') and (CategoryHint <> 'null') then
                Item.SetFilter("Item Category Code", CategoryHint);
        end;
    end;
}
