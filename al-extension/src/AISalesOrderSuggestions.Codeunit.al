namespace BCDemoAI;

// AI-powered sales order suggestions based on customer purchase history
// See Chapter 29: Demo — AI Sales Suggestions
codeunit 50121 "AI Sales Order Suggestions"
{
    // Generates AI suggestions for a sales order based on customer history
    procedure GetSuggestions(CustomerNo: Code[20]): Text
    var
        HistoryReader: Codeunit "Customer History Reader";
        OpenAIHelper: Codeunit "OpenAI Helper";
        CustomerHistory: Text;
        SystemPrompt: Text;
        UserPrompt: Text;
    begin
        CustomerHistory := HistoryReader.GetCustomerHistory(CustomerNo);

        SystemPrompt :=
            'You are a Business Central sales assistant. ' +
            'Based on a customer''s purchase history, suggest items they might want to reorder. ' +
            'Be concise. List up to 5 suggestions with item descriptions and reasoning. ' +
            'Format each suggestion on a new line as: "- [Item]: [Reason]"';

        UserPrompt := StrSubstNo(
            'Customer No.: %1\n\n%2\n\nWhat items should this customer consider reordering?',
            CustomerNo,
            CustomerHistory
        );

        exit(OpenAIHelper.CallChatCompletion(SystemPrompt, UserPrompt, 500));
    end;
}
