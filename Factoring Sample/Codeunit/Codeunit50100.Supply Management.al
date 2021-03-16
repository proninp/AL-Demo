codeunit 50100 "Supply Management"
{
    trigger OnRun()
    begin

    end;

    var
        ErrText001: Label 'Record is not exists.';
        ErrText002: Label 'There is no marked lines.';
        ErrText003: Label 'There is only one record selected - use function for single record.';
        ConfirmText001: Label 'Are you sure that you want to verificate record %1?';
        ConfirmText002: Label 'Are you sure that you want to fund record %1?';
        ConfirmText003: Label 'Are you sure that you want to verificate %1 records?';
        ConfirmText004: Label 'Are you sure that you want to fund %1 records?';


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
    local procedure MyProcedure(var Rec: Record "Supply Line"; var xRec: Record "Supply Line"; CurrFieldNo: Integer)
    var
        SupplyLine: Record "Supply Line";
        SupplyLE: Record "Supply Ledger Entry";
    begin
        if not SupplyLine.Get(Rec."Supply Journal Code", Rec."Line No.") then
            exit;
        CreateSupplyLE(SupplyLE, Rec);
    end;

    local procedure CreateSupplyLE(var SupplyLEV: Record "Supply Ledger Entry"; SupplyLineP: Record "Supply Line")
    var
        SupplyHeader: Record "Supply Header";
    begin
        SupplyHeader.Get(SupplyLineP."Supply Journal Code");
        SupplyHeader.TestField("Customer No.");

        SupplyLEV.Init();
        SupplyLEV."Entry Type" := SupplyLineP.Status;
        SupplyLEV."Supply No." := SupplyLineP."Supply No.";
        case true of
            SupplyLineP.Status in [SupplyLineP.Status::Registration, SupplyLineP.Status::Funding]:
                SupplyLEV.Amount := -SupplyLineP.Amount;
            else
                SupplyLEV.Amount := SupplyLineP.Amount;
        end;
        SupplyLEV."Operation Date" := SupplyLineP."Creation Date";
        SupplyLEV."Creation DateTime" := CurrentDateTime();
        SupplyLEV."Created User ID" := UserId;
        SupplyLEV."Customer No." := SupplyHeader."Customer No.";
        SupplyLEV."Agreement No." := SupplyHeader."Agreement No.";
        SupplyLEV."Vendor No." := SupplyLineP."Vendor No.";
        SupplyLEV."Vendor Agreement" := SupplyLineP."Vendor Agreement";
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