page 50201 "Dadata Setup"
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
        area(content)
        {
            group(General)
            {
                field("Organization Data Web Link"; Rec."Organization Data Web Link")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Organization Data Token"; Rec."Organization Data Token")
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
