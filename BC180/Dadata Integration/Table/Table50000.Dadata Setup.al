table 50000 "Dadata Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
        }
        field(10; "Dadata Token"; Text[50])
        {
            Caption = 'Dadata Token';
            DataClassification = ToBeClassified;
        }
        field(20; "Organization Data Web Link"; Text[100])
        {
            Caption = 'Organization Data Web Link';
            DataClassification = ToBeClassified;
        }
        field(30; "Affiliated Companies Web Link"; Text[100])
        {
            Caption = 'Affiliated Companies Web Link';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
}