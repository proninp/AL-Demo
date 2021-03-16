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
                    Editable = false;
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
                    SupplyMgt.ChangeStatus(Rec, Rec.Status::Verification);
                    SetControlsEnable();
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
                    SupplyMgt.ChangeStatusSelected(Rec, Rec.Status::Verification);
                    SetControlsEnable();
                end;
            }
            action(Fund)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Fund';
                Enabled = IsFundingEnable;
                Image = Cost;
                ToolTip = 'To Fund current line';
                trigger OnAction()
                begin
                    SupplyMgt.ChangeStatus(Rec, Rec.Status::Funding);
                    SetControlsEnable();
                end;
            }
            action(FundSelected)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Fund Selected';
                Enabled = IsFundingEnable;
                Image = CostCenter;
                ToolTip = 'To Fund marked lines';
                trigger OnAction()
                begin
                    SupplyMgt.ChangeStatusSelected(Rec, Rec.Status::Funding);
                    SetControlsEnable();
                end;
            }
            action(CreatePayment)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Create Payment';
                Enabled = IsCreatePaymentEnable;
                Image = VendorPayment;
                ToolTip = 'To Create payment on current line';
                trigger OnAction()
                begin
                    SupplyMgt.CreatePayment(Rec);
                    SetControlsEnable();
                end;
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        SetControlsEnable();
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        SetControlsEnable();
    end;

    var
        IsVerificateEnable: Boolean;
        IsFundingEnable: Boolean;
        IsCreatePaymentEnable: Boolean;
        SupplyMgt: Codeunit "Supply Management";

    procedure SetControlsEnable(SupplyHeader: Record "Supply Header")
    var
        SupplyMgt: Codeunit "Supply Management";
    begin
        IsVerificateEnable := SupplyMgt.IsSupplyLineExists(SupplyHeader, Status::Registration);
        IsFundingEnable := SupplyMgt.IsSupplyLineExists(SupplyHeader, Status::Verification);
        IsCreatePaymentEnable := SupplyMgt.IsSupplyLineExists(SupplyHeader, Status::Funding);
    end;

    procedure SetControlsEnable()
    var
        SupplyHeader: Record "Supply Header";
        SupplyMgt: Codeunit "Supply Management";
    begin
        if SupplyHeader.Get(Rec."Supply Journal Code") then begin
            IsVerificateEnable := SupplyMgt.IsSupplyLineExists(SupplyHeader, Status::Registration);
            IsFundingEnable := SupplyMgt.IsSupplyLineExists(SupplyHeader, Status::Verification);
            IsCreatePaymentEnable := SupplyMgt.IsSupplyLineExists(SupplyHeader, Status::Funding);
        end;
        CurrPage.Update();
    end;

}
