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
                field(CreationDate; CreationDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Creation Date';
                    ToolTip = 'Specifies the creation date.';
                }
                field(Amount; Amount)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the payment amount.';
                }
            }
        }
    }

    actions
    {
    }

    var
        Amount: Decimal;
        CreationDate: Date;

    procedure SetValues(NewCreationDate: Date; NewAmount: Decimal)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSetValues(NewCreationDate, NewAmount, IsHandled);
        if IsHandled then
            exit;

        CreationDate := NewCreationDate;
        Amount := NewAmount;
    end;

    procedure GetValues(var NewCreationDate: Date; var NewAmount: Decimal)
    begin
        OnBeforeGetValues(NewCreationDate, NewAmount);

        NewCreationDate := CreationDate;
        NewAmount := Amount;
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeSetValues(var NewCreationDate: Date; var NewAmount: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeGetValues(var NewCreationDate: Date; var NewAmount: Decimal)
    begin
    end;
}

