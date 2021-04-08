/// <summary>
/// Query Customer Contacts With Orders (ID 50000).
/// </summary>
query 50000 "Customer Contacts With Orders"
{
    Caption = 'Customer Contacts With Orders';
    OrderBy = ascending(Name);
    QueryCategory = 'Customer Contacts';
    QueryType = Normal;

    elements
    {
        dataitem(Customer; Customer)
        {
            DataItemTableFilter = Blocked = filter(<> 3),
                                  "Blocked Ext" = const(false);
            column(No_; "No.")
            {
                Caption = 'No.';
            }
            column(Name; Name)
            {
                Caption = 'Name';
            }
            column(Name_2; "Name 2")
            {
                Caption = 'Name 2';
            }
            column(Post_Code; "Post Code")
            {
                Caption = 'Post Code';
            }
            column(Country_Region_Code; "Country/Region Code")
            {
                Caption = 'Country/Region Code';
            }
            column(Phone_No_; "Phone No.")
            {
                Caption = 'Phone No.';
            }
            column(Contact; Contact)
            {
                Caption = 'Contact';
            }
            column(Salesperson_Code; "Salesperson Code")
            {
                Caption = 'Salesperson Code';
            }
            dataitem(Sales_Header; "Sales Header")
            {
                DataItemLink = "Sell-to Customer No." = Customer."No.";
                SqlJoinType = InnerJoin;
                column(SH_No_; "No.")
                {
                    Caption = 'No.';
                }
                column(SH_Posting_Date; "Posting Date")
                {
                    Caption = 'Posting Date';
                }
                column(SH_Status; Status)
                {
                    Caption = 'Status';
                }
                dataitem(Sales_Line; "Sales Line")
                {
                    DataItemLink = "Document No." = Sales_Header."No.";
                    SqlJoinType = InnerJoin;
                    column(Qty; Quantity)
                    {
                        Caption = 'Items Quantity Sum';
                        Method = Sum;
                    }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}