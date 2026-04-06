namespace BCDemoAI;

// Enum for approval process statuses
// Course "AI for BC Developers" — Module 1 Workshop
enum 50200 "ZZ Approval Status"
{
    Extensible = true;

    value(0; Pending)
    {
        Caption = 'Pending Approval';
    }
    value(1; Approved)
    {
        Caption = 'Approved';
    }
    value(2; Rejected)
    {
        Caption = 'Rejected';
    }
}
