pageextension 90010 "Customer Agreement Card Ext" extends "Customer Agreement Card"
{
    layout
    {
        addlast(Shipping)
        {
            group(Factoring)
            {
                field("Funding Percent"; "Funding Percent")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Funding Percent';
                }
                field("Margin Fin."; "Margin Fin.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Margin Fin.';
                }
            }
        }
    }
}