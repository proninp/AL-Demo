page 50300 "Bot Setup"
{
    ApplicationArea = All;
    Caption = 'Bot Setup';
    PageType = Card;
    SourceTable = "Telegram Bot Setup";
    UsageCategory = Administration;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Bot Name"; Rec."Bot Name")
                {
                    ApplicationArea = All;
                }
                field("Bot Token"; Rec."Bot Token")
                {
                    ApplicationArea = All;
                }
                field("Bot Offset"; Rec."Bot Offset")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
