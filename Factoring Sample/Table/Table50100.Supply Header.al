table 50100 "Supply Header"
{
    Caption = 'Supply Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            var
                SupplySetup: Record "Supply Setup";
                NoSeriesMgt: Codeunit NoSeriesManagement;
            begin
                if "No." <> xRec."No." then begin
                    SupplySetup.Get();
                    NoSeriesMgt.TestManual(SupplySetup."Supply Journal Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(10; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer where(Blocked = filter(<> 3));
            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if "Customer No." = '' then
                    "Customer Name" := ''
                else
                    if Customer.Get("Customer No.") then
                        "Customer Name" := Customer.Name + Customer."Name 2";
            end;
        }
        field(20; "Customer Name"; Text[250])
        {
            Caption = 'Customer Name';
            DataClassification = ToBeClassified;
        }
        field(30; "Agreement No."; Code[20])
        {
            Caption = 'Agreement No.';
            DataClassification = ToBeClassified;
            TableRelation = "Customer Agreement" where(Blocked = filter(<> 3));
            trigger OnValidate()
            var
                CustAgreement: Record "Customer Agreement";
            begin
                if "Agreement No." = '' then
                    "External Agreement No." := ''
                else
                    if CustAgreement.Get("Agreement No.") then
                        "External Agreement No." := CustAgreement."External Agreement No.";
            end;
        }
        field(40; "External Agreement No."; Text[30])
        {
            Caption = 'External Agreement No.';
            DataClassification = ToBeClassified;
        }
        field(50; "Supply Date"; Date)
        {
            Caption = 'Supply Date';
            DataClassification = ToBeClassified;
        }
        field(60; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            DataClassification = ToBeClassified;
        }
        field(70; "Created User ID"; Code[40])
        {
            Caption = 'Created User ID';
            DataClassification = ToBeClassified;
        }
        field(80; "Status"; Enum "Supply Header Status")
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
        }
        field(90; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
        }
        //TODO FlowFields: Amount, Lines Count
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        SupplySetup: Record "Supply Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        SupplySetup.Get();
        SupplySetup.TestField("Supply Journal Nos");
        if "No." = '' then
            NoSeriesMgt.InitSeries(SupplySetup."Supply Journal Nos", xRec."No. Series", WorkDate(), "No.", "No. Series");
        "Creation Date" := WorkDate();
        "Created User ID" := UserId();
    end;
}