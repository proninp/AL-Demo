page 50200 "Organization Dadata Info Card"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Organization Dadata Info Card';
    PageType = Card;
    SourceTable = "Organization Dadata Info";
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(General)
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
            }
        }
    }

}
