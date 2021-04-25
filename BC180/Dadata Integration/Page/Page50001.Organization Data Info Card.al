page 50001 "Organization Dadata Info Card"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Organization Dadata Info Card';
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Organization Dadata Info";
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
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
                field("OPF Short"; Rec."OPF Short")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(OGRN; Rec.OGRN)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(OKPO; Rec.OKPO)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(OKATO; Rec.OKATO)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(OKTMO; Rec.OKTMO)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(OKOGU; Rec.OKOGU)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(OKFS; Rec.OKFS)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(OKVED; Rec.OKVED)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Address)
            {
                Caption = 'Address';
                field("Full Address"; Rec."Full Address")
                {
                    ApplicationArea = Basic, Suite;
                    MultiLine = true;
                }
                field("Postal Code"; Rec."Postal Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Country ISO Code"; Rec."Country ISO Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("OKATO Address"; Rec."OKATO Address")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("OKTMO Address"; Rec."OKTMO Address")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Geo Lat"; Rec."Geo Lat")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Geo Lon"; Rec."Geo Lon")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Tax Office"; Rec."Tax Office")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Other)
            {
                Caption = 'Other';
                field(Phones; Rec.Phones)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Emails; Rec.Emails)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("OKVED Type"; Rec."OKVED Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Created DateTime"; Rec."Created DateTime")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Requested DateTime';
                }
                field("Created UserID"; Rec."Created UserID")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Requested by User';
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Create Customer")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Create Customer';
                Image = NewCustomer;
                ToolTip = 'Crates new customer from dadata info.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    DadataApiMgt: Codeunit "Dadata API Management";
                begin
                    DadataApiMgt.CreateCustomer(Rec);
                end;
            }
            action("Create Vendor")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Create Vendor';
                Image = NewOpportunity;
                ToolTip = 'Crates new vendor from dadata info.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    DadataApiMgt: Codeunit "Dadata API Management";
                begin
                    DadataApiMgt.CreateVendor(Rec);
                end;
            }
        }
    }

}