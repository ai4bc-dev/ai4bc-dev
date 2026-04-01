// Codeunit pro emailové notifikace schvalovacího procesu
// Generováno Claude Code, opraveno: použití Email codeunit místo SMTP Management (BC v27)
codeunit 50101 "ZZ Purchase Approval Email"
{
    // Pošle emailové oznámení schvalovateli
    procedure SendApprovalRequest(ApprovalEntry: Record "ZZ Purchase Approval Entry")
    var
        PurchHeader: Record "Purchase Header";
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Recipients: List of [Text];
        Subject: Text;
        Body: Text;
    begin
        if not PurchHeader.Get(PurchHeader."Document Type"::Order, ApprovalEntry."Purchase Order No.") then
            exit;

        Recipients.Add(GetUserEmail(ApprovalEntry."Approver User ID"));
        if Recipients.Count = 0 then
            exit; // Bez emailu notifikaci nepošleme

        Subject := StrSubstNo('Žádost o schválení objednávky %1', ApprovalEntry."Purchase Order No.");

        Body := StrSubstNo(
            '<p>Dobrý den,</p>' +
            '<p>žadatel <b>%1</b> požaduje schválení nákupní objednávky č. <b>%2</b>.</p>' +
            '<p>Dodavatel: %3<br/>Celková hodnota: %4 Kč</p>' +
            '<p>Pro schválení nebo zamítnutí přejděte do Business Central → Purchase Approval Entries.</p>',
            ApprovalEntry."Requester User ID",
            ApprovalEntry."Purchase Order No.",
            PurchHeader."Buy-from Vendor Name",
            Format(ApprovalEntry."Order Amount", 0, '<Integer Thousand><Decimals,2>')
        );

        EmailMessage.Create(Recipients, Subject, Body, true);
        Email.Send(EmailMessage);
    end;

    // Pošle notifikaci žadateli o zamítnutí
    procedure SendRejectionNotification(ApprovalEntry: Record "ZZ Purchase Approval Entry")
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Recipients: List of [Text];
        Subject: Text;
        Body: Text;
    begin
        Recipients.Add(GetUserEmail(ApprovalEntry."Requester User ID"));
        if Recipients.Count = 0 then
            exit;

        Subject := StrSubstNo('Objednávka %1 byla zamítnuta', ApprovalEntry."Purchase Order No.");

        Body := StrSubstNo(
            '<p>Dobrý den,</p>' +
            '<p>vaše žádost o schválení objednávky č. <b>%1</b> byla <b>zamítnuta</b>.</p>' +
            '<p>Důvod: %2</p>' +
            '<p>Kontaktujte vedoucího nákupu pro další informace.</p>',
            ApprovalEntry."Purchase Order No.",
            ApprovalEntry."Rejection Comment"
        );

        EmailMessage.Create(Recipients, Subject, Body, true);
        Email.Send(EmailMessage);
    end;

    // Načte email adresu uživatele
    local procedure GetUserEmail(UserID: Code[50]): Text
    var
        UserRecord: Record User;
    begin
        if UserRecord.Get(UserID) then
            exit(UserRecord."Contact Email");
        exit('');
    end;
}
