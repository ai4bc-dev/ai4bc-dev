page 50110 "AI Item Search"
{
    PageType = List;
    SourceTable = Item;
    Caption = 'Vyhledávání položek pomocí AI';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            group(SearchGroup)
            {
                Caption = 'Hledám';
                field(SearchQuery; SearchQueryTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Popište co hledáte';
                    ToolTip = 'Zadejte popis v přirozeném jazyce, co hledáte.';

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
                Caption = 'Vyhledat pomocí AI';
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
