/// <summary>
/// Codeunit Bic Import (ID 50003).
/// </summary>
codeunit 50003 "Bic Import"
{
    trigger OnRun()
    begin
        //DownloadFileWithWebClient();
        SetParams(Text001);
        ReadZip();
    end;

    var
        UrlLink: Text;
        FullFileName: Text;
        ErrText001: Label 'The file name must not be empty!';
        ErrText002: Label 'The URL must not be empty!';
        ErrText003: Label 'The call to the web service failed.';
        ErrText004: Label 'The web service returned an error message:\Status code: %1\Description: %2';
        ErrText005: label '%1 table must be temporary.';
        Text001: Label 'http://www.cbr.ru/s/newbik';
        Text002: label 'D:\BicZip.zip'; // Here might be your personal or server directoty

    /// <summary>
    /// ReadZip function to download content from web link as InStream
    /// </summary>
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
        XmlBuffer: Record "XML Buffer";
        TextEntries: List of [Text];
        TempBlob: Codeunit "Temp Blob";
        DataCompression: Codeunit "Data Compression"; // In previous version it was Zip Stream Wrapper unit
        ResponseOutStream: OutStream;
        TextEntry: Text;
        TextEntryLen: Integer;
        i: Integer;

        StartTime: DateTime;
        Dur: Duration;
    begin
        DataCompression.OpenZipArchive(ResponseInStreamP, false);
        DataCompression.GetEntryList(TextEntries);
        for i := 1 to TextEntries.Count do begin
            Clear(TempBlob);
            TempBlob.CreateOutStream(ResponseOutStream, TextEncoding::UTF8);
            TextEntries.Get(i, TextEntry);
            DataCompression.ExtractEntry(TextEntry, ResponseOutStream, TextEntryLen);
            TempBlob.CreateInStream(ResponseInStreamP, TextEncoding::UTF8);
            XmlBuffer.Reset();
            XmlBuffer.DeleteAll();

            StartTime := CurrentDateTime();

            //XmlBuffer.LoadFromStream(ResponseInStreamP); // This is one of several methods that you can use for parse xml, but it is really slow
            ParseXml(ResponseInStreamP);

            Dur := CurrentDateTime - StartTime;
            Message(Format(Dur));
            // Here will be XmlParser
        end;
    end;

    local procedure ParseXml(ResponseInStreamP: InStream)
    var
        BankDirectotyTmp: Record "Bank Directory" temporary;
        XmlDoc: XmlDocument;
        Node: XmlNode;
        EDNodes: XmlNodeList;
        Element: XmlElement;
        Attributes: XmlAttributeCollection;
        Attribute: XmlAttribute;

        i: Integer;
        j: Integer;
    begin
        if not BankDirectotyTmp.IsTemporary then
            Error(ErrText005);

        BankDirectotyTmp.Reset();
        BankDirectotyTmp.DeleteAll();

        XmlDocument.ReadFrom(ResponseInStreamP, XmlDoc);
        XmlDoc.GetRoot(Element); // ED807
        EDNodes := Element.GetChildElements(); // BICDirectoryEntry
        for i := 1 to EDNodes.Count do begin
            EDNodes.Get(i, Node);
            Element := Node.AsXmlElement();
            Attributes := Element.Attributes();
            if Attributes.Get(1, Attribute) then
                ParseBicDirectoty(BankDirectotyTmp, Attribute, Element);
        end;
    end;

    local procedure ParseBicDirectoty(var BankDirectotyTmpP: Record "Bank Directory" temporary; var AttributeP: XmlAttribute; var ElementP: XmlElement)
    var
        BicEntryNodes: XmlNodeList;
        AccNodes: XmlNodeList;
        RstrNodes: XmlNodeList;
        Node: XmlNode;
        Element: XmlElement;
        BicAttributeLabel: Label 'BIC';
        ParticipantInfoLabel: Label 'ParticipantInfo';
        AccountsLabel: label 'Accounts';
        i: Integer;
    begin
        if not (AttributeP.Name = BicAttributeLabel) then
            exit;

        if not BankDirectotyTmpP.Get(AttributeP.Value) then begin
            BankDirectotyTmpP.Init();
            BankDirectotyTmpP.BIC := AttributeP.Value;
            BankDirectotyTmpP.SystemCreatedAt := CurrentDateTime;
            BankDirectotyTmpP.Insert();
        end;
        if not ElementP.HasElements() then
            exit;
        BicEntryNodes := ElementP.GetChildElements();
        if BicEntryNodes.Count = 0 then
            exit;
        for i := 1 to BicEntryNodes.Count do begin
            BicEntryNodes.Get(i, Node);
            if Node.IsXmlElement() then begin
                Element := Node.AsXmlElement();
                case Element.Name of
                    ParticipantInfoLabel:
                        ParseParticipantInfo(BankDirectotyTmpP, Element);
                    AccountsLabel:
                        ParseAccounts(BankDirectotyTmpP, Element);
                end;
            end;
        end;
    end;

    local procedure ParseParticipantInfo(var BankDirectotyTmpP: Record "Bank Directory" temporary; var ElementP: XmlElement)
    var
        Attributes: XmlAttributeCollection;
        Attribute: XmlAttribute;
    begin
        // TODO something to parse ParticipantInfo information
        if ElementP.HasAttributes then begin
            Attributes := ElementP.Attributes();
            foreach Attribute in Attributes do begin
                case Attribute.Name of
                    'NameP':
                        begin
                            BankDirectotyTmpP."Short Name" := Copystr(Attribute.Value, 1, MaxStrLen(BankDirectotyTmpP."Short Name"));
                            BankDirectotyTmpP."Full Name" := Copystr(Attribute.Value, 1, MaxStrLen(BankDirectotyTmpP."Full Name"));
                        end;
                    'Rgn':
                        BankDirectotyTmpP."Region Code" := Attribute.Value;
                    'Ind':
                        BankDirectotyTmpP."Post Code" := Attribute.Value;
                    'Tnp':
                        case true of
                            lowercase(Attribute.Value) In ['г.', 'г']:
                                BankDirectotyTmpP."Area Type" := 1; // Gorod
                            lowercase(Attribute.Value) In ['п.', 'п']:
                                BankDirectotyTmpP."Area Type" := 2; // Poselok
                            lowercase(Attribute.Value) In ['с.', 'с']:
                                BankDirectotyTmpP."Area Type" := 3; // Selo
                            lowercase(Attribute.Value) In ['пгт.', 'пгт']:
                                BankDirectotyTmpP."Area Type" := 4; // Poselok gorodskogo tipa
                            lowercase(Attribute.Value) In ['ст-ца']:
                                BankDirectotyTmpP."Area Type" := 5; // stanitsa
                            lowercase(Attribute.Value) In ['аул']:
                                BankDirectotyTmpP."Area Type" := 6; // aul
                            lowercase(Attribute.Value) In ['рп.', 'рп']:
                                BankDirectotyTmpP."Area Type" := 7; // Rabochiy podelok
                            else
                                BankDirectotyTmpP."Area Type" := 0; // unknown
                        end;
                    'Nnp':
                        BankDirectotyTmpP."Area Name" := Attribute.Value;
                    'Adr':
                        BankDirectotyTmpP.Address := CopyStr(Attribute.Value, 1, MaxStrLen(BankDirectotyTmpP.Address);
                end;
            end;
        end;

    end;

    local procedure ParseAccounts(var BankDirectotyTmpP: Record "Bank Directory" temporary; var ElementP: XmlElement)
    var
        Attributes: XmlAttributeCollection;
        Attribute: XmlAttribute;
    begin
        // TODO something to parse Accounts information
        // Im not shure that we really need to do it
    end;

    /// <summary>
    /// DownloadFileWithWebClient() function just for archive downloading with WebClient class
    /// It's a sample piece of code that we can use for downloading files from web without dialog message
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