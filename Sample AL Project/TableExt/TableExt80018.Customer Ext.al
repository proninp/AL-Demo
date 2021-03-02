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

        /// <summary>
        /// This field is defining type of sale to the current customer
        /// </summary>
        field(50001; "Customer Sale Type"; Enum "Customer Sale Type")
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
            end;
        }
    }
}