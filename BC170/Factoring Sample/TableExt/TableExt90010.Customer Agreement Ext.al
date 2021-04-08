tableextension 90010 "Customer Agreement Ext." extends "Customer Agreement"
{
    fields
    {
        field(50000; "Funding Percent"; Decimal)
        {
            Caption = 'Funding Percent';
            DataClassification = ToBeClassified;
            //InitValue = 100;
        }
        field(50010; "Margin Fin."; Decimal)
        {
            Caption = 'Margin Fin.';
            DataClassification = ToBeClassified;
        }
    }
}