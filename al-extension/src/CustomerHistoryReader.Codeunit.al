namespace BCDemoAI;

// Reads 12 months of invoice history for a customer
// See Chapter 29: Demo — AI Sales Suggestions
codeunit 50120 "Customer History Reader"
{
    // Returns a text summary of the customer's last 12 months of invoice lines
    procedure GetCustomerHistory(CustomerNo: Code[20]): Text
    var
        SalesInvLine: Record "Sales Invoice Line";
        HistoryBuilder: TextBuilder;
        StartDate: Date;
    begin
        StartDate := CalcDate('<-12M>', WorkDate());

        SalesInvLine.SetRange("Sell-to Customer No.", CustomerNo);
        SalesInvLine.SetFilter("Posting Date", '%1..', StartDate);
        SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
        SalesInvLine.SetFilter("No.", '<>%1', '');

        if not SalesInvLine.FindSet() then
            exit('No invoice history found for the last 12 months.');

        HistoryBuilder.AppendLine('Customer invoice history (last 12 months):');
        repeat
            HistoryBuilder.AppendLine(
                StrSubstNo('- %1: %2 x %3 (Amount: %4)',
                    SalesInvLine."Posting Date",
                    SalesInvLine.Quantity,
                    SalesInvLine.Description,
                    SalesInvLine."Line Amount"
                )
            );
        until SalesInvLine.Next() = 0;

        exit(HistoryBuilder.ToText());
    end;
}
