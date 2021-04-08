table 50301 "Telegram User Setup"
{
    Caption = 'Telegram User Setup';
    fields
    {
        field(1; "Bot Name"; Code[30])
        {
            TableRelation = "Telegram Bot Setup"."Bot Name";
            ValidateTableRelation = true;
        }
        field(2; "Chat ID"; BigInteger)
        {
        }
        field(10; "Salesperson Code"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(20; "Fitst Name"; Text[70])
        {
        }
        field(30; "Last Name"; Text[70])
        {
        }
        field(40; "Telegram User ID"; Text[70])
        {
        }
    }

    keys
    {
        key(Key1; "Bot Name", "Chat ID")
        {
            Clustered = true;
        }
    }
}