/// <summary>
/// PageExtension Contact List Page Ext (ID 85052) extends Record Contact List.
/// </summary>
pageextension 85052 "Contact List Page Ext" extends "Contact List"
{
    layout
    {
        addafter("E-Mail")
        {
            field("Is E-mail Correct"; IsEmailCorrect)
            {
                ApplicationArea = All;
                Caption = 'Is E-mail Correct';
                ToolTip = 'Is E-mail corrected';
            }
        }
    }
    var
        IsEmailCorrect: Boolean;

    trigger OnAfterGetRecord()
    var
        EmailMgt: Codeunit "E-mail Mgt.";
    begin
        IsEmailCorrect := EmailMgt.IsEmailCorrect(Rec."E-Mail", '');
    end;
}