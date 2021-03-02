/// <summary>
/// Codeunit Customer Mgt. New (ID 50000).
/// </summary>
codeunit 50000 "Customer Mgt. New"
{
    trigger OnRun()
    begin

    end;

    var
        Text001: Label 'You''ve just changed the customer sale type from "%1" to "%2"';

    /// <summary>
    /// ChangeCustomerBlocked is EventSubscriber on OnAfterValidateEvent event of the Customer table
    /// </summary>
    /// <param name="Rec">VAR Record Customer.</param>
    /// <param name="xRec">VAR Record Customer.</param>
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Name', true, true)]
    local procedure ChangeCustomerBlocked(var Rec: Record Customer; var xRec: Record Customer)
    begin
        Rec.Validate("Blocked Ext", StrPos(LowerCase(Rec.Name), 'block') > 0);
    end;

    /// <summary>
    /// OnBeforePostSalesDocSubscriber is EventSubscriber on OnBeforePostSalesDoc event of the "Sales-Post" codeunit
    /// </summary>
    /// <param name="sender">Codeunit "Sales-Post".</param>
    /// <param name="SalesHeader">VAR Record "Sales Header".</param>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', true, true)]
    local procedure OnBeforePostSalesDocSubscriber(sender: Codeunit "Sales-Post"; var SalesHeader: Record "Sales Header")
    var
        Cust: Record Customer;
    begin
        Cust.Get(SalesHeader."Sell-to Customer No.");
        Cust.TestField("Blocked Ext", false);
        Cust.Get(SalesHeader."Bill-to Customer No.");
        Cust.TestField("Blocked Ext", false);
    end;

    /// <summary>
    /// OnAfterValidateCustomerSaleTypeEvent for test purpoces
    /// </summary>
    /// <param name="CurrFieldNo">Integer.</param>
    /// <param name="Rec">VAR Record Customer.</param>
    /// <param name="xRec">VAR Record Customer.</param>
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Customer Sale Type', false, false)]
    local procedure OnAfterValidateCustomerSaleTypeEvent(CurrFieldNo: Integer; var Rec: Record Customer; var xRec: Record Customer)
    begin
        Message(StrSubstNo(Text001, format(xRec."Customer Sale Type"), format(Rec."Customer Sale Type")));
    end;
}