table 50101 "Supply Line"
{
    Caption = 'Supply Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Supply Journal Code"; Code[20])
        {
            Caption = 'Supply Journal No.';
            DataClassification = ToBeClassified;
            TableRelation = "Supply Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(10; "Supply No."; Code[20])
        {
            Caption = 'Supply No.';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                SupplySetup: Record "Supply Setup";
                NoSeriesMgt: Codeunit NoSeriesManagement;
            begin
                if "Supply No." <> xRec."Supply No." then begin
                    SupplySetup.Get();
                    NoSeriesMgt.TestManual(SupplySetup."Supply Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(20; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
        }
        field(30; Status; Enum "Supply Line Status")
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
        }
        field(40; "Extenal Document No."; Code[20])
        {
            Caption = 'Extenal Document No.';
            DataClassification = ToBeClassified;
        }
        field(50; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = ToBeClassified;
            TableRelation = Vendor where(Blocked = filter(<> 3));
        }
        field(60; "External Supply Date"; Date)
        {
            Caption = 'External Supply Date';
            DataClassification = ToBeClassified;
        }
        field(70; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(71; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            DataClassification = ToBeClassified;
        }
        field(80; Delay; Integer)
        {
            Caption = 'Delay';
            DataClassification = ToBeClassified;
        }
        field(90; "Delay Date"; Date)
        {
            Caption = 'Delay Date';
            DataClassification = ToBeClassified;
        }
        field(100; "Supply Ledger Entry Amount"; Decimal)
        {
            CalcFormula = Sum("Supply Ledger Entry".Amount where("Supply No." = field("Supply No.")));
            Caption = 'Supply Ledger Entry Amount';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Supply Journal Code", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Supply No.") { }
    }

    trigger OnInsert()
    var
        SupplySetup: Record "Supply Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        SupplySetup.Get();
        SupplySetup.TestField("Supply Nos");
        if "Supply No." = '' then
            NoSeriesMgt.InitSeries(SupplySetup."Supply Nos", xRec."No. Series", WorkDate(), "Supply No.", "No. Series");
        "Creation Date" := WorkDate();
    end;

    procedure OpenSupplyLedgerEntry()
    var
        SupplyLE: Record "Supply Ledger Entry";
    begin
        SupplyLE.Reset();
        SupplyLE.SetCurrentKey("Supply No.");
        SupplyLE.SetRange("Supply No.", Rec."Supply No.");
        Page.Run(PAGE::"Supply Ledger Entries", SupplyLE);
    end;
}