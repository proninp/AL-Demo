codeunit 50211 "SQL Query"
{
    trigger OnRun()
    begin

    end;

    var
        cuSQLConnection: Codeunit "SQL Connection";
        SQLConnection: DotNet SqlConnection;
        SQLCommand: DotNet SQLCommand;
        SQLDataAdapter: DotNet SqlDataAdapter;
        DataTable: DotNet DataTable;
        DataRowCollection: DotNet DataRowCollection;
        DataColumnCollection: DotNet DataColumnCollection;
        DataRow: DotNet DataRow;
        SQLCommandText: Text;
        CurrentRow: Integer;
        TotalRows: Integer;

    procedure Open()
    var
        SQLConnectionSetup: Record "SQL Connection Setup";
    begin
        SQLConnectionSetup.Get();

        OpenConnection();
        SQLCommand := SQLCommand.SqlCommand(SQLCommandText, SQLConnection);
        SQLCommand.CommandTimeout(SQLConnectionSetup."Command Timeout");
        SQLDataAdapter := SQLDataAdapter.SqlDataAdapter(SQLCommand);
        DataTable := DataTable.DataTable();
        SQLDataAdapter.Fill(DataTable);
        DataRowCollection := DataTable.Rows;
        DataColumnCollection := DataTable.Columns;
        TotalRows := RowCount();
    end;

    procedure Close()
    begin
        DataColumnCollection.Clear();
        DataRowCollection.Clear();
        DataTable.Dispose();
        DataTable.Clear();
        SQLDataAdapter.Dispose();
        SQLCommand.Dispose();

        ClearAll();
    end;

    procedure GetFieldValueByName(ColumnNameP: Text; var VariantVarP: Variant) IsNull: Boolean
    begin
        if DataRow.IsNull(ColumnNameP) then
            exit(true);
        VariantVarP := DataRow.Item(ColumnNameP);
    end;

    procedure GetFieldValueByNameBool(ColumnNameP: Text) Result: Boolean
    var
        VariantVar: Variant;
    begin
        if GetFieldValueByName(ColumnNameP, VariantVar) then
            exit(false);
        Result := VariantVar;
    end;

    procedure GetFieldValueByNameInt(ColumnNameP: Text) Result: Integer
    var
        VariantVar: Variant;
    begin
        if GetFieldValueByName(ColumnNameP, VariantVar) then
            exit(0);
        Result := VariantVar;
    end;

    procedure GetFieldValueByNameBigInt(ColumnNameP: Text) Result: BigInteger
    var
        VariantVar: Variant;
    begin
        if GetFieldValueByName(ColumnNameP, VariantVar) then
            exit(0);
        Result := VariantVar;
    end;

    procedure GetFieldValueByNameDec(ColumnNameP: Text) Result: Decimal
    var
        VariantVar: Variant;
    begin
        if GetFieldValueByName(ColumnNameP, VariantVar) then
            exit(0);
        Result := VariantVar;
    end;

    procedure GetFieldValueByNameDate(ColumnNameP: Text) Result: Date
    var
        VariantVar: Variant;
        DatetimeVar: DateTime;
    begin
        if GetFieldValueByName(ColumnNameP, VariantVar) then
            exit(0D);
        DatetimeVar := VariantVar;
        Result := DT2Date(DatetimeVar);
        if Result = 17530101D then
            exit(0D);
    end;

    procedure GetFieldValueByNameTime(ColumnNameP: Text) Result: Time
    var
        VariantVar: Variant;
        DatetimeVar: DateTime;
    begin
        if GetFieldValueByName(ColumnNameP, VariantVar) then
            exit(0T);
        DatetimeVar := VariantVar;
        Result := DT2Time(DatetimeVar);
    end;

    procedure GetFieldValueByNameDateTime(ColumnNameP: Text) Result: DateTime
    var
        VariantVar: Variant;
    begin
        if GetFieldValueByName(ColumnNameP, VariantVar) then
            exit(0DT);
        Result := VariantVar;
    end;

    procedure GetFieldValueByNameStr(ColumnNameP: Text) Result: Text
    var
        VariantVar: Variant;
    begin
        if GetFieldValueByName(ColumnNameP, VariantVar) then
            exit('');
        Result := VariantVar;
    end;

    procedure GetFieldValueByIndex(ColumnIndexP: Integer; var VariantP: Variant) IsNull: Boolean
    begin
        if DataRow.IsNull(ColumnIndexP) then
            exit(true);
        VariantP := DataRow.Item(ColumnIndexP);
    end;

    procedure ConvertDateToSQL(DateP: Date): Text
    var
        Day: Text;
        Month: Text;
        Year: Text;
    begin
        if DateP = 0D then
            exit('1753-01-01');
        Day := format(Date2DMY(DateP, 1));
        if StrLen(Day) = 1 then
            Day := '0' + Day;
        Month := format(Date2DMY(DateP, 2));
        if StrLen(Month) = 1 then
            Month := '0' + Month;
        Year := format(Date2DMY(DateP, 3));
        exit(StrSubstNo('%1-%2-%3', Year, Month, Day));
    end;

    procedure ConvertDateToNav(DateTextP: Text) Result: Date
    var
        DateText: Text;
        Day: Text;
        Month: Text;
        Year: text;
    begin
        Result := 0D;
        if DateTextP = '' then
            exit(Result);
        Year := CopyStr(DateTextP, 1, 4);
        Month := CopyStr(DateTextP, 6, 2);
        Day := CopyStr(DateTextP, 9, 2);
        if Evaluate(Result, StrSubstNo('%1.%2.%3', Day, Month, Year)) then;
        exit(Result);
    end;

    procedure GetFirstRow(): Boolean
    begin
        if TotalRows = 0 then
            exit(false);
        CurrentRow := 1;
        DataRow := DataRowCollection.Item(CurrentRow - 1);
    end;

    local procedure RowCount(): Integer
    begin
        exit(DataRowCollection.Count());
    end;

    local procedure FieldCount(): Integer
    begin
        exit(DataColumnCollection.Count());
    end;

    procedure EOF(): Boolean
    begin
        if CurrentRow > TotalRows then
            exit(true);
        CurrentRow += 1;
        DataRow := DataRowCollection.Item(CurrentRow - 1);
        exit(false);
    end;

    local procedure OpenConnection()
    begin
        cuSQLConnection.Connect(SQLConnection);
    end;

    local procedure CloseConnection()
    begin
        cuSQLConnection.Disconnect(SQLConnection);
    end;

    procedure SetCommandText(SQLCommandTextP: Text)
    begin
        SQLCommandText := SQLCommandTextP;
    end;

}