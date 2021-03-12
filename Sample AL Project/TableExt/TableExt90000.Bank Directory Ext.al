/// <summary>
/// TableExtension Bank Directory Ext (ID 90000) extends Record Bank Directory.
/// </summary>
tableextension 90000 "Bank Directory Ext" extends "Bank Directory"
{
    fields
    {
        field(50000; "LWRS"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'License Revocation Status';
        }
        field(50010; "LWRS Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'License Revocation Status Date';
        }
        field(50020; "URRS"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Urgent Remittance Restriction Status';
        }
        field(50030; "URRS Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Urgent Remittance Restriction Status Date';
        }
        field(50040; "MRTR"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Moratorium on Creditors Requirement';
        }
        field(50050; "MRTR Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Moratorium on Creditors Requirement Date';
        }
        field(50060; "PSAC"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Participant Status Active';
        }
        field(50070; "PSAC Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Participant Status Active Date';
        }
        field(50080; "PSDL"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Participant Status Deleted';
        }
        field(50090; "PSDL Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Participant Status Deleted Date';
        }
        field(50100; "Date In"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date In';
        }
        field(50110; "Date Out"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Out';
        }
        field(50120; "UID"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Uniq Identifier';
        }

    }
}