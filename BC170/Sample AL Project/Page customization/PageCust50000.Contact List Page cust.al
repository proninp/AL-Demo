/// <summary>
///  Contact List Customization.
/// </summary>
pagecustomization "Contact List Customization" customizes "Contact List"
{
    layout
    {
        moveafter("Is E-mail Correct"; "Privacy Blocked")
        modify("Privacy Blocked")
        {
            Visible = true;
        }

    }
    //Variables, procedures and triggers are not allowed on Page Customizations
}
