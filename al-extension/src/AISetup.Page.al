namespace BCDemoAI;

page 50101 "AI Categorization Setup"
{
    PageType = Card;
    SourceTable = "AI Categorization Setup";
    Caption = 'AI Categorization Setup';
    ApplicationArea = All;
    UsageCategory = Administration;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(AzureOpenAI)
            {
                Caption = 'Azure OpenAI';

                field("Endpoint URL"; Rec."Endpoint URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'URL of your Azure OpenAI resource, e.g. https://my-ai.openai.azure.com/';
                }
                field("Deployment Name"; Rec."Deployment Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Model deployment name in Azure, e.g. gpt4o-mini-v1';
                }
                field("API Version"; Rec."API Version")
                {
                    ApplicationArea = All;
                }
                field(ApiKeyStatus; ApiKeyStatusTxt)
                {
                    ApplicationArea = All;
                    Caption = 'API Key';
                    Editable = false;
                    StyleExpr = ApiKeyStyle;
                }
            }
            group(Parameters)
            {
                Caption = 'AI Parameters';

                field("Max Tokens"; Rec."Max Tokens")
                {
                    ApplicationArea = All;
                }
                field(Temperature; Rec.Temperature)
                {
                    ApplicationArea = All;
                }
                field("Batch Size"; Rec."Batch Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'Number of items to process in a single batch.';
                }
                field("Delay Between Calls Ms"; Rec."Delay Between Calls Ms")
                {
                    ApplicationArea = All;
                    ToolTip = 'Delay in milliseconds between API calls to avoid rate limiting.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SetApiKey)
            {
                Caption = 'Set API Key';
                Image = EncryptionKeys;
                ApplicationArea = All;

                trigger OnAction()
                var
                    KeyMgr: Codeunit "AI Key Manager";
                    ApiKeyInput: Text;
                begin
                    // In production: use a dedicated page for key input
                    ApiKeyInput := '';
                    if ApiKeyInput <> '' then begin
                        KeyMgr.StoreApiKey(ApiKeyInput);
                        UpdateApiKeyStatus();
                        CurrPage.Update(false);
                    end;
                end;
            }
            action(TestConnection)
            {
                Caption = 'Test Connection';
                Image = TestReport;
                ApplicationArea = All;

                trigger OnAction()
                var
                    OpenAIHelper: Codeunit "OpenAI Helper";
                    Response: Text;
                begin
                    Response := OpenAIHelper.CallChatCompletionSimple('Say "OK".');
                    Message('Connection works. AI responded: %1', Response);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.GetSetup();
        UpdateApiKeyStatus();
    end;

    var
        ApiKeyStatusTxt: Text;
        ApiKeyStyle: Text;

    local procedure UpdateApiKeyStatus()
    var
        KeyMgr: Codeunit "AI Key Manager";
    begin
        if KeyMgr.HasApiKey() then begin
            ApiKeyStatusTxt := 'Configured';
            ApiKeyStyle := 'Favorable';
        end else begin
            ApiKeyStatusTxt := 'Not configured';
            ApiKeyStyle := 'Unfavorable';
        end;
    end;
}
