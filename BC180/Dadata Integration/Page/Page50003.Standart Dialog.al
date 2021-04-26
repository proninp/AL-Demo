page 50003 "Standard Dialog"
{
    Caption = 'Set Data';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = '';

                field(DadataInn; DadataInnText)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Company INN';
                    ToolTip = 'Specifies INN of the company.';
                    Visible = IsDadataRequestVisible;
                    ShowMandatory = true;
                    trigger Onvalidate()
                    var
                        CheckInputDataMgt: Codeunit "Check Input Data Mgt.";
                    begin
                        CheckInputDataMgt.CheckInnPattern(DadataInnText);
                    end;
                }
                field(DadataKpp; DadataKppText)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Company KPP';
                    ToolTip = 'KPP of the company. If you do not specify value of KPP then system will return head otganization.';
                    Visible = IsDadataRequestVisible;
                    Editable = IsCompanyInformationRequest;
                    trigger Onvalidate()
                    var
                        CheckInputDataMgt: Codeunit "Check Input Data Mgt.";
                    begin
                        CheckInputDataMgt.CheckKppPattern(DadataKppText);
                    end;
                }
            }
        }
    }
    var
        DadataInnText: Text;
        DadataKppText: Text;
        IsDadataRequestVisible: Boolean;
        IsCompanyInformationRequest: Boolean;

    procedure setDadataRequestInnKppValues(NewInnText: Text; NewKppText: Text)
    begin
        DadataInnText := NewInnText;
        DadataKppText := NewKppText;
    end;

    procedure GetDadataRequestInnKppValues(var NewInnText: Text; var NewKppText: Text)
    begin
        NewInnText := DadataInnText;
        NewKppText := DadataKppText;
    end;

    procedure SetDadataRequestVisible(IsVisibleP: Boolean)
    begin
        IsDadataRequestVisible := IsVisibleP;
        IsCompanyInformationRequest := IsVisibleP;
    end;

    procedure SetDadataRequestVisible(IsVisibleP: Boolean; IsKppEditable: Boolean)
    begin
        IsDadataRequestVisible := IsVisibleP;
        IsCompanyInformationRequest := IsKppEditable;
    end;
}
