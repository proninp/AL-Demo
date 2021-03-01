/// <summary>
/// PageExtension Customer Card Page Ext. (ID 80021) extends Record Customer Card.
/// </summary>
pageextension 80021 "Customer Card Page Ext." extends "Customer Card"
{
    layout
    {
        addafter(Name)
        {
            /// <summary>
            /// This field is responsible for blocking customer
            /// </summary>
            field("Blocked Ext"; Rec."Blocked Ext")
            {

            }
        }
    }
}