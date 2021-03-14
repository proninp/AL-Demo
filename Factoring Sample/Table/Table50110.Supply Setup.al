table 50110 "Supply Setup"
{
    Caption = 'Supply Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
        }
        field(10; "Supply Journal Nos"; Code[20])
        {
            Caption = 'Supply Journal Nos';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(20; "Supply Nos"; Code[20])
        {
            Caption = 'Supply Nos';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }

    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}