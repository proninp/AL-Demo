/// <summary>
/// Codeunit Bic Import (ID 50003).
/// </summary>
codeunit 50003 "Bic Import"
{
    trigger OnRun()
    begin
        DownloadFileWithWebClient()
    end;

    var
        UrlLink: Text;
        FullFileName: Text;
        ErrText001: Label 'The file name must not be empty!';
        ErrText002: Label 'The URL must not be empty!';
        ErrText003: Label 'The call to the web service failed.';
        ErrText004: Label 'The web service returned an error message:\Status code: %1\Description: %2';
        Text001: Label 'http://www.cbr.ru/s/newbik';
        Text002: label 'D:\BicZip.zip'; // Here might be your personal or server directoty

    procedure ReadZip()
    var
        Client: HttpClient;
        ResponseMsg: HttpResponseMessage;
        ResponseStream: InStream;
        ResponseText: Text;
    begin
        if not Client.Get(UrlLink, ResponseMsg) then
            Error(ErrText003);
        if not ResponseMsg.IsSuccessStatusCode() then begin
            ResponseMsg.Content().ReadAs(ResponseText);
            Error(ErrText004, Format(ResponseMsg.HttpStatusCode), ResponseText);
        end;
        ResponseMsg.Content.ReadAs(ResponseStream);
        UnzipResponse(ResponseStream);
    end;

    local procedure UnzipResponse(ResponseInStreamP: InStream)
    var
        TextEntries: List of [Text];
        TempBlob: Codeunit "Temp Blob";
        DataCompression: Codeunit "Data Compression"; // In previous version it was Zip Stream Wrapper unit
        ResponseOutStream: OutStream;
        TextEntry: Text;
        TextEntryLen: Integer;
        i: Integer;
    begin
        DataCompression.OpenZipArchive(ResponseInStreamP, false);
        DataCompression.GetEntryList(TextEntries);
        for i := 1 to TextEntries.Count do begin
            Clear(TempBlob);
            TempBlob.CreateOutStream(ResponseOutStream, TextEncoding::UTF8);
            TextEntries.Get(i, TextEntry);
            DataCompression.ExtractEntry(TextEntry, ResponseOutStream, TextEntryLen);
            TempBlob.CreateInStream(ResponseInStreamP, TextEncoding::UTF8);
            // Here will be XmlParser
        end;
    end;

    /// <summary>
    /// DownloadFileWithWebClient function just for archive downloading with WebClient class
    /// </summary>
    procedure DownloadFileWithWebClient()
    var
        WebClient: Dotnet WebClient;
    begin
        if UrlLink = '' then
            UrlLink := Text002;
        if FullFileName = '' then
            FullFileName := Text002;

        if FullFileName = '' then
            Error(ErrText001);
        if UrlLink = '' then
            Error(ErrText002);
        if File.Exists(FullFileName) then
            File.Erase(FullFileName);

        WebClient := WebClient.WebClient();
        WebClient.DownloadFile(UrlLink, FullFileName);
        WebClient.Dispose();
    end;
    /// <summary>
    /// SetParams function to set URL link parametr
    /// </summary>
    /// <param name="UrlLinkP">Text of url link</param>
    procedure SetParams(UrlLinkP: Text)
    begin
        UrlLink := UrlLinkP;
    end;
    /// <summary>
    /// Overload of SetParams function to set URL Link and Full File Name parameters
    /// </summary>
    /// <param name="UrlLinkP">Text of url link</param>
    /// <param name="FullFileNameP">Text of directory name with file name</param>
    procedure SetParams(UrlLinkP: Text; FullFileNameP: Text)
    begin
        UrlLink := UrlLinkP;
        FullFileName := FullFileNameP; // Need only for WebClient usage type
    end;
}