namespace BCDemoAI;

// FactBox page extension on Sales Order showing AI suggestions
// See Chapter 29: Demo — AI Sales Suggestions
pageextension 50100 "Sales Order AI FactBox" extends "Sales Order"
{
    layout
    {
        addlast(FactBoxArea)
        {
            part(AISuggestions; "AI Sales Suggestions FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Sell-to Customer No.");
            }
        }
    }
}
