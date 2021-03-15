page 50101 "Supply Subform"
{
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
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Supply No."; Rec."Supply No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Extenal Document No."; Rec."Extenal Document No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("External Supply Date"; Rec."External Supply Date")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(Delay; Rec.Delay)
                {
                    ApplicationArea = All;
                }
                field("Delay Date"; Rec."Delay Date")
                {
                    ApplicationArea = All;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Supply Ledger Entry Amount"; Rec."Supply Ledger Entry Amount")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    begin
                        OpenSupplyLedgerEntry();
                    end;
                }
            }
        }
    }

}
