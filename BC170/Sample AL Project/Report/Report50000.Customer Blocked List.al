/// <summary>
/// Report Blocked Customer List (ID 50000) shows customers that were blocked by "Blocked Ext" field
/// </summary>
report 50000 "Blocked Customer List"
{
    ApplicationArea = All;
    Caption = 'Blocked Customer List';
    RDLCLayout = '.vscode/Blocked Customers List.rdl';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = where("Blocked Ext" = const(true));
            column(No; "No.")
            {
                Caption = 'No.';
            }
            column(Name; Name)
            {
                Caption = 'Name';
            }
        }
    }
}