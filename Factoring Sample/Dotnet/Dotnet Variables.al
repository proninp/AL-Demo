dotnet
{
    assembly(System.Data)
    {
        type(System.Data.SqlClient.SqlConnection; SqlConnection) { }
        type(System.Data.SqlClient.SqlCommand; SqlCommand) { }
        type(System.Data.SqlClient.SqlDataReader; SqlDataReader) { }
        type(System.Data.SqlClient.SqlDataAdapter; SqlDataAdapter) { }
        type(System.Data.DataRowCollection; DataRowCollection) { }
        type(System.Data.DataColumn; DataColumn) { }
        type(System.Data.DataColumnCollection; DataColumnCollection) { }
    }
    assembly(System)
    {
        type(System.Text.RegularExpressions.Regex; RegExp) { }
        type(System.Text.RegularExpressions.RegexOptions; RegexOption) { }
    }
}