table 50000 "JSON Sample Data"
{
    DataClassification = CusomerContent;
    fields
    {

        field(1; "Entry No."; BigInteger)
        {
            DataClassification = CusomerContent;
            Caption = 'Entry No.';
            ApplicationArea = All;
        }
        field(10; "string"; Text[250])
        {
            Caption = 'string';
            ApplicationArea = All;
        }
        field(20; "integer"; Integer)
        {
            Caption = 'integer';
            ApplicationArea = All;
        }
        field(30; "decimal"; Text[250])
        {
            Caption = 'decimal';
            ApplicationArea = All;
        }

    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }


    procedure RefreshFunction();
    var
        Refresh: Codeunit Refresh;
    begin
        Refresh.RefreshJson();
    end;

}
