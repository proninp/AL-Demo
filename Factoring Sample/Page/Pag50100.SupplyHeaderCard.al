page 50100 "Supply Header Card"
{
    Caption = 'Supply Header Card';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Order,Request Approval,History,Print/Send,Navigate';
    RefreshOnActivate = true;
    SourceTable = "Supply Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("External Agreement No."; Rec."External Agreement No.")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Agreement No."; Rec."Agreement No.")
                {
                    ApplicationArea = All;
                }
                field("Supply Date"; Rec."Supply Date")
                {
                    ApplicationArea = All;
                }
            }
            group(Other)
            {
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field("Created User ID"; Rec."Created User ID")
                {
                    ApplicationArea = All;
                }
                field("Lines Amount"; Rec."Lines Amount")
                {
                    ApplicationArea = All;
                }
                field("Lines Count"; Rec."Lines Count")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
