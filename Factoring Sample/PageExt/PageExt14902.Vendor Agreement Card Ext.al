pageextension 90011 "Vendor Agreement Card Ext" extends "Vendor Agreement Card"
{
    layout
    {
        addafter("VAT Agent")
        {
            group(Factoring)
            {
                field(Delay; Delay)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Delay';
                }
            }
        }
    }
}