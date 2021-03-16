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
            trigger OnValidate()
            begin
                case Status of
                    Status::Verification:
                        xRec.TestField(Status, xRec.Status::Registration);
                    Status::Funding:
                        xRec.TestField(Status, xRec.Status::Verification);
                    Status::Payment:
                        xRec.TestField(Status, xRec.Status::Funding);
                end;
            end;
        }
        field(40;
        "Extenal Document No.";
        Code[20])
        {
            Caption = 'Extenal Document No.';
            DataClassification = ToBeClassified;
        }
        field(50;
        "Vendor No.";
        Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = ToBeClassified;
            TableRelation = Vendor where(Blocked = filter(<> 3));
            trigger OnValidate()
            var
                VendorAgreement: Record "Vendor Agreement";
            begin
                VendorAgreement.Reset();
                VendorAgreement.SetRange("Vendor No.", Rec."Vendor No.");
                VendorAgreement.SetFilter(Blocked, '<>%1', VendorAgreement.Blocked::All);
                VendorAgreement.SetRange("Starting Date", 0D, WorkDate());
                VendorAgreement.SetFilter("Expire Date", '>%1', WorkDate());
                If VendorAgreement.FindFirst() and (VendorAgreement.Count = 1) then
                    Validate("Vendor Agreement", VendorAgreement."No.");
            end;
        }
        field(60;
        "External Supply Date";
        Date)
        {
            Caption = 'External Supply Date';
            DataClassification = ToBeClassified;
        }
        field(70;
        "Amount";
        Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(71;
        "Creation Date";
        Date)
        {
            Caption = 'Creation Date';
            DataClassification = ToBeClassified;
        }
        field(80;
        Delay;
        Integer)
        {
            Caption = 'Delay';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "Creation Date" = 0D then
                    "Creation Date" := WorkDate();
                "Delay Date" := CalcDate('<+' + format(Delay) + 'D>', "Creation Date");
            end;
        }
        field(90;
        "Delay Date";
        Date)
        {
            Caption = 'Delay Date';
            DataClassification = ToBeClassified;
        }
        field(100;
        "Supply Ledger Entry Amount";
        Decimal)
        {
            CalcFormula = Sum("Supply Ledger Entry".Amount where("Supply No." = field("Supply No.")));
            Caption = 'Supply Ledger Entry Amount';
            FieldClass = FlowField;
        }
        field(110; "Vendor Agreement"; Code[20])
        {
            Caption = 'Vendor Agreement';
            DataClassification = ToBeClassified;
            TableRelation = "Vendor Agreement";
            trigger OnValidate()
            var
                VendorAgreement: Record "Vendor Agreement";
            begin
                if VendorAgreement.Get("Vendor No.", "Vendor Agreement") and ("Vendor Agreement" <> '') then
                    Delay := VendorAgreement.Delay
                else
                    Delay := 0;
                Rec.Validate(Delay)
            end;
        }
    }

    keys
    {
        key(Key1;
        "Supply Journal Code", "Line No.")
        {
            Clustered = true;
        }
        key(Key2;
        "Supply No.")
        { }
    }

    trigger OnInsert()
    var
        SupplySetup:
            Record "Supply Setup";
        NoSeriesMgt:
                        Codeunit NoSeriesManagement;
    begin
        SupplySetup.Get();
        SupplySetup.TestField("Supply Nos");
        if "Supply No." = '' then
            NoSeriesMgt.InitSeries(SupplySetup."Supply Nos", xRec."No. Series", WorkDate(), "Supply No.", "No. Series");
        "Creation Date" := WorkDate();
        if "Delay Date" = 0D then
            "Delay Date" := CalcDate('<+' + format(Delay) + 'D>', "Creation Date");
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