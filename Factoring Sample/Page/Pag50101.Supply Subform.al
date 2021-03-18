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
                field("Vendor Agreement"; "Vendor Agreement No.")
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
                var
                    SupplyMgt: Codeunit "Supply Management";
                begin
                    SupplyMgt.ChangeStatus(Rec, Rec.Status::Verification);
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
                var
                    SupplyMgt: Codeunit "Supply Management";
                begin
                    SupplyMgt.ChangeStatusSelected(Rec, Rec.Status::Verification);
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
                var
                    SupplyMgt: Codeunit "Supply Management";
                begin
                    SupplyMgt.ChangeStatus(Rec, Rec.Status::Funding);
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
                var
                    SupplyMgt: Codeunit "Supply Management";
                begin
                    SupplyMgt.ChangeStatusSelected(Rec, Rec.Status::Funding);
                end;
            }
            action(CreatePayment)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Create Payment';
                Enabled = IsPaymentEnable;
                Image = VendorPayment;
                ToolTip = 'To Create payment on current line';
                trigger OnAction()
                var
                    SupplyMgt: Codeunit "Supply Management";
                begin
                    SupplyMgt.CreatePayment(Rec, Rec.Status::Payment);
                end;
            }
            action(CreateComission)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Create Comission';
                Enabled = IsCreateComissionEditable;
                Image = Currency;
                ToolTip = 'To Create comission on current line';
                trigger OnAction()
                var
                    SupplyMgt: Codeunit "Supply Management";
                begin
                    SupplyMgt.ComissionManualCreationOnPeriod(Rec);
                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        SetControlsEnable(false);
    end;

    var
        IsVerificateEnable: Boolean;
        IsFundingEnable: Boolean;
        IsPaymentEnable: Boolean;
        IsCreateComissionEditable: Boolean;

    procedure SetControlsEnable(IsUpdate: Boolean)
    var
        SupplyLine: Record "Supply Line";
        SupplyMgt: Codeunit "Supply Management";
    begin
        IsVerificateEnable := (Rec.Status = Rec.Status::Registration) and (SupplyLine.Get(Rec."Supply Journal Code", Rec."Line No.")) and CurrPage.Editable;
        IsFundingEnable := (Rec.Status = Rec.Status::Verification) and CurrPage.Editable;
        IsPaymentEnable := SupplyMgt.IsPaymentControlEditable(Rec) and CurrPage.Editable;
        IsCreateComissionEditable := (Rec.Status = Rec.Status::Funding) and CurrPage.Editable;
    end;
}
