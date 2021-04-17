codeunit 50000 "Dadata API Management"
{
    var
        ErrText001: Label 'Variable of "%1" record must be temporary.';
        ErrText002: Label 'The web service returned an error message:\Status code: %1\Description: %2';
        ErrText003: Label 'Could not find a token with key "%1"';
        ErrText004: Label 'You must enter INN value.';
        ErrText005: Label 'You must enter KPP value.';
        ErrText006: Label 'Entered value does not compile to specified pattern.';
        InnPattern: Label '^\d{10}$';
        KppPattern: Label '^\d{9}$';

    procedure GetCompanyInformation() NewEntryNo: BigInteger
    var
        JsonDataRec: Record "Organization Dadata Info";
        Window: Page "Standard Dialog";
        JsonArr: JsonArray;
        JsonTokenToParse: JsonToken;
        JsonText: Text;
        Inn: Text;
        Kpp: Text;
    begin
        Window.SetDadataRequestVisible(true);
        if not (Window.RunModal() in [Action::LookupOK, Action::OK]) then
            Error('');
        Window.GetDadataRequestInnKppValues(Inn, Kpp);
        JsonText := SendOrgRequest(Inn, Kpp);
        if not JsonArr.ReadFrom(JsonText) then begin
            JsonTokenToParse.ReadFrom(JsonText);
            NewEntryNo := ParseCompanyData(JsonTokenToParse, JsonDataRec);
        end else begin
            foreach JsonTokenToParse in JsonArr do
                NewEntryNo := ParseCompanyData(JsonTokenToParse, JsonDataRec);
        end;
    end;

    local procedure SendOrgRequest(Inn: Text; Kpp: Text) ResponseText: Text
    var
        DadataSetup: Record "Dadata Setup";
        WebClient: HttpClient;
        WebRequest: HttpRequestMessage;
        WebResponse: HttpResponseMessage;
        WebRequestHeaders: HttpHeaders;
        WebContentHeaders: HttpHeaders;
        WebContent: HttpContent;
        Uri: Text;
        BodyText: Text;
        TokenText: Text;
    begin
        DadataSetup.Get();
        DadataSetup.TestField("Organization Data Web Link");
        DadataSetup.TestField("Dadata Token");

        Uri := DadataSetup."Organization Data Web Link";
        TokenText := StrSubstNo('Token %1', DadataSetup."Dadata Token");

        if Kpp <> '' then
            BodyText := StrSubstNo('{"query": "%1", "kpp": "%2"}', Inn, Kpp)
        else
            BodyText := StrSubstNo('{"query": "%1", "branch_type": "MAIN"}', Inn);

        WebRequest.Method := 'POST';
        WebRequest.SetRequestUri(Uri);

        WebRequest.GetHeaders(WebRequestHeaders);
        WebRequestHeaders.Clear();
        WebRequestHeaders.Add('Authorization', TokenText);
        WebRequestHeaders.Add('Accept', 'application/json');

        WebContent.WriteFrom(BodyText);

        WebContent.GetHeaders(WebContentHeaders);
        WebContentHeaders.Clear();
        WebContentHeaders.Add('Content-Type', 'application/json');

        WebRequest.Content := WebContent;

        if WebClient.Send(WebRequest, WebResponse) then begin
            WebResponse.Content().ReadAs(ResponseText);
        end else
            Error(ErrText002, format(WebResponse.HttpStatusCode), format(WebResponse.ReasonPhrase));
    end;

    local procedure ParseCompanyData(JsonTokenToParseP: JsonToken; var JsonDataRecV: Record "Organization Dadata Info") NewEntryNo: BigInteger
    var
        JsonObj: JsonObject;
        SuggestionsJsonObj: JsonObject;
        SuggestionsJsonToken: JsonToken;
        SuggMainJsonToken: JsonToken;
        DataJsonToken: JsonToken;
        SuggestionsJsonArray: JsonArray;
    begin
        JsonObj := JsonTokenToParseP.AsObject();
        JsonObj.Get('suggestions', SuggestionsJsonToken);
        SuggestionsJsonArray := SuggestionsJsonToken.AsArray();
        foreach SuggMainJsonToken in SuggestionsJsonArray do begin
            Clear(JsonDataRecV);
            SuggestionsJsonObj := SuggMainJsonToken.AsObject();
            JsonDataRecV.Name := GetJsonTokenText(SuggestionsJsonObj, 'value');

            SuggestionsJsonObj.Get('data', DataJsonToken);
            ParseGeneralInformation(DataJsonToken, JsonDataRecV);
            ParseAddressInformation(DataJsonToken, JsonDataRecV);
            JsonDataRecV.Insert();
        end;
        NewEntryNo := JsonDataRecV."Entry No.";
    end;

    local procedure ParseGeneralInformation(var DataJsonTokenV: JsonToken; var JsonDataRecV: Record "Organization Dadata Info" temporary)
    var
        DataJsonObj: JsonObject;
        NameJsonObj: JsonObject;
        NameJsonToken: JsonToken;
        OPFJsonObj: JsonObject;
        OPFJsonToken: JsonToken;
    begin
        if DataJsonTokenV.IsObject() then begin
            DataJsonObj := DataJsonTokenV.AsObject();
            JsonDataRecV.Inn := GetJsonTokenText(DataJsonObj, 'inn');
            JsonDataRecV.Kpp := GetJsonTokenText(DataJsonObj, 'kpp');
            JsonDataRecV.OGRN := GetJsonTokenText(DataJsonObj, 'ogrn');
            JsonDataRecV.OKPO := GetJsonTokenText(DataJsonObj, 'okpo');
            JsonDataRecV.OKATO := GetJsonTokenText(DataJsonObj, 'okato');
            JsonDataRecV.OKTMO := GetJsonTokenText(DataJsonObj, 'oktmo');
            JsonDataRecV.OKOGU := GetJsonTokenText(DataJsonObj, 'okogu');
            JsonDataRecV.OKFS := GetJsonTokenText(DataJsonObj, 'okfs');
            JsonDataRecV.OKVED := GetJsonTokenText(DataJsonObj, 'okved');
            JsonDataRecV.Phones := GetJsonTokenText(DataJsonObj, 'phones');
            JsonDataRecV.Emails := GetJsonTokenText(DataJsonObj, 'emails');
            JsonDataRecV."OKVED Type" := GetJsonTokenText(DataJsonObj, 'okved_type');
        end;

        DataJsonTokenV.SelectToken('name', NameJsonToken);
        if NameJsonToken.IsObject() then begin
            NameJsonObj := NameJsonToken.AsObject();
            JsonDataRecV."Full Name" := GetJsonTokenText(NameJsonObj, 'full_with_opf');
        end;
        DataJsonTokenV.SelectToken('opf', OPFJsonToken);
        if OPFJsonToken.IsObject() then begin
            OPFJsonObj := OPFJsonToken.AsObject();
            JsonDataRecV."OPF Full" := GetJsonTokenText(OPFJsonObj, 'full');
            JsonDataRecV."OPF Short" := GetJsonTokenText(OPFJsonObj, 'short');
        end;
    end;

    local procedure ParseAddressInformation(var DataJsonTokenV: JsonToken; var JsonDataRecV: Record "Organization Dadata Info" temporary)
    var
        AddressJsonToken: JsonToken;
        AddressJsonObj: JsonObject;
        DataAddressJsonToken: JsonToken;
        DataAddressJsonObj: JsonObject;
    begin
        DataJsonTokenV.SelectToken('address', AddressJsonToken);
        if AddressJsonToken.IsObject() then begin
            AddressJsonObj := AddressJsonToken.AsObject();
            JsonDataRecV."Full Address" := GetJsonTokenText(AddressJsonObj, 'value');
        end;
        AddressJsonToken.SelectToken('data', DataAddressJsonToken);
        if DataAddressJsonToken.IsObject() then begin
            DataAddressJsonObj := DataAddressJsonToken.AsObject();
            JsonDataRecV."Postal Code" := GetJsonTokenText(DataAddressJsonObj, 'postal_code');
            JsonDataRecV."Country" := GetJsonTokenText(DataAddressJsonObj, 'country');
            JsonDataRecV."Country ISO Code" := GetJsonTokenText(DataAddressJsonObj, 'country_iso_code');
            JsonDataRecV."Federal District" := GetJsonTokenText(DataAddressJsonObj, 'federal_district');
            JsonDataRecV."Regional Kladr ID" := GetJsonTokenText(DataAddressJsonObj, 'region_kladr_id');

            JsonDataRecV."Region With Type" := GetJsonTokenText(DataAddressJsonObj, 'region_with_type');
            JsonDataRecV."Region Type" := GetJsonTokenText(DataAddressJsonObj, 'region_type');
            JsonDataRecV."Region Type Full" := GetJsonTokenText(DataAddressJsonObj, 'region_type_full');
            JsonDataRecV."Region" := GetJsonTokenText(DataAddressJsonObj, 'region');

            JsonDataRecV."Area With Type" := GetJsonTokenText(DataAddressJsonObj, 'area_with_type');
            JsonDataRecV."Area Type Full" := GetJsonTokenText(DataAddressJsonObj, 'area_type_full');
            JsonDataRecV."Area Type" := GetJsonTokenText(DataAddressJsonObj, 'area_type');
            JsonDataRecV."Area" := GetJsonTokenText(DataAddressJsonObj, 'area');

            JsonDataRecV."City With Type" := GetJsonTokenText(DataAddressJsonObj, 'city_with_type');
            JsonDataRecV."City Type" := GetJsonTokenText(DataAddressJsonObj, 'city_type');
            JsonDataRecV."City Type Full" := GetJsonTokenText(DataAddressJsonObj, 'city_type_full');
            JsonDataRecV.City := GetJsonTokenText(DataAddressJsonObj, 'city');

            JsonDataRecV."Settlement With Type" := GetJsonTokenText(DataAddressJsonObj, 'settlement_with_type');
            JsonDataRecV."Settlement Type" := GetJsonTokenText(DataAddressJsonObj, 'settlement_type');
            JsonDataRecV."Settlement Type Full" := GetJsonTokenText(DataAddressJsonObj, 'settlement_type_full');
            JsonDataRecV.Settlement := GetJsonTokenText(DataAddressJsonObj, 'settlement');

            JsonDataRecV."Street With Type" := GetJsonTokenText(DataAddressJsonObj, 'street_with_type');
            JsonDataRecV."Street Type" := GetJsonTokenText(DataAddressJsonObj, 'street_type');
            JsonDataRecV."Street Type Full" := GetJsonTokenText(DataAddressJsonObj, 'street_type_full');
            JsonDataRecV.Street := GetJsonTokenText(DataAddressJsonObj, 'street');

            JsonDataRecV."House Type" := GetJsonTokenText(DataAddressJsonObj, 'house_type');
            JsonDataRecV."House Type Full" := GetJsonTokenText(DataAddressJsonObj, 'house_type_full');
            JsonDataRecV.House := GetJsonTokenText(DataAddressJsonObj, 'house');

            JsonDataRecV."Block Type" := GetJsonTokenText(DataAddressJsonObj, 'block_type');
            JsonDataRecV.Block := GetJsonTokenText(DataAddressJsonObj, 'block');

            JsonDataRecV.Entrance := GetJsonTokenText(DataAddressJsonObj, 'entrance');
            JsonDataRecV.Floor := GetJsonTokenText(DataAddressJsonObj, 'floor');

            JsonDataRecV.Flat := GetJsonTokenText(DataAddressJsonObj, 'flat');
            JsonDataRecV."Flat Type" := GetJsonTokenText(DataAddressJsonObj, 'flat_type');
            JsonDataRecV."Flat Type Full" := GetJsonTokenText(DataAddressJsonObj, 'flat_type_full');

            JsonDataRecV."Postal Box" := GetJsonTokenText(DataAddressJsonObj, 'postal_box');

            JsonDataRecV."OKATO Address" := GetJsonTokenText(DataAddressJsonObj, 'okato');
            JsonDataRecV."OKTMO Address" := GetJsonTokenText(DataAddressJsonObj, 'oktmo');
            JsonDataRecV."Tax Office" := GetJsonTokenText(DataAddressJsonObj, 'tax_office');
            JsonDataRecV."Geo Lat" := GetJsonTokenText(DataAddressJsonObj, 'geo_lat');
            JsonDataRecV."Geo Lon" := GetJsonTokenText(DataAddressJsonObj, 'geo_lon');
        end;
    end;

    local procedure GetJsonTokenText(JsonObject: JsonObject; TokenKey: text) TextValue: Text;
    var
        JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error(ErrText003, TokenKey);
        TextValue := '';
        If not JsonToken.AsValue().IsNull then
            TextValue := JsonToken.AsValue().AsText();
    end;

    procedure CheckInnPattern(InnText: text)
    var
        RegEx: Dotnet RegExp;
    begin
        if InnText = '' then
            Error(ErrText004);
        RegEx := RegEx.Regex(Format(InnPattern));
        if not RegEx.IsMatch(InnText) then
            Error(ErrText006);
    end;

    procedure CheckKppPattern(KppText: text)
    var
        RegEx: Dotnet RegExp;
    begin
        if KppText = '' then
            exit;
        RegEx := RegEx.Regex(Format(KppPattern));
        if not RegEx.IsMatch(KppText) then
            Error(ErrText006);
    end;

}