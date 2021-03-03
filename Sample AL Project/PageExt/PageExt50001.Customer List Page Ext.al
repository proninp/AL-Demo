/// <summary>
/// PageExtension Customer List Page Ext (ID 50001) extends Record Customer List. Add action - Print Customer Blocked list
/// </summary>
pageextension 50001 "Customer List Page Ext" extends "Customer List"
{
    actions
    {
        addlast(reporting)
        {
            action(ShowBlockedCustList)
            {
                Caption = 'Show Blocked Customers List';
                Image = CustomerLedger;
                trigger OnAction()
                begin
                    report.RunModal(report::"Blocked Customer List");
                end;
            }
        }
    }
}