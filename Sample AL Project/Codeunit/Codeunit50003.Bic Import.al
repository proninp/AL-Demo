/// <summary>
/// Codeunit Bic Import (ID 50003).
/// </summary>
codeunit 50003 "Bic Import"
{
    trigger OnRun()
    begin
        DownloadFile('http://www.cbr.ru/s/newbik', 'BicZip.zip')
    end;

    var
        ErrText001: Label 'The file name must not be empty!';
        ErrText002: Label 'The URL must not be empty!';
        ErrText003: Label 'The call to the web service failed.';
        ErrText004: Label 'The web service returned an error message:\Status code: %1\Description: %2';

    local procedure DownloadFile(WebLinkP: Text; FileNameP: Text)
    var
        FileMgt: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        Client: HttpClient;
        Response: HttpResponseMessage;
        Instram: InStream;
        WebClient: Dotnet WebClient;
    begin
        if FileNameP = '' then
            Error(ErrText001);
        if WebLinkP = '' then
            Error(ErrText002);
        if File.Exists(FileNameP) then
            File.Erase(FileNameP);
        WebClient := WebClient.WebClient();
        WebClient.DownloadFile(WebLinkP, 'D:\' + FileNameP);
        WebClient.Dispose();
    end;
}