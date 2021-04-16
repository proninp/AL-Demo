page 50000 "Dadata Setup"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Dadata Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Dadata Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Data Token"; Rec."Dadata Token")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Organization Data Web Link"; Rec."Organization Data Web Link")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}