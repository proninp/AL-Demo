page 50110 "Supply Setup"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Supply Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Supply Setup";
    UsageCategory = Administration;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Supply Journal Nos"; "Supply Journal Nos")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Supply Nos"; "Supply Nos")
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