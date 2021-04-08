page 50202 "Org. Dadata Info List.al"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Organization Dadata Info List';
    CardPageId = "Organization Dadata Info Card";
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Processing,Report';
    SourceTable = "Organization Dadata Info";
    SourceTableView = SORTING("Entry No.")
                      ORDER(Descending);
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Inn; Rec.Inn)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Kpp; Rec.Kpp)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(OGRN; Rec.OGRN)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(OKATO; Rec.OKATO)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(OKFS; Rec.OKFS)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(OKOGU; Rec.OKOGU)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(OKPO; Rec.OKPO)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(OKTMO; Rec.OKTMO)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(OKVED; Rec.OKVED)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Full Address"; Rec."Full Address")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(SendRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send Dadata Request';
                Image = LaunchWeb;
                ToolTip = 'Sends Request to Dadata service and recieves company information.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    DadataApiMgt: Codeunit "Dadata API Mgt.";
                begin
                    if Rec.Get(DadataApiMgt.GetCompanyInformation()) then;
                    Rec.SetPosition(Rec.GetPosition());
                end;
            }
        }
    }

}