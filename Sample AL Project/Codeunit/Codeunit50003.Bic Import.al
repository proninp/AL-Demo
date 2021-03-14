/// <summary>
/// Codeunit Bic Import (ID 50003).
/// </summary>
codeunit 50003 "Bic Import"
{
    trigger OnRun()
    begin
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
        Text002: label 'SampleDir\BicZip.zip'; // Here might be your personal or server directoty

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
    begin
        DataCompression.OpenZipArchive(ResponseInStreamP, false);
        DataCompression.GetEntryList(TextEntries);
        foreach TextEntry in TextEntries do begin
            Clear(TempBlob);
            TempBlob.CreateOutStream(ResponseOutStream, TextEncoding::UTF8);
            DataCompression.ExtractEntry(TextEntry, ResponseOutStream, TextEntryLen);
            TempBlob.CreateInStream(ResponseInStreamP, TextEncoding::UTF8);
            //XmlBuffer.Reset();
            //XmlBuffer.DeleteAll();
            //XmlBuffer.LoadFromStream(ResponseInStreamP); // This is one of several methods that you can use for parse xml, but it is really slow
            ParseXml(ResponseInStreamP);
        end;
    end;

    local procedure ParseXml(ResponseInStreamP: InStream)
    var
        BankDirectoty: Record "Bank Directory";
        XmlDoc: XmlDocument;
        Node: XmlNode;
        EDNodes: XmlNodeList;
        Element: XmlElement;
        Attributes: XmlAttributeCollection;
        Attribute: XmlAttribute;
    begin
        XmlDocument.ReadFrom(ResponseInStreamP, XmlDoc);
        XmlDoc.GetRoot(Element); // ED807
        EDNodes := Element.GetChildElements(); // BICDirectoryEntry
        foreach Node in EDNodes do begin
            Element := Node.AsXmlElement();
            Attributes := Element.Attributes();
            if Attributes.Get(1, Attribute) then
                ParseBicDirectoty(BankDirectoty, Attribute, Element);
        end;
        UpdateBankAccountByBankDir();
    end;

    local procedure ParseBicDirectoty(var BankDirectotyP: Record "Bank Directory"; var AttributeP: XmlAttribute; var ElementP: XmlElement)
    var
        BicEntryNodes: XmlNodeList;
        AccNodes: XmlNodeList;
        RstrNodes: XmlNodeList;
        Node: XmlNode;
        Element: XmlElement;
        BicAttributeLabel: Label 'BIC';
        ParticipantInfoLabel: Label ':ParticipantInfo';
        AccountsLabel: label ':Accounts';
        ElementName: Text;
    begin
        if not (AttributeP.Name = BicAttributeLabel) then
            exit;

        if not BankDirectotyP.Get(AttributeP.Value) then begin
            BankDirectotyP.Init();
            BankDirectotyP.BIC := AttributeP.Value;
            BankDirectotyP.SystemCreatedAt := CurrentDateTime;
            BankDirectotyP.Insert();
        end else begin
            Message('Repeat: ' + BankDirectotyP.BIC);
            exit;
        end;
        if not ElementP.HasElements() then
            exit;
        BicEntryNodes := ElementP.GetChildElements();
        foreach Node in BicEntryNodes do begin
            if Node.IsXmlElement() then begin
                Element := Node.AsXmlElement(); // For Debug purpose
                ElementName := Element.Name;
                case Element.Name of
                    ParticipantInfoLabel:
                        ParseParticipantInfo(BankDirectotyP, Element);
                    AccountsLabel:
                        ParseAccounts(BankDirectotyP, Element);
                end;
            end;
        end;
    end;

    local procedure ParseParticipantInfo(var BankDirectotyP: Record "Bank Directory"; var ElementP: XmlElement)
    var
        Attributes: XmlAttributeCollection;
        Attribute: XmlAttribute;
    begin
        if ElementP.HasAttributes then begin
            Attributes := ElementP.Attributes();
            foreach Attribute in Attributes do begin
                case Attribute.Name of
                    'NameP':
                        begin
                            BankDirectotyP."Short Name" := Copystr(Attribute.Value, 1, MaxStrLen(BankDirectotyP."Short Name"));
                            BankDirectotyP."Full Name" := Copystr(Attribute.Value, 1, MaxStrLen(BankDirectotyP."Full Name"));
                        end;
                    'Rgn':
                        BankDirectotyP."Region Code" := Attribute.Value;
                    'Ind':
                        BankDirectotyP."Post Code" := Attribute.Value;
                    'Tnp':
                        case true of
                            lowercase(Attribute.Value) In ['г.', 'г']:
                                BankDirectotyP."Area Type" := BankDirectotyP."Area Type"::Gorod;
                            lowercase(Attribute.Value) In ['п.', 'п']:
                                BankDirectotyP."Area Type" := BankDirectotyP."Area Type"::Poselok;
                            lowercase(Attribute.Value) In ['с.', 'с']:
                                BankDirectotyP."Area Type" := BankDirectotyP."Area Type"::Selo;
                            lowercase(Attribute.Value) In ['пгт.', 'пгт']:
                                BankDirectotyP."Area Type" := BankDirectotyP."Area Type"::"Poselok gorodskogo tipa";
                            lowercase(Attribute.Value) In ['ст-ца']:
                                BankDirectotyP."Area Type" := BankDirectotyP."Area Type"::Stanica;
                            lowercase(Attribute.Value) In ['аул']:
                                BankDirectotyP."Area Type" := BankDirectotyP."Area Type"::Aul;
                            lowercase(Attribute.Value) In ['рп.', 'рп']:
                                BankDirectotyP."Area Type" := BankDirectotyP."Area Type"::"Rabochiy poselok";
                            else
                                BankDirectotyP."Area Type" := 0; // unknown
                        end;
                    'Nnp':
                        BankDirectotyP."Area Name" := Attribute.Value;
                    'Adr':
                        BankDirectotyP.Address := CopyStr(Attribute.Value, 1, MaxStrLen(BankDirectotyP.Address));
                    'DateIn':
                        BankDirectotyP."Date In" := ConvertDate(Attribute.Value);
                    'DateOut':
                        BankDirectotyP."Date Out" := ConvertDate(Attribute.Value);
                    'PtType':
                        case Attribute.Value of
                            '00':
                                BankDirectotyP.Type := BankDirectotyP.Type::GRKC;
                            '10':
                                BankDirectotyP.Type := BankDirectotyP.Type::RKC;
                            '12':
                                BankDirectotyP.Type := BankDirectotyP.Type::Bank;
                            '15':
                                BankDirectotyP.Type := BankDirectotyP.Type::"Comm.Bank";
                            '16':
                                BankDirectotyP.Type := BankDirectotyP.Type::"Sber.Bank";
                            '20':
                                BankDirectotyP.Type := BankDirectotyP.Type::"Shar.Comm.Bank";
                            '30':
                                BankDirectotyP.Type := BankDirectotyP.Type::"Private Comm.Bank";
                            '40':
                                BankDirectotyP.Type := BankDirectotyP.Type::"Cooper.Bank";
                            '51':
                                BankDirectotyP.Type := BankDirectotyP.Type::AgroPromBank;
                            '52':
                                BankDirectotyP.Type := BankDirectotyP.Type::"Bank Filial";
                            '60':
                                BankDirectotyP.Type := BankDirectotyP.Type::"Comm.Bamk Filial";
                            '65':
                                BankDirectotyP.Type := BankDirectotyP.Type::"SB Branch";
                            '71':
                                BankDirectotyP.Type := BankDirectotyP.Type::"Shar.Comm.Bank Filial";
                            '75':
                                BankDirectotyP.Type := BankDirectotyP.Type::"Private Bank Filial";
                            '78':
                                BankDirectotyP.Type := BankDirectotyP.Type::"Cooper.Bank Filial";
                            '90':
                                BankDirectotyP.Type := BankDirectotyP.Type::"AgroPromBank Filial";
                            '99':
                                BankDirectotyP.Type := BankDirectotyP.Type::"Field CB Branch";
                            else
                                BankDirectotyP.Type := 0; // unknown
                        end;
                    'ParticipantStatus':
                        case Attribute.Value of
                            'PSAC':
                                begin
                                    if not BankDirectotyP.PSAC then begin
                                        BankDirectotyP.PSAC := true;
                                        BankDirectotyP."PSAC Date" := Today();
                                    end;
                                    if BankDirectotyP.PSDL then begin
                                        BankDirectotyP.PSDL := false;
                                        BankDirectotyP."PSDL Date" := 0D;
                                    end;
                                end;

                            'PSDL':
                                begin
                                    if not BankDirectotyP.PSDL then begin
                                        BankDirectotyP.PSDL := true;
                                        BankDirectotyP."PSDL Date" := Today();
                                    end;
                                    if BankDirectotyP.PSAC then begin
                                        BankDirectotyP.PSAC := false;
                                        BankDirectotyP."PSAC Date" := 0D;
                                    end;
                                end;
                            'UID':
                                BankDirectotyP.UID := Attribute.Value;
                        end;
                end; // Attribute.Name
            end; // foreach
        end; // ElementP.HasAttributes

        if ElementP.HasElements() then
            ParseRstrList(ElementP, BankDirectotyP);

        BankDirectotyP.Modify();
    end;

    local procedure ParseAccounts(var BankDirectotyTmpP: Record "Bank Directory" temporary; var ElementP: XmlElement)
    var
        BankAcc: Record "Bank Account";
        Attributes: XmlAttributeCollection;
        Attribute: XmlAttribute;
        IsBankAccFound: Boolean;
    begin
        IsBankAccFound := false;
        if ElementP.HasAttributes then begin
            BankAcc.Reset();
            Attributes := ElementP.Attributes();
            foreach Attribute in Attributes do begin
                Case Attribute.Name of
                    'Account':
                        begin
                            BankAcc.SetRange("Bank Account No.", Attribute.Value);
                            if not BankAcc.FindFirst() then begin
                                BankAcc.Init();
                                BankAcc."No." := Attribute.Value;
                                BankAcc."Bank Account No." := Attribute.Value;
                                BankAcc.Insert();
                            end;
                            IsBankAccFound := true;
                        end;
                    'AccountCBRBIC':
                        BankAcc."Bank BIC" := Attribute.Value;
                    'DateIn':
                        BankAcc."Date In" := ConvertDate(Attribute.Value);
                    'DateOut':
                        begin
                            BankAcc."Date Out" := ConvertDate(Attribute.Value);
                            BankAcc.Blocked := (BankAcc."Date Out" <= Today()) and (not BankAcc.Blocked);
                        end;
                    'AccountStatus':
                        case Attribute.Value of
                            'ACAC':
                                BankAcc.ACAC := true;
                            'ACDL':
                                BankAcc.ACDL := true;
                        end;
                End;
            end; // Attribute in Attributes
        end; // ElementP.HasAttributes
        if ElementP.HasElements then
            ParseAccRstr(ElementP, BankAcc); // Parse <AccRstrList>
        if IsBankAccFound then
            BankAcc.Modify();
    end;

    local procedure ParseRstrList(var ElementP: XmlElement; var BankDirectotyP: Record "Bank Directory")
    var
        NodeList: XmlNodeList;
        Node: XmlNode;
        Element: XmlElement;
        Attributes: XmlAttributeCollection;
        Attribute: XmlAttribute;
        ElementName: Text;
        RstrListLabel: label ':RstrList';
    begin
        NodeList := ElementP.GetChildElements();
        foreach Node in NodeList do begin
            if Node.IsXmlElement then begin
                Element := Node.AsXmlElement();
                ElementName := Element.Name; // For Debug purpose
                if (Element.Name = RstrListLabel) and Element.HasAttributes() then begin
                    Attributes := Element.Attributes();
                    foreach Attribute in Attributes do begin
                        case Attribute.Name of
                            'Rstr':
                                case Attribute.Value of
                                    'LWRS':
                                        BankDirectotyP.LWRS := true;
                                    'URRS':
                                        BankDirectotyP.URRS := true;
                                    'MRTR':
                                        BankDirectotyP.MRTR := true;
                                end;
                            'RstrDate':
                                case true of
                                    BankDirectotyP.LWRS:
                                        BankDirectotyP."LWRS Date" := ConvertDate(Attribute.Value);
                                    BankDirectotyP.URRS:
                                        BankDirectotyP."URRS Date" := ConvertDate(Attribute.Value);
                                    BankDirectotyP.MRTR:
                                        BankDirectotyP."MRTR Date" := ConvertDate(Attribute.Value);
                                end;
                        end;
                    end; // foreach Attribute in Attributes
                end; // (Element.Name = 'RstrList')
            end; // Node.IsXmlElement
        end; // foreach Node in NodeList
    end;

    local procedure ParseAccRstr(var ElementP: XmlElement; var BankAccP: Record "Bank Account")
    var
        NodeList: XmlNodeList;
        Node: XmlNode;
        Element: XmlElement;
        Attributes: XmlAttributeCollection;
        Attribute: XmlAttribute;
        ElementName: Text;
        AccRstrListLabel: label ':AccRstrList';
    begin
        NodeList := ElementP.GetChildElements();
        foreach Node in NodeList do begin
            if Node.IsXmlElement then begin
                Element := Node.AsXmlElement();
                ElementName := Element.Name; // For Debug purpose
                if (Element.Name = AccRstrListLabel) and Element.HasAttributes() then begin
                    Attributes := Element.Attributes();
                    foreach Attribute in Attributes do begin
                        case Attribute.Name of
                            'AccRstr':
                                case Attribute.Value of
                                    'LMRS':
                                        BankAccP.LMRS := true;
                                    'URRS':
                                        BankAccP.URRS := true;
                                    'CLRS':
                                        BankAccP.CLRS := true;
                                    'FPRS':
                                        BankAccP.FPRS := true;
                                end;
                            'AccRstrDate':
                                case true of
                                    BankAccP.LMRS:
                                        BankAccP."LMRS Date" := ConvertDate(Attribute.Value);
                                    BankAccP.URRS:
                                        BankAccP."URRS Date" := ConvertDate(Attribute.Value);
                                    BankAccP.CLRS:
                                        begin
                                            BankAccP."CLRS Date" := ConvertDate(Attribute.Value);
                                            BankAccP.Blocked := (BankAccP."CLRS Date" <= Today()) and (not BankAccP.Blocked);
                                        end;

                                    BankAccP.FPRS:
                                        BankAccP."FPRS Date" := ConvertDate(Attribute.Value);
                                end;
                        end; // case Attribute.Name
                    end; // foreach Attribute in Attributes
                end;
            end; // Node.IsXmlElement
        end;
    end;

    local procedure UpdateBankAccountByBankDir()
    var
        BankDirectory: Record "Bank Directory";
        BankAcc: Record "Bank Account";
        Name: Text;
        Name2: Text;
        Address: Text;
        Address2: Text;
    begin
        BankAcc.Reset();
        BankDirectory.Reset();
        if BankDirectory.FindSet() then
            repeat
                BankAcc.SetRange("Bank BIC", BankDirectory.BIC);
                if BankAcc.FindFirst() then begin
                    Name := '';
                    Name2 := '';
                    Address := '';
                    Address2 := '';
                    // Update Name
                    Name := CopyStr(BankDirectory."Full Name", 1, MaxStrLen(BankAcc.Name));
                    if StrLen(BankDirectory."Full Name") > MaxStrLen(BankAcc.Name) then
                        Name2 := CopyStr(BankDirectory."Full Name", MaxStrLen(BankAcc.Name), MaxStrLen(BankAcc."Name 2"));
                    if (Name + Name2) <> (BankAcc.Name + BankAcc."Name 2") then begin
                        BankAcc.ModifyAll(Name, Name, false);
                        BankAcc.ModifyAll("Name 2", Name2, false);
                    end;
                    // Update Address
                    Address := CopyStr(BankDirectory.Address, 1, MaxStrLen(BankAcc.Address));
                    if StrLen(BankDirectory.Address) > MaxStrLen(BankAcc.Address) then
                        Address2 := CopyStr(BankDirectory.Address, MaxStrLen(BankAcc.Address), MaxStrLen(BankAcc."Address 2"));
                    if (Address + Address2) <> (BankAcc.Address + BankAcc."Address 2") then begin
                        BankAcc.ModifyAll(Address, Address, false);
                        BankAcc.ModifyAll("Address 2", Address2, false);
                    end;
                    // Update other information
                    if BankAcc."Post Code" <> BankDirectory."Post Code" then
                        BankAcc.ModifyAll("Post Code", CopyStr(BankDirectory."Post Code", 1, MaxStrLen(BankAcc."Post Code")));
                    if BankAcc."Country/Region Code" <> BankDirectory."Region Code" then
                        BankAcc.ModifyAll("Country/Region Code", CopyStr(BankDirectory."Region Code", 1, MaxStrLen(BankAcc."Country/Region Code")));
                    if BankDirectory."Area Type" = BankDirectory."Area Type"::Gorod then
                        if BankAcc.City <> BankDirectory."Area Name" then
                            BankAcc.ModifyAll(City, CopyStr(BankDirectory."Area Name", 1, MaxStrLen(BankAcc.City)));
                    // Check if Blocked
                    if BankDirectory.LWRS and (BankDirectory."LWRS Date" <= Today()) then
                        BankAcc.ModifyAll(Blocked, true);
                    if BankDirectory.PSDL then begin
                        BankAcc.ModifyAll(Blocked, true);
                        BankAcc.ModifyAll(ACDL, true);
                    end;
                end;
            until BankDirectory.Next() = 0;
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

    local procedure ConvertDate(TextDateP: Text) NewDateR: Date
    var
        NewDateText: Text;
    begin
        NewDateR := 0D;
        NewDateText := '';
        if StrLen(TextDateP) = 10 then
            NewDateText := StrSubstNo('%1.%2.%3', CopyStr(TextDateP, 9, 2), CopyStr(TextDateP, 6, 2), CopyStr(TextDateP, 1, 4));
        if Evaluate(NewDateR, NewDateText) then;
        exit(NewDateR);
    end;
}