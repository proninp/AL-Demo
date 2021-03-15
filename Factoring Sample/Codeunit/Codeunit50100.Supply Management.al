codeunit 50100 "Supply Management"
{
    trigger OnRun()
    begin

    end;

    var
        ErrText001: Label 'Record is not exists.';
        ErrText002: Label 'There is no marked lines.';
        ConfirmText001: Label 'Are you sure that you want verificate record %1?';

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
        SupplyLEV.Amount := SupplyLineP.Amount;
        SupplyLEV."Operation Date" := SupplyLineP."Creation Date";
        SupplyLEV."Creation DateTime" := CurrentDateTime();
        SupplyLEV."Created User ID" := UserId;
        SupplyLEV."Customer No." := SupplyHeader."Customer No.";
        SupplyLEV."Agreement No." := SupplyHeader."Agreement No.";
        SupplyLEV."Vendor No." := SupplyLineP."Vendor No.";
        SupplyLEV.Insert();
    end;

    procedure Verificate(var SupplyLineV: Record "Supply Line")
    var
        SupplyLine: Record "Supply Line";
    begin
        if not SupplyLine.Get(SupplyLineV."Supply Journal Code", SupplyLineV."Line No.") then
            Error(ErrText001);
        SupplyLineV.TestField(Status, SupplyLineV.Status::Registration);
        if not confirm(StrSubstNo(ConfirmText001, SupplyLineV."Supply No.")) then
            exit;
        SupplyLineV.Validate(Status, SupplyLineV.Status::Verification);
    end;

    procedure VerificateSelected(var SupplyLineV: Record "Supply Line")
    var
        SupplyLine: Record "Supply Line";
    begin
        SupplyLine.Copy(SupplyLineV);
        SupplyLine.MarkedOnly(true);
        if SupplyLine.IsEmpty() then
            Error(ErrText002);
        SupplyLine.FindFirst();
        repeat
            SupplyLine.Validate(Status, SupplyLine.Status::Verification);
            SupplyLine.Modify(true);
        until SupplyLine.Next() = 0;
    end;

    procedure IsSupplyLineExists(SupplyHeader: Record "Supply Header"): Boolean
    var
        SupplyLine: Record "Supply Line";
    begin
        SupplyLine.Reset();
        SupplyLine.SetRange("Supply Journal Code", SupplyHeader."No.");
        exit(not SupplyLine.IsEmpty);
    end;

}