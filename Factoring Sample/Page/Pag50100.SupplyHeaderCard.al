page 50100 "Supply Header Card"
{
    Caption = 'Supply Header Card';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Order,Request Approval,History,Print/Send,Navigate';
    RefreshOnActivate = true;
    SourceTable = "Supply Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("External Agreement No."; Rec."External Agreement No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Agreement No."; Rec."Agreement No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Supply Date"; Rec."Supply Date")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Other)
            {
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Created User ID"; Rec."Created User ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Lines Amount"; Rec."Lines Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Lines Count"; Rec."Lines Count")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            part(SupplyLines; "Supply Subform")
            {
                ApplicationArea = Basic, Suite;
                Editable = DynamicEditable;
                Enabled = "Customer No." <> '';
                SubPageLink = "Supply Journal Code" = field("No.");
                UpdatePropagation = Both;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        DynamicEditable := CurrPage.Editable;
        CurrPage.SupplyLines.Page.SetControlsEnable(Rec);
    end;

    var
        SupplyMgt: Codeunit "Supply Management";
        DynamicEditable: Boolean;
}
