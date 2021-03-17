page 60000 "Standard Dialog"
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
                field(PaymentDate; PaymentCreationDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Payment Creation Date';
                    ToolTip = 'Specifies the creation date.';
                    Visible = IsPaymentControlsVisible;
                }
                field(PaymentAmount; PaymentAmount)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Payment Amount';
                    ToolTip = 'Specifies the payment amount.';
                    Visible = IsPaymentControlsVisible;
                }
                field(ComissionStartDate; ComissionStartDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Comisssion Start Date';
                    ToolTip = 'Specifies comission start date.';
                    Visible = IsCommissionControlsVisible;
                    trigger OnValidate()
                    begin
                        CheckComissionDates();
                    end;
                }
                field(ComissionEndDate; ComissionEndDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Comission End Date';
                    ToolTip = 'Specifies comission end date.';
                    Visible = IsCommissionControlsVisible;
                    trigger OnValidate()
                    begin
                        CheckComissionDates();
                    end;
                }
            }
        }
    }
    var
        PaymentAmount: Decimal;
        PaymentCreationDate: Date;
        ComissionStartDate: Date;
        ComissionEndDate: Date;
        IsPaymentControlsVisible: Boolean;
        IsCommissionControlsVisible: Boolean;
        ErrText001: Label 'Start date must be earlier then End date.';

    procedure SetPaymentValues(NewCreationDate: Date; NewAmount: Decimal)
    begin
        PaymentCreationDate := NewCreationDate;
        PaymentAmount := NewAmount;
    end;

    procedure GetPaymentValues(var NewCreationDate: Date; var NewAmount: Decimal)
    begin
        NewCreationDate := PaymentCreationDate;
        NewAmount := PaymentAmount;
    end;

    procedure SetComissionValues(NewComissionStartDate: Date; NewComissionEndDate: Date)
    begin
        ComissionStartDate := NewComissionStartDate;
        ComissionEndDate := NewComissionEndDate;
    end;

    procedure GetComissionValues(var NewComissionStartDate: Date; var NewComissionEndDate: Date)
    begin

        NewComissionStartDate := ComissionStartDate;
        NewComissionEndDate := ComissionEndDate;
    end;

    procedure SetPaymentVisible(IsVisibleP: Boolean)
    begin
        IsPaymentControlsVisible := IsVisibleP;
    end;

    procedure SetComissionVisible(IsVisibleP: Boolean)
    begin
        IsCommissionControlsVisible := IsVisibleP;
    end;

    local procedure CheckComissionDates()
    begin
        if (ComissionStartDate <> 0D) and (ComissionEndDate <> 0D) then
            if ComissionStartDate > ComissionEndDate then
                Error(ErrText001);
    end;
}

