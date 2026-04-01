codeunit 50102 "Item AI Categorizer"
{
    // Automatická kategorizace položek pomocí Azure OpenAI
    // Viz kapitola 27: Demo – Automatická kategorizace položek

    procedure CategorizeAllItems()
    var
        Item: Record Item;
        OpenAIHelper: Codeunit "OpenAI Helper";
        CategoryList: Text;
        Prompt: Text;
        SuggestedCategory: Text;
        ProcessedCount: Integer;
        TotalItems: Integer;
        ProgressDialog: Dialog;
    begin
        CategoryList := GetCategoryList();

        if CategoryList = '' then
            Error('Nejsou definovány žádné kategorie položek.');

        Item.SetFilter("Item Category Code", '%1', '');
        Item.SetFilter(Description, '<>%1', '');

        if Item.IsEmpty() then begin
            Message('Všechny položky jsou již zakategorizovány.');
            exit;
        end;

        TotalItems := Item.Count();
        ProgressDialog.Open('Kategorizace položek pomocí AI...\Zpracovávám: #1####\Hotovo: #2#### / #3####');

        if Item.FindSet() then
            repeat
                ProcessedCount += 1;
                ProgressDialog.Update(1, Item.Description);
                ProgressDialog.Update(2, ProcessedCount);
                ProgressDialog.Update(3, TotalItems);

                Prompt := BuildCategorizationPrompt(Item.Description, CategoryList);
                SuggestedCategory := OpenAIHelper.CallChatCompletionSimple(Prompt);
                SuggestedCategory := CleanAndValidateCategory(SuggestedCategory);

                if SuggestedCategory <> '' then begin
                    Item."Item Category Code" := SuggestedCategory;
                    Item.Modify(true);
                end;
            until Item.Next() = 0;

        ProgressDialog.Close();
        Message('Hotovo! Zpracováno %1 položek.', ProcessedCount);
    end;

    local procedure BuildCategorizationPrompt(ItemDescription: Text; CategoryList: Text): Text
    var
        PromptBuilder: TextBuilder;
    begin
        PromptBuilder.Append('Jsi asistent pro kategorizaci skladových položek v Business Central.');
        PromptBuilder.Append(' Tvůj úkol je přiřadit JEDNU kategorii k následující položce.');
        PromptBuilder.Append(' Odpovídej POUZE kódem kategorie, nic jiného.');
        PromptBuilder.AppendLine();
        PromptBuilder.Append('Dostupné kategorie: ');
        PromptBuilder.Append(CategoryList);
        PromptBuilder.AppendLine();
        PromptBuilder.Append('Položka k zařazení: ');
        PromptBuilder.Append(ItemDescription);
        PromptBuilder.AppendLine();
        PromptBuilder.Append('Kategorie:');
        exit(PromptBuilder.ToText());
    end;

    local procedure CleanAndValidateCategory(AIResponse: Text): Text
    var
        CleanedResponse: Text;
        ItemCategory: Record "Item Category";
    begin
        CleanedResponse := AIResponse.Trim();
        CleanedResponse := CleanedResponse.ToUpper();

        if ItemCategory.Get(CleanedResponse) then
            exit(CleanedResponse);

        ItemCategory.SetFilter(Code, '@' + CleanedResponse + '*');
        if ItemCategory.FindFirst() then
            exit(ItemCategory.Code);

        exit('');
    end;

    local procedure GetCategoryList(): Text
    var
        ItemCategory: Record "Item Category";
        Builder: TextBuilder;
    begin
        if ItemCategory.FindSet() then
            repeat
                if Builder.Length() > 0 then
                    Builder.Append(', ');
                Builder.Append(ItemCategory.Code);
            until ItemCategory.Next() = 0;
        exit(Builder.ToText());
    end;
}
