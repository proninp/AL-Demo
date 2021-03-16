page 50101 "Supply Subform"
{
    AutoSplitKey = true;
    Caption = 'Supply Subform';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Supply Line";
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Supply Journal Code"; Rec."Supply Journal Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the document number.';
                    Visible = false;
                }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the line number.';
                    Visible = false;
                }
                field("Supply No."; Rec."Supply No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Extenal Document No."; Rec."Extenal Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Vendor Agreement"; "Vendor Agreement")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("External Supply Date"; Rec."External Supply Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(CreationDate; "Creation Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Delay; Rec.Delay)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Delay Date"; Rec."Delay Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Supply Ledger Entry Amount"; Rec."Supply Ledger Entry Amount")
                {
                    ApplicationArea = Basic, Suite;
                    trigger OnDrillDown()
                    begin
                        OpenSupplyLedgerEntry();
                    end;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Verificate)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Verificate';
                Enabled = IsVerificateEnable;
                Image = PostedPayableVoucher;
                ToolTip = 'Verificate current line';

                trigger OnAction()
                begin
                    SupplyMgt.Verificate(Rec);
                end;
            }
            action(VerificateSelected)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Verificate Selected';
                Enabled = IsVerificateEnable;
                Image = PostedVoucherGroup;
                ToolTip = 'Verificate marked lines';

                trigger OnAction()
                begin
                    SupplyMgt.VerificateSelected(Rec);
                    CurrPage.Update();
                end;
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        IsVerificateEnable := true;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        IsVerificateEnable := not Rec.IsEmpty;
    end;

    var
        IsVerificateEnable: Boolean;
        SupplyMgt: Codeunit "Supply Management";

    procedure SetVerificateEnable(IsEnableP: Boolean)
    begin
        IsVerificateEnable := IsEnableP;
    end;

}
