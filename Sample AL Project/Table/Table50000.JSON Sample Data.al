table 50000 "JSON Sample Data"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(10; "Sample Text"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Sample Text';
        }
        field(20; "Sample Integer"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Sample Integer';
        }
        field(30; "Sample Decimal"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Sample Decimal';
        }

    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }


    /// <summary>
    /// RefreshFunction for refrsh JSON Data
    /// </summary>
    procedure RefreshFunction();
    var
        Refresh: Codeunit "Refresh JSON Sample Data";
    begin
        Refresh.RefreshJson();
    end;

}
