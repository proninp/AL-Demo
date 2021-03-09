/// <summary>
/// Table JSON Sample Data (ID 50000).
/// </summary>
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
        field(10; "Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date';
        }
        field(20; "Local Name"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Local Name';
        }
        field(30; "Name"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
        }
        field(40; "Country Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Country Code';
            TableRelation = "Country/Region";
        }
        field(50; "Fixed"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Fixed';
        }
        field(60; "Global"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Global';
        }
        field(70; "Launch Year"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Launch Year';
        }
        field(80; "Type"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Type';
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
