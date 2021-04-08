table 50300 "Telegram Bot Setup"
{
    Caption = 'Telegram Bot Setup';
    fields
    {
        field(1; "Bot Name"; Code[30])
        {

        }
        field(10; "Bot Token"; Text[100])
        {

        }
        field(30; "Bot Offset"; BigInteger)
        {

        }
    }

    keys
    {
        key(Key1; "Bot Name")
        {
            Clustered = true;
        }
    }
}