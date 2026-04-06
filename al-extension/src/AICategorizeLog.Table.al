namespace BCDemoAI;

// Table for logging AI categorization results
// See Chapter 27: Demo — Automatic Item Categorization
table 50102 "AI Categorization Log"
{
    Caption = 'AI Categorization Log';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(3; "Suggested Category"; Code[20])
        {
            Caption = 'Suggested Category';
        }
        field(4; "Applied Category"; Code[20])
        {
            Caption = 'Applied Category';
            TableRelation = "Item Category".Code;
        }
        field(5; "Processing DateTime"; DateTime)
        {
            Caption = 'Processing DateTime';
        }
        field(6; "Tokens Used"; Integer)
        {
            Caption = 'Tokens Used';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(K1; "Item No.") { }
    }
}
