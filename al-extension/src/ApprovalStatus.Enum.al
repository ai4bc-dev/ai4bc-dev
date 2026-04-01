// Enum pro stavy schvalovacího procesu
// Kurz "AI pro BC vývojáře" – Modul 1 Workshop
enum 50100 "ZZ Approval Status"
{
    Extensible = true;

    value(0; Pending)
    {
        Caption = 'Čeká na schválení';
    }
    value(1; Approved)
    {
        Caption = 'Schváleno';
    }
    value(2; Rejected)
    {
        Caption = 'Zamítnuto';
    }
}
