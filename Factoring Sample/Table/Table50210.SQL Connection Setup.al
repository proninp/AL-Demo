table 50210 "SQL Connection Setup"
{
    Caption = 'SQL Connection Setup';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(10; "Server Name"; Text[50])
        {
            Caption = 'Server Name';
            DataClassification = ToBeClassified;
        }
        field(20; "Database Name"; Text[50])
        {
            Caption = 'Database Name';
            DataClassification = ToBeClassified;
        }
        field(30; "Command Timeout"; Integer)
        {
            Caption = 'Command Timeout';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }
}