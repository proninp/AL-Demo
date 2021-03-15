page 50102 "Supply Ledger Entries"
{

    ApplicationArea = Basic, Suite;
    Caption = 'Supply Ledger Entries';
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Entry';
    SourceTable = "Supply Ledger Entry";
    SourceTableView = SORTING("Entry No.")
                      ORDER(Descending);
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Supply No."; Rec."Supply No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Operation Date"; Rec."Operation Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Created User ID"; Rec."Created User ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Agreement No."; Rec."Agreement No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

}
