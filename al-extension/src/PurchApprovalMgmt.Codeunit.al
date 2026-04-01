// Codeunit pro business logiku schvalování nákupních objednávek
// Generováno Claude Code, ručně přidáno: permission check, GDPR DataClassification, pending check
codeunit 50100 "ZZ Purchase Approval Mgmt"
{
    // Schvalovací limit – bude v Setup tabulce ve verzi 2
    var
        ApprovalLimit: Decimal;

    trigger OnRun()
    begin
        ApprovalLimit := 50000;
    end;

    // Požádá o schválení nákupní objednávky
    procedure RequestApproval(var PurchHeader: Record "Purchase Header")
    var
        ApprovalEntry: Record "ZZ Purchase Approval Entry";
        ApprovalEmail: Codeunit "ZZ Purchase Approval Email";
    begin
        // Validace – pouze pro nákupní objednávky
        PurchHeader.TestField("Document Type", PurchHeader."Document Type"::Order);

        // Zkontroluj zda objednávka překračuje limit
        if PurchHeader."Amount Including VAT" <= ApprovalLimit then
            exit;

        // Zkontroluj zda již není otevřená žádost (ručně přidáno – AI to vynechal)
        ApprovalEntry.SetRange("Purchase Order No.", PurchHeader."No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Pending);
        if not ApprovalEntry.IsEmpty() then
            Error('Pro tuto objednávku již existuje otevřená žádost o schválení.');

        // Vytvoř záznam žádosti
        ApprovalEntry.Init();
        ApprovalEntry."Purchase Order No." := PurchHeader."No.";
        ApprovalEntry."Order Amount" := PurchHeader."Amount Including VAT";
        ApprovalEntry.Status := ApprovalEntry.Status::Pending;
        ApprovalEntry."Requester User ID" := UserId();
        ApprovalEntry."Request Date Time" := CurrentDateTime();
        ApprovalEntry."Approver User ID" := GetDefaultApprover();
        ApprovalEntry.Insert(true);

        // Pošli emailové oznámení
        ApprovalEmail.SendApprovalRequest(ApprovalEntry);

        Message('Žádost o schválení byla odeslána vedoucímu nákupu.');
    end;

    // Schválí nákupní objednávku
    procedure ApproveOrder(ApprovalEntryNo: Integer)
    var
        ApprovalEntry: Record "ZZ Purchase Approval Entry";
    begin
        ApprovalEntry.Get(ApprovalEntryNo);

        if ApprovalEntry.Status <> ApprovalEntry.Status::Pending then
            Error('Tato žádost již byla zpracována (stav: %1).', ApprovalEntry.Status);

        // Permission check – přidáno ručně po AI code review
        if ApprovalEntry."Approver User ID" <> UserId() then
            Error('Nemáte oprávnění schválit tuto žádost.');

        ApprovalEntry.Status := ApprovalEntry.Status::Approved;
        ApprovalEntry."Decision Date Time" := CurrentDateTime();
        ApprovalEntry.Modify(true);

        Message('Objednávka %1 byla schválena.', ApprovalEntry."Purchase Order No.");
    end;

    // Zamítne nákupní objednávku
    procedure RejectOrder(ApprovalEntryNo: Integer; Comment: Text[250])
    var
        ApprovalEntry: Record "ZZ Purchase Approval Entry";
        ApprovalEmail: Codeunit "ZZ Purchase Approval Email";
    begin
        ApprovalEntry.Get(ApprovalEntryNo);

        if ApprovalEntry.Status <> ApprovalEntry.Status::Pending then
            Error('Tato žádost již byla zpracována (stav: %1).', ApprovalEntry.Status);

        if ApprovalEntry."Approver User ID" <> UserId() then
            Error('Nemáte oprávnění zamítnout tuto žádost.');

        // Komentář povinný při zamítnutí
        if Comment = '' then
            Error('Při zamítnutí musíte zadat důvod.');

        ApprovalEntry.Status := ApprovalEntry.Status::Rejected;
        ApprovalEntry."Rejection Comment" := Comment;
        ApprovalEntry."Decision Date Time" := CurrentDateTime();
        ApprovalEntry.Modify(true);

        // Notifikuj žadatele
        ApprovalEmail.SendRejectionNotification(ApprovalEntry);

        Message('Objednávka %1 byla zamítnuta.', ApprovalEntry."Purchase Order No.");
    end;

    // Vrátí výchozího schvalovatele – placeholder pro demo
    local procedure GetDefaultApprover(): Code[50]
    begin
        // TODO v2: Načíst z ZZ Purchase Approval Setup tabulky
        exit('ADMIN');
    end;
}
