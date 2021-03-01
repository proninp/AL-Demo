/// <summary>
/// TableExtension Customer Blocks (ID 80018) extends Record Customer.
/// </summary>
tableextension 80018 "Customer Blocks" extends Customer
{
    fields
    {
        /// <summary>
        /// This field is responsible for blocking customer
        /// </summary>
        field(50000; "Blocked Ext"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Blocked';
            Editable = false;
        }
    }
}