namespace BCDemoAI;

page 50110 "AI Item Search"
{
    PageType = List;
    SourceTable = Item;
    Caption = 'AI Item Search';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            group(SearchGroup)
            {
                Caption = 'Search';
                field(SearchQuery; SearchQueryTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Describe what you are looking for';
                    ToolTip = 'Enter a natural language description of what you are looking for.';

                    trigger OnValidate()
                    begin
                        RunAISearch();
                    end;
                }
            }
            repeater(ItemsGroup)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Item Category Code"; Rec."Item Category Code") { ApplicationArea = All; }
                field("Unit Price"; Rec."Unit Price") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Search)
            {
                Caption = 'Search with AI';
                Image = Find;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    RunAISearch();
                end;
            }
        }
    }

    var
        SearchQueryTxt: Text;

    local procedure RunAISearch()
    var
        SearchHelper: Codeunit "AI Item Search Helper";
        SearchParams: JsonObject;
    begin
        if SearchQueryTxt = '' then
            exit;

        SearchParams := SearchHelper.ExtractSearchParameters(SearchQueryTxt);
        Rec.Reset();
        SearchHelper.ApplySearchFilter(Rec, SearchParams);
        CurrPage.Update(false);
    end;
}
