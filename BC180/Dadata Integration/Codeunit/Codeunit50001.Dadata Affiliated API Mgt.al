codeunit 50001 "Dadata Affiliated API Mgt."
{
    var
        ErrText001: Label 'The web service returned an error message:\Status code: %1\Description: %2';

    procedure GetAffiliatedCompanies()
    var
        JsonDataRec: Record "Dadata Affiliated Company";
        Window: Page "Standard Dialog";
        JsonArr: JsonArray;
        JsonTokenToParse: JsonToken;
        JsonText: Text;
        Inn: Text;
        Kpp: Text;
    begin
        Window.SetDadataRequestVisible(true, false);
        if not (Window.RunModal() in [Action::LookupOK, Action::OK]) then
            Error('');
        Window.GetDadataRequestInnKppValues(Inn, Kpp);
        JsonText := SendACRequest(Inn);
        if not JsonArr.ReadFrom(JsonText) then begin
            JsonTokenToParse.ReadFrom(JsonText);
            ParseAffiliatedCompanyData(JsonTokenToParse, JsonDataRec);
        end else begin
            foreach JsonTokenToParse in JsonArr do
                ParseAffiliatedCompanyData(JsonTokenToParse, JsonDataRec);
        end;
    end;

    local procedure SendACRequest(Inn: Text) ResponseText: Text
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
        DadataSetup.TestField("Affiliated Companies Web Link");
        DadataSetup.TestField("Dadata Token");

        Uri := DadataSetup."Affiliated Companies Web Link";
        TokenText := StrSubstNo('Token %1', DadataSetup."Dadata Token");

        BodyText := StrSubstNo('{"query": "%1", "scope": ["FOUNDERS"]}', Inn);

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
            Error(ErrText001, format(WebResponse.HttpStatusCode), format(WebResponse.ReasonPhrase));
    end;

    local procedure ParseAffiliatedCompanyData(JsonTokenToParseP: JsonToken; var JsonDataRecV: Record "Dadata Affiliated Company")
    begin
        exit;
    end;
}