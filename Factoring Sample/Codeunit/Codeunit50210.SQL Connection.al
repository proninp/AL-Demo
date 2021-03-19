codeunit 50210 "SQL Connection"
{
    trigger OnRun()
    begin

    end;

    var
        SQLConnection: DotNet SqlConnection;
        IsConnected: Boolean;
        ConnectionStringTemplate: Label 'Data Source = %1; Initial Catalog = %2; Max Pool Size = 1024; Trusted_Connection = True;';

    procedure Connect(var SqlConnectionV: DotNet SqlConnection)
    begin
        if not IsConnected then begin
            SqlConnection := SqlConnection.SqlConnection(ConnectionStringBuilder());
            SqlConnection.Open();
            IsConnected := true;
        end;
        SqlConnectionV := SQLConnection;
    end;

    procedure Disconnect(var SqlConnectionV: DotNet SqlConnection)
    begin
        SQLConnection.Dispose();
        SQLConnection.Close();
        Clear(SQLConnection);
        IsConnected := false;
        SqlConnectionV := SqlConnection;
    end;

    local procedure ConnectionStringBuilder(): Text
    var
        SqlConnectionSetup: Record "SQL Connection Setup";
    begin
        SqlConnectionSetup.Get();
        SqlConnectionSetup.TestField("Server Name");
        SqlConnectionSetup.TestField("Database Name");
        exit(StrSubstNo(ConnectionStringTemplate, SqlConnectionSetup."Server Name", SqlConnectionSetup."Database Name"));
    end;
}