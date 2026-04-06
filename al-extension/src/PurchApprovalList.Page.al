namespace BCDemoAI;

// List page for purchase order approval entries
// Module 1 Workshop — UI for approvers
page 50200 "ZZ Purchase Approval List"
{
    PageType = List;
    SourceTable = "ZZ Purchase Approval Entry";
    Caption = 'Purchase Approval List';
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(ApprovalEntries)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique entry number for the approval request.';
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'The purchase order number being approved.';
                }
                field("Requester User ID"; Rec."Requester User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'The user who requested approval.';
                }
                field("Request Date Time"; Rec."Request Date Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date and time when the approval was requested.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Current status of the approval request.';
                }
                field("Rejection Comment"; Rec."Rejection Comment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Comment provided when the request was rejected.';
                }
                field("Approver User ID"; Rec."Approver User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'The user who approved or rejected the request.';
                }
                field("Decision Date Time"; Rec."Decision Date Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date and time when the decision was made.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Approve)
            {
                Caption = 'Approve';
                Image = Approve;
                ApplicationArea = All;
                ToolTip = 'Approve the selected purchase order.';

                trigger OnAction()
                var
                    ApprovalMgmt: Codeunit "ZZ Purchase Approval Mgmt";
                begin
                    ApprovalMgmt.ApproveOrder(Rec."Entry No.");
                    CurrPage.Update(false);
                end;
            }
            action(Reject)
            {
                Caption = 'Reject';
                Image = Reject;
                ApplicationArea = All;
                ToolTip = 'Reject the selected purchase order.';

                trigger OnAction()
                var
                    ApprovalMgmt: Codeunit "ZZ Purchase Approval Mgmt";
                    Comment: Text[250];
                begin
                    Comment := '';
                    ApprovalMgmt.RejectOrder(Rec."Entry No.", Comment);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
