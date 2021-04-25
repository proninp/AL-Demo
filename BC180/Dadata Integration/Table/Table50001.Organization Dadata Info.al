table 50001 "Organization Dadata Info"
{
    Caption = 'Organization Dadata Info';
    DataCaptionFields = Name, Inn, Kpp;
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(10; "Name"; Text[150])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(20; "Full Name"; Text[250])
        {
            Caption = 'Full Name';
            DataClassification = ToBeClassified;
        }
        field(30; "OPF Short"; Text[10])
        {
            Caption = 'OPF Short';
            DataClassification = ToBeClassified;
        }
        field(40; "OPF Full"; Text[50])
        {
            Caption = 'OPF Full';
            DataClassification = ToBeClassified;
        }
        field(50; "Inn"; Text[10])
        {
            Caption = 'INN';
            DataClassification = ToBeClassified;
        }
        field(60; "Kpp"; Text[10])
        {
            Caption = 'KPP';
            DataClassification = ToBeClassified;
        }
        field(70; "OGRN"; Text[20])
        {
            Caption = 'OGRN';
            DataClassification = ToBeClassified;
        }
        field(80; "OKPO"; Text[10])
        {
            Caption = 'OKPO';
            DataClassification = ToBeClassified;
        }
        field(90; "OKATO"; Text[20])
        {
            Caption = 'OKATO';
            DataClassification = ToBeClassified;
        }
        field(100; "OKTMO"; Text[20])
        {
            Caption = 'OKTMO';
            DataClassification = ToBeClassified;
        }
        field(110; "OKOGU"; Text[20])
        {
            Caption = 'OKOGU';
            DataClassification = ToBeClassified;
        }
        field(120; "OKFS"; Text[10])
        {
            Caption = 'OKFS';
            DataClassification = ToBeClassified;
        }
        field(130; "OKVED"; Text[10])
        {
            Caption = 'OKVED';
            DataClassification = ToBeClassified;
        }
        field(140; "Full Address"; Text[250])
        {
            Caption = 'Full Address';
            DataClassification = ToBeClassified;
        }
        field(150; "Postal Code"; Text[20])
        {
            Caption = 'Postal Code';
            DataClassification = ToBeClassified;
        }
        field(160; "Country"; Text[20])
        {
            Caption = 'Country';
            DataClassification = ToBeClassified;
        }
        field(170; "Country ISO Code"; Text[10])
        {
            Caption = 'Country ISO Code';
            DataClassification = ToBeClassified;
        }
        field(180; "Federal District"; Text[20])
        {
            Caption = 'Federal District';
            DataClassification = ToBeClassified;
        }
        field(190; "Regional Kladr ID"; Text[20])
        {
            Caption = 'Regional Kladr ID';
            DataClassification = ToBeClassified;
        }
        field(200; "Region With Type"; Text[20])
        {
            Caption = 'Region With Type';
            DataClassification = ToBeClassified;
        }
        field(210; "Region Type"; Text[10])
        {
            Caption = 'Region Type';
            DataClassification = ToBeClassified;
        }
        field(220; "Region Type Full"; Text[20])
        {
            Caption = 'Region Type Full';
            DataClassification = ToBeClassified;
        }
        field(230; "Region"; Text[20])
        {
            Caption = 'Region';
            DataClassification = ToBeClassified;
        }
        field(240; "Area With Type"; Text[20])
        {
            Caption = 'Area With Type';
            DataClassification = ToBeClassified;
        }
        field(250; "Area Type"; Text[10])
        {
            Caption = 'Area Type';
            DataClassification = ToBeClassified;
        }
        field(260; "Area Type Full"; Text[20])
        {
            Caption = 'Area Type Full';
            DataClassification = ToBeClassified;
        }
        field(270; "Area"; Text[20])
        {
            Caption = 'Area';
            DataClassification = ToBeClassified;
        }
        field(280; "City With Type"; Text[50])
        {
            Caption = 'City With Type';
            DataClassification = ToBeClassified;
        }
        field(290; "City Type"; Text[10])
        {
            Caption = 'City Type';
            DataClassification = ToBeClassified;
        }
        field(300; "City Type Full"; Text[20])
        {
            Caption = 'City Type Full';
            DataClassification = ToBeClassified;
        }
        field(310; "City"; Text[20])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
        }
        field(320; "Settlement With Type"; Text[250])
        {
            Caption = 'Settlement With Type';
            DataClassification = ToBeClassified;
        }
        field(330; "Settlement Type"; Text[10])
        {
            Caption = 'Settlement Type';
            DataClassification = ToBeClassified;
        }
        field(340; "Settlement Type Full"; Text[20])
        {
            Caption = 'Settlement Type Full';
            DataClassification = ToBeClassified;
        }
        field(350; "Settlement"; Text[250])
        {
            Caption = 'Settlement';
            DataClassification = ToBeClassified;
        }
        field(360; "Street With Type"; Text[100])
        {
            Caption = 'Street With Type';
            DataClassification = ToBeClassified;
        }
        field(370; "Street Type"; Text[10])
        {
            Caption = 'Street Type';
            DataClassification = ToBeClassified;
        }
        field(380; "Street Type Full"; Text[20])
        {
            Caption = 'Street Type Full';
            DataClassification = ToBeClassified;
        }
        field(390; "Street"; Text[20])
        {
            Caption = 'Street';
            DataClassification = ToBeClassified;
        }
        field(400; "House Type"; Text[10])
        {
            Caption = 'House Type';
            DataClassification = ToBeClassified;
        }
        field(410; "House Type Full"; Text[20])
        {
            Caption = 'House Type Full';
            DataClassification = ToBeClassified;
        }
        field(420; "House"; Text[10])
        {
            Caption = 'House';
            DataClassification = ToBeClassified;
        }
        field(430; "Block Type"; Text[10])
        {
            Caption = 'Block Type';
            DataClassification = ToBeClassified;
        }
        field(440; "Block"; Text[20])
        {
            Caption = 'Block';
            DataClassification = ToBeClassified;
        }
        field(450; "Entrance"; Text[10])
        {
            Caption = 'Entrance';
            DataClassification = ToBeClassified;
        }
        field(460; "Floor"; Text[10])
        {
            Caption = 'Floor';
            DataClassification = ToBeClassified;
        }
        field(470; "Flat"; Text[15])
        {
            Caption = 'Flat';
            DataClassification = ToBeClassified;
        }
        field(480; "Flat Type"; Text[10])
        {
            Caption = 'Flat Type';
            DataClassification = ToBeClassified;
        }
        field(490; "Flat Type Full"; Text[10])
        {
            Caption = 'Flat Type Full';
            DataClassification = ToBeClassified;
        }
        field(500; "Postal Box"; Text[10])
        {
            Caption = 'Postal Box';
            DataClassification = ToBeClassified;
        }
        field(510; "OKATO Address"; Text[15])
        {
            Caption = 'OKATO Address';
            DataClassification = ToBeClassified;
        }
        field(520; "OKTMO Address"; Text[15])
        {
            Caption = 'OKTMO Address';
            DataClassification = ToBeClassified;
        }
        field(530; "Tax Office"; Text[10])
        {
            Caption = 'Tax Office';
            DataClassification = ToBeClassified;
        }
        field(540; "Geo Lat"; Text[10])
        {
            Caption = 'Geo Lat';
            DataClassification = ToBeClassified;
        }
        field(550; "Geo Lon"; Text[10])
        {
            Caption = 'Geo Lon';
            DataClassification = ToBeClassified;
        }
        field(560; "Phones"; Text[50])
        {
            Caption = 'Phones';
            DataClassification = ToBeClassified;
        }
        field(570; "Emails"; Text[50])
        {
            Caption = 'Emails';
            DataClassification = ToBeClassified;
        }
        field(580; "OKVED Type"; Text[10])
        {
            Caption = 'OKVED Type';
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
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Inn", "Kpp") { }
    }
    trigger OnInsert()
    begin
        "Created UserID" := UserId();
        "Created DateTime" := CurrentDateTime;
    end;
}