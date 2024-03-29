table 50102 "Supply Ledger Entry"
{
    Caption = 'Supply Ledger Entry';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(10; "Supply No."; Code[20])
        {
            Caption = 'Supply No.';
            DataClassification = ToBeClassified;
            TableRelation = "Supply Line" where("Supply No." = field("Supply No."));
        }
        field(20; "Entry Type"; Enum "Supply Line Status")
        {
            Caption = 'Entry Type';
            DataClassification = ToBeClassified;
        }
        field(30; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(40; "Operation Date"; Date)
        {
            Caption = 'Operation Date';
            DataClassification = ToBeClassified;
        }
        field(50; "Creation DateTime"; DateTime)
        {
            Caption = 'Cration DateTime';
            DataClassification = ToBeClassified;
        }
        field(60; "Created User ID"; Code[40])
        {
            Caption = 'Created User ID';
            DataClassification = ToBeClassified;
        }
        field(70; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(80; "Customer Agreement No."; Code[20])
        {
            Caption = 'Agreement No.';
            DataClassification = ToBeClassified;
            TableRelation = "Customer Agreement";
        }
        field(90; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(100; "Vendor Agreement"; Code[20])
        {
            Caption = 'Vendor Agreement';
            DataClassification = ToBeClassified;
            TableRelation = "Vendor Agreement";
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Supply No.") { }
        key(key3; "Supply No.", "Entry Type", "Operation Date")
        {
            SumIndexFields = Amount;
        }
    }
}