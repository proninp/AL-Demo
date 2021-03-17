codeunit 50100 "Supply Management"
{
    trigger OnRun()
    begin

    end;

    var
        ErrText001: Label 'Record is not exists.';
        ErrText002: Label 'There is no marked lines.';
        ErrText003: Label 'There is only one record selected - use function for single record.';
        ErrText004: Label 'Payment date must be greater than supply creation date - %1.';
        ErrText005: Label 'Payment amount must be lower than supply amount - %1.';
        ErrText006: Label 'Total sum of payments can not be greater then total sum of fundings for supply %1.';
        ErrText007: Label 'Payment amount must be greater than 0.';
        ConfirmText001: Label 'Are you sure that you want to verificate record %1?';
        ConfirmText002: Label 'Are you sure that you want to fund record %1?';
        ConfirmText003: Label 'Are you sure that you want to verificate %1 records?';
        ConfirmText004: Label 'Are you sure that you want to fund %1 records?';
        Text001: Label 'Enter paymant date';
        Text002: Label 'Enter payment amount';
        Text003: Label 'There is no amount of outstanding debt for the period from %1 to %2 fo supply line %3.';



    [EventSubscriber(ObjectType::Table, DATABASE::"Supply Line", 'OnAfterInsertEvent', '', true, true)]
    local procedure OnAfterInsertSupplyLineEvent(var Rec: Record "Supply Line"; RunTrigger: Boolean)
    var
        SupplyLE: Record "Supply Ledger Entry";
    begin
        if not RunTrigger then
            exit;
        Rec.TestField(Status, Rec.Status::Registration);
        CreateSupplyLE(SupplyLE, Rec)
    end;

    [EventSubscriber(ObjectType::Table, Database::"Supply Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteSupplyLineEvent(var Rec: Record "Supply Line"; RunTrigger: Boolean)
    var
        SupplyLE: Record "Supply Ledger Entry";
    begin
        if not RunTrigger then
            exit;
        SupplyLE.Reset();
        SupplyLE.SetCurrentKey("Supply No.");
        SupplyLE.SetRange("Supply No.", Rec."Supply No.");
        SupplyLE.DeleteAll(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Supply Line", 'OnAfterValidateEvent', 'Status', true, true)]
    local procedure OnAfterValidateSupplyLineStatusEvent(var Rec: Record "Supply Line"; var xRec: Record "Supply Line"; CurrFieldNo: Integer)
    var
        SupplyLine: Record "Supply Line";
        SupplyLE: Record "Supply Ledger Entry";
    begin
        if not SupplyLine.Get(Rec."Supply Journal Code", Rec."Line No.") then
            exit;
        if Rec.Status <> Rec.Status::Payment then
            CreateSupplyLE(SupplyLE, Rec);
    end;

    local procedure CreateSupplyLE(var SupplyLEV: Record "Supply Ledger Entry"; SupplyLineP: Record "Supply Line")
    var
        CustomerAgreement: Record "Customer Agreement";
        SupplyHeader: Record "Supply Header";
        FundingPercent: Decimal;
    begin
        SupplyHeader.Get(SupplyLineP."Supply Journal Code");
        SupplyHeader.TestField("Customer No.");

        Clear(SupplyLEV);
        SupplyLEV."Entry Type" := SupplyLineP.Status;
        SupplyLEV."Supply No." := SupplyLineP."Supply No.";
        case true of
            SupplyLineP.Status in [SupplyLineP.Status::Registration, SupplyLineP.Status::"Commission accrual"]:
                SupplyLEV.Amount := -SupplyLineP.Amount;
            SupplyLineP.Status in [SupplyLineP.Status::Funding]:
                begin
                    FundingPercent := 100; // Default
                    if CustomerAgreement.Get(SupplyLEV."Customer No.", SupplyLEV."Customer Agreement No.") then
                        FundingPercent := CustomerAgreement."Funding Percent";
                    SupplyLEV.Amount := -SupplyLineP.Amount * FundingPercent / 100;
                end;
            else
                SupplyLEV.Amount := SupplyLineP.Amount;
        end;
        SupplyLEV."Operation Date" := SupplyLineP."Creation Date";
        SupplyLEV."Creation DateTime" := CurrentDateTime();
        SupplyLEV."Created User ID" := UserId;
        SupplyLEV."Customer No." := SupplyHeader."Customer No.";
        SupplyLEV."Customer Agreement No." := SupplyHeader."Customer Agreement No.";
        SupplyLEV."Vendor No." := SupplyLineP."Vendor No.";
        SupplyLEV."Vendor Agreement" := SupplyLineP."Vendor Agreement No.";
        SupplyLEV.Insert();
    end;

    procedure ChangeStatus(var SupplyLineV: Record "Supply Line"; NewStatus: Enum "Supply Line Status")
    var
        SupplyLine: Record "Supply Line";
        ConfirmText: Text;
    begin
        if not SupplyLine.Get(SupplyLineV."Supply Journal Code", SupplyLineV."Line No.") then
            Error(ErrText001);
        case NewStatus of
            NewStatus::Verification:
                begin
                    SupplyLineV.TestField(Status, SupplyLineV.Status::Registration);
                    ConfirmText := ConfirmText001;
                end;
            NewStatus::Funding:
                begin
                    SupplyLineV.TestField(Status, SupplyLineV.Status::Verification);
                    ConfirmText := ConfirmText002;
                end;
        end;

        if not confirm(StrSubstNo(ConfirmText, SupplyLineV."Supply No.")) then
            exit;
        SupplyLineV.Validate(Status, NewStatus);
    end;

    procedure CreatePayment(SupplyLineP: Record "Supply Line"; LineStatusP: Enum "Supply Line Status")
    var
        SupplyLE: Record "Supply Ledger Entry";
        Window: Page "Standard Dialog";
        PaymantDate: Date;
        PaymentAmount: Decimal;
        FundingAmount: Decimal;
        TotalPaymentAmount: Decimal;

    begin
        if not GuiAllowed then
            exit;

        Window.SetPaymentVisible(true);
        if not (Window.RunModal() in [Action::LookupOK, Action::OK]) then
            Error('');
        Window.GetPaymentValues(PaymantDate, PaymentAmount);
        if PaymantDate < SupplyLineP."Creation Date" then
            Error(ErrText004, format(SupplyLineP."Creation Date"));
        if PaymentAmount > abs(SupplyLineP.Amount) then
            Error(ErrText005, format(SupplyLineP.Amount));
        if PaymentAmount <= 0 then
            Error(ErrText007);

        SupplyLE.Reset();
        SupplyLE.SetCurrentKey("Supply No.", "Entry Type", "Operation Date");
        SupplyLE.SetRange("Supply No.", SupplyLineP."Supply No.");
        if LineStatusP = LineStatusP::Payment then begin
            FundingAmount := 0;
            TotalPaymentAmount := 0;

            SupplyLE.SetRange("Entry Type", SupplyLE."Entry Type"::Funding);
            SupplyLE.CalcSums(Amount);
            FundingAmount := Abs(SupplyLE.Amount);

            SupplyLE.SetRange("Entry Type", SupplyLE."Entry Type"::Payment);
            SupplyLE.CalcSums(Amount);
            TotalPaymentAmount := SupplyLE.Amount;
            TotalPaymentAmount += PaymentAmount;
            if TotalPaymentAmount > FundingAmount then
                Error(ErrText006, SupplyLineP."Supply No.");
        end;

        SupplyLE.Reset();
        SupplyLineP.Status := LineStatusP;
        SupplyLineP.Amount := PaymentAmount;
        SupplyLineP."Creation Date" := PaymantDate;
        CreateSupplyLE(SupplyLE, SupplyLineP);
    end;

    procedure ComissionManualCreationOnPeriod(SupplyLineP: Record "Supply Line")
    var
        CustomerAgreement: Record "Customer Agreement";

        Window: Page "Standard Dialog";
        ComissionStartDate: Date;
        ComissionEndDate: Date;
        ComissionAmount: Decimal;
    begin
        CheckSupplyBeforeComissionFee(SupplyLineP, CustomerAgreement);

        Window.SetComissionVisible(true);
        if not (Window.RunModal() in [Action::LookupOK, Action::OK]) then
            Error('');
        Window.GetComissionValues(ComissionStartDate, ComissionEndDate);
        CalculateComissionOnPeriod(SupplyLineP, CustomerAgreement."Margin Fin.", ComissionStartDate, ComissionEndDate);
    end;

    local procedure CheckSupplyBeforeComissionFee(SupplyLineP: Record "Supply Line"; var CustomerAgreementV: Record "Customer Agreement")
    var
        SupplyHeader: Record "Supply Header";
    begin
        SupplyHeader.Get(SupplyLineP."Supply Journal Code");
        SupplyHeader.TestField("Customer No.");
        SupplyHeader.TestField("Customer Agreement No.");
        CustomerAgreementV.Get(SupplyHeader."Customer No.", SupplyHeader."Customer Agreement No.");
        CustomerAgreementV.TestField("Margin Fin.");
    end;

    local procedure CalculateComissionOnPeriod(SupplyLineP: Record "Supply Line"; MarginPercent: Decimal; StartDate: Date; EndDate: Date)
    var
        SupplyLE: Record "Supply Ledger Entry";
        SupplyLENew: Record "Supply Ledger Entry";
        SupplyLEFund: Record "Supply Ledger Entry";
        DateTable: Record Date;
        ComissionAmount: Decimal;
        DaysInYearCount: Integer;
    begin
        SupplyLineP.Get(SupplyLineP."Supply Journal Code", SupplyLineP."Line No.");

        SupplyLE.Reset();
        SupplyLE.SetCurrentKey("Supply No.", "Entry Type", "Operation Date");
        SupplyLE.SetRange("Supply No.", SupplyLineP."Supply No.");
        SupplyLE.SetFilter("Entry Type", '%1|%2', SupplyLineP.Status::Funding, SupplyLineP.Status::Payment);

        DaysInYearCount := GetdaysInYearCount();

        DateTable.Reset;
        DateTable.SetRange("Period Start", StartDate);
        DateTable.SetRange("Period End", EndDate);
        if not DateTable.FindSet() then
            exit;
        repeat
            SupplyLE.SetRange("Operation Date", StartDate, DateTable."Period Start");
            SupplyLE.CalcSums(Amount);
            ComissionAmount := SupplyLE.Amount * MarginPercent / 100 / DaysInYearCount;
            if ComissionAmount > 0 then begin
                SupplyLineP."Creation Date" := DateTable."Period Start";
                SupplyLineP.Status := SupplyLineP.Status::"Commission accrual";
                SupplyLineP.Amount := ComissionAmount;
                CreateSupplyLE(SupplyLENew, SupplyLineP);
            end;
        until DateTable.Next() = 0;
        SupplyLineP.Get(SupplyLineP."Supply Journal Code", SupplyLineP."Line No.");
    end;

    local procedure GetdaysInYearCount(): Integer
    var
        DateTable: Record Date;
    begin
        DateTable.Reset;
        DateTable.SetRange("Period Start", DMY2Date(1, 1, Date2DMY(Today(), 3)));
        DateTable.SetRange("Period End", DMY2Date(31, 12, Date2DMY(Today(), 3)));
        Exit(DateTable.Count);
    end;

    procedure ChangeStatusSelected(var SupplyLineV: Record "Supply Line"; NewStatus: Enum "Supply Line Status")
    var
        SupplyLine: Record "Supply Line";
        ConfirmText: Text;
    begin
        SupplyLine.Copy(SupplyLineV);
        SupplyLine.MarkedOnly(true);
        if SupplyLine.IsEmpty() then
            Error(ErrText002);
        if SupplyLineV.Count = 1 then
            Error(ErrText003);
        case NewStatus of
            NewStatus::Verification:
                ConfirmText := ConfirmText003;
            NewStatus::Funding:
                ConfirmText := ConfirmText004;
        end;
        if not Confirm(StrSubstNo(ConfirmText, format(SupplyLine.Count))) then
            exit;
        SupplyLine.FindFirst();
        repeat
            SupplyLine.Validate(Status, NewStatus);
            SupplyLine.Modify(true);
        until SupplyLine.Next() = 0;
    end;

    procedure IsSupplyLineExists(SupplyHeaderP: Record "Supply Header"; StatusP: Enum "Supply Line Status"): Boolean
    var
        SupplyLine: Record "Supply Line";
    begin
        SupplyLine.Reset();
        SupplyLine.SetRange("Supply Journal Code", SupplyHeaderP."No.");
        SupplyLine.SetRange(Status, StatusP);
        exit(not SupplyLine.IsEmpty);
    end;
}