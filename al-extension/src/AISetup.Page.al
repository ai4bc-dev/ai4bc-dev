page 50101 "AI Categorization Setup"
{
    PageType = Card;
    SourceTable = "AI Categorization Setup";
    Caption = 'Nastavení AI kategorizace';
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
                    ToolTip = 'URL vašeho Azure OpenAI resource, např. https://moje-ai.openai.azure.com/';
                }
                field("Deployment Name"; Rec."Deployment Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Název modelu deployment v Azure, např. gpt4o-mini-v1';
                }
                field("API Version"; Rec."API Version")
                {
                    ApplicationArea = All;
                }
                field(ApiKeyStatus; ApiKeyStatusTxt)
                {
                    ApplicationArea = All;
                    Caption = 'API klíč';
                    Editable = false;
                    StyleExpr = ApiKeyStyle;
                }
            }
            group(Parameters)
            {
                Caption = 'Parametry AI';

                field("Max Tokens"; Rec."Max Tokens")
                {
                    ApplicationArea = All;
                }
                field(Temperature; Rec.Temperature)
                {
                    ApplicationArea = All;
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
                Caption = 'Nastavit API klíč';
                Image = EncryptionKeys;
                ApplicationArea = All;

                trigger OnAction()
                var
                    KeyMgr: Codeunit "AI Key Manager";
                    ApiKeyInput: Text;
                begin
                    // V produkci: použijte dedikovanou stránku pro vstup klíče
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
                Caption = 'Otestovat spojení';
                Image = TestReport;
                ApplicationArea = All;

                trigger OnAction()
                var
                    OpenAIHelper: Codeunit "OpenAI Helper";
                    Response: Text;
                begin
                    Response := OpenAIHelper.CallChatCompletionSimple('Řekni "OK".');
                    Message('Spojení funguje. AI odpověděla: %1', Response);
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
            ApiKeyStatusTxt := 'Nastaven';
            ApiKeyStyle := 'Favorable';
        end else begin
            ApiKeyStatusTxt := 'Není nastaven';
            ApiKeyStyle := 'Unfavorable';
        end;
    end;
}
