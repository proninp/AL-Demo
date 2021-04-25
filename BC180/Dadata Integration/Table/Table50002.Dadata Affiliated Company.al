table 50002 "Dadata Affiliated Company"
{
    Caption = 'Dadata Affiliated Company';

    DataClassification = ToBeClassified;

    fields
    {
        field(1; Inn; Text[10])
        {
            Caption = 'INN Code';
            DataClassification = ToBeClassified;

        }
        field(2; KPP; Text[10])
        {
            Caption = 'KPP Code';
            DataClassification = ToBeClassified;
        }
        field(10; Name; Text[250])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(20; OGRN; Text[250])
        {
            Caption = 'OGRN';
            DataClassification = ToBeClassified;
        }
        field(30; "Internal Dadata ID"; Text[40])
        {
            Caption = 'Internal Dadata ID';
            DataClassification = ToBeClassified;
        }
        field(40; "Organization Type"; Text[30])
        {
            Caption = 'Organization Type';
            DataClassification = ToBeClassified;
        }
        field(50; OKATO; Text[30])
        {
            Caption = 'OKATO';
            DataClassification = ToBeClassified;
        }
        field(60; OKTMO; Text[30])
        {
            Caption = 'OKTMO';
            DataClassification = ToBeClassified;
        }
        field(70; OKPO; Text[30])
        {
            Caption = 'OKPO';
            DataClassification = ToBeClassified;
        }
        field(80; OKOGU; Text[30])
        {
            Caption = 'OKOGU';
            DataClassification = ToBeClassified;
        }
        field(90; OKFS; Text[30])
        {
            Caption = 'OKFS';
            DataClassification = ToBeClassified;
        }
        field(100; OKVED; Text[30])
        {
            Caption = 'OKVED';
            DataClassification = ToBeClassified;
        }
        field(110; "Branches Count"; Integer)
        {
            Caption = 'Branches Count';
            DataClassification = ToBeClassified;
        }
        field(120; "Branch Type"; Text[20])
        {
            Caption = 'Branch Type';
            DataClassification = ToBeClassified;
        }
        field(130; "Address"; Text[500])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
        }
        field(140; "Actuality Date"; Date)
        {
            Caption = 'Actuality Date';
            DataClassification = ToBeClassified;
        }
        field(150; "Registration Date"; Date)
        {
            Caption = 'Registration Date';
            DataClassification = ToBeClassified;
        }
        field(160; "Liquidation Date"; Date)
        {
            Caption = 'Liquidation Date';
            DataClassification = ToBeClassified;
        }
        field(170; Status; Text[30])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(180; "Status Description"; Text[250])
        {
            Caption = 'Status Description';
            DataClassification = ToBeClassified;
        }
        field(190; "Detailed Status"; Integer)
        {
            Caption = 'Detailed Status';
            DataClassification = ToBeClassified;
        }
        field(200; "Detailed Status Description"; Text[250])
        {
            Caption = 'Detailed Status Description';
            DataClassification = ToBeClassified;
        }
        field(580; "Affiliated With INN"; Text[10])
        {
            Caption = 'Affiliated With INN';
            DataClassification = ToBeClassified;
        }
        field(590; "Created UserID"; Code[40])
        {
            Caption = 'Created UserID';
            DataClassification = ToBeClassified;
        }
        field(600; "Created DateTime"; DateTime)
        {
            Caption = 'Created DateTime';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; INN, KPP)
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        "Created DateTime" := CurrentDateTime();
        "Created UserID" := UserId();
    end;
}