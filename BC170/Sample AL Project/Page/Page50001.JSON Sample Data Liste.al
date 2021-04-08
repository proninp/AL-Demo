/// <summary>
/// Page JSON Sample Data List (ID 50001).
/// </summary>
page 50001 "JSON Sample Data List"
{
    ApplicationArea = All;
    Caption = 'JSON Sample Data List';
    Editable = false;
    PageType = List;
    SourceTable = "JSON Sample Data";
    SourceTableView = order(ascending);
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(General)
            {

                field("Local Name"; Rec."Local Name")
                {
                    ApplicationArea = All;
                }
                field("Name"; Rec."Name")
                {
                    ApplicationArea = All;
                }
                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = All;
                }
                field("Fixed"; Rec."Fixed")
                {
                    ApplicationArea = All;
                }
                field("Global"; Rec."Global")
                {
                    ApplicationArea = All;
                }
                field("Launch Year"; Rec."Launch Year")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Refresh)
            {
                Caption = 'Refresh JSON Data';
                Promoted = true;
                PromotedCategory = Process;
                Image = RefreshLines;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    Rec.RefreshFunction();
                    CurrPage.Update;
                    if Rec.FindFirst then;
                end;
            }
        }
    }
}
