page 50004 "Dadata Affiliated Company Card"
{

    Caption = 'Dadata Affiliated Company Card';
    PageType = Card;
    SourceTable = "Dadata Affiliated Company";

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
                field(Inn; Rec.Inn)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(KPP; Rec.KPP)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Affiliated With INN"; Rec."Affiliated With INN")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Legal)
            {
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
                field("Organization Type"; Rec."Organization Type")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Additional)
            {
                field("Actuality Date"; Rec."Actuality Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Registration Date"; Rec."Registration Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Liquidation Date"; Rec."Liquidation Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Status Description"; Rec."Status Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Branches Count"; Rec."Branches Count")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Branch Type"; Rec."Branch Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Detailed Status"; Rec."Detailed Status")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Detailed Status Description"; Rec."Detailed Status Description")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Other)
            {
                field("Created DateTime"; Rec."Created DateTime")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Created UserID"; Rec."Created UserID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Internal Dadata ID"; Rec."Internal Dadata ID")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

}
