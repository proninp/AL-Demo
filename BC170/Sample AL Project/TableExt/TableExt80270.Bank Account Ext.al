/// <summary>
/// TableExtension Bank Account Table Ext (ID 80270) extends Record Bank Account.
/// </summary>
tableextension 80270 "Bank Account Table Ext" extends "Bank Account"
{
    fields
    {
        field(50000; "ACAC"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Active Account';
        }
        field(50010; "ACDL"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Deleted Account';
        }
        field(50020; "Date In"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date In';
        }
        field(50030; "Date Out"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date Out';
        }
        field(50040; "LMRS"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Temp. Acc. Saving with Limited Using';
        }
        field(50050; "LMRS Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Temp. Acc. Saving with Limited Using Date';
        }
        field(50060; "URRS"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Urgent Remittance Restriction Status';
        }
        field(50070; "URRS Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Urgent Remittance Restriction Status Date';
        }
        field(50080; "CLRS"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Account Closing';
        }
        field(50090; "CLRS Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Account Closing Date';
        }
        field(50100; "FPRS"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Fast Payments Service Revocation';
        }
        field(50110; "FPRS Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Fast Payments Service Revocation Date';
        }
    }
}