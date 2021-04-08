table 50201 "Dadata Setup"
{
    Caption = 'Dadata Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;

        }
        field(10; "Organization Data Web Link"; Text[100])
        {
            Caption = 'Organization Data Web Link';
            DataClassification = ToBeClassified;
        }
        field(20; "Organization Data Token"; Text[50])
        {
            Caption = 'Organization Data Token';
            DataClassification = ToBeClassified;
        }
    }
}