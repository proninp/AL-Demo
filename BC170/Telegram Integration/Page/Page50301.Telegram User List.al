page 50301 "Telegram User List"
{
    ApplicationArea = All;
    Caption = 'Telegram User List';
    PageType = List;
    SourceTable = "Telegram User Setup";
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                }
                field("Bot Name"; Rec."Bot Name")
                {
                    ApplicationArea = All;
                }
                field("Chat ID"; Rec."Chat ID")
                {
                    ApplicationArea = All;
                }
                field("Fitst Name"; Rec."Fitst Name")
                {
                    ApplicationArea = All;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = All;
                }
                field("Telegram User ID"; Rec."Telegram User ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
