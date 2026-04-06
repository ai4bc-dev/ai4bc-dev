namespace BCDemoAI;

codeunit 50111 "AI Item Search Helper"
{
    // AI natural language search
    // See Chapter 28: Demo — AI-powered Search in BC

    procedure ExtractSearchParameters(NaturalLanguageQuery: Text): JsonObject
    var
        OpenAIHelper: Codeunit "OpenAI Helper";
        SystemPrompt: Text;
        AIResponse: Text;
        ResultJson: JsonObject;
    begin
        SystemPrompt := 'You are an assistant for searching in the Business Central inventory system. ' +
            'The user describes what they are looking for, and you extract keywords and parameters. ' +
            'Always respond ONLY with a valid JSON object in this format: ' +
            '{"keywords": ["word1", "word2"], "category_hint": "category_name_or_null", ' +
            '"description_filter": "keyword_for_LIKE_filter"}.';

        AIResponse := OpenAIHelper.CallChatCompletion(
            SystemPrompt, NaturalLanguageQuery, 200);

        if not ResultJson.ReadFrom(AIResponse) then begin
            // Fallback: if AI didn't return valid JSON, use direct search
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
