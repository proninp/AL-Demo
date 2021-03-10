/// <summary>
/// PageExtension Bank Directory List Page Ext (ID 90000) extends Record Bank Directory List.
/// </summary>
pageextension 90000 "Bank Directory List Page Ext" extends "Bank Directory List"
{
    actions
    {
        addlast(Processing)
        {
            action(DownloadBankList)
            {
                Caption = 'Download Bank List';
                Image = ElectronicBanking;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Downloads Bank List from cbr.ru by current date state';
                RunObject = Codeunit "Bic Import";
            }
        }
    }

}