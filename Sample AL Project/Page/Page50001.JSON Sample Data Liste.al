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

                field("Sample Text"; "Sample Text")
                {
                    ApplicationArea = All;
                }
                field("Sample Integer"; "Sample Integer")
                {
                    ApplicationArea = All;
                }
                field("Sample Decimal"; "Sample Decimal")
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
