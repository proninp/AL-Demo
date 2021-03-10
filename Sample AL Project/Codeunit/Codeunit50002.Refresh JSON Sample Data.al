/// <summary>
/// Codeunit Refresh JSON Sample Data (ID 50002).
/// </summary>
codeunit 50002 "Refresh JSON Sample Data"
{
    trigger OnRun()
    begin

    end;

    var
        ErrText001: Label 'The call to the web service failed.';
        ErrText002: Label 'The web service returned an error message:\Status code: %1\Description: %2';
        ErrText003: Label 'Could not find a token with key %1';
        ErrText004: Label 'Could not find a token with path %1';
        Text001: Label 'There is no data to show.';

    /// <summary>
    /// RefreshFunction for refrsh JSON Data
    /// </summary>
    procedure RefreshJson();
    var
        JsonData: Record "JSON Sample Data";
        HttpClientL: HttpClient;
        ResponseMessage: HttpResponseMessage;
        JsonTokenL: JsonToken;
        JsonObjectL: JsonObject;
        JsonArrayL: JsonArray;
        JsonText: text;
        WebLink: text;
        i: Integer;
        ListAr: List of [Text];
    begin
        WebLink := StrSubstNo('https://date.nager.at/api/v2/publicholidays/%1/ru', format(Date2DMY(Today(), 3)));
        JsonData.DeleteAll;
        // Simple web service call
        HttpClientL.DefaultRequestHeaders.Add('User-Agent', 'Dynamics 365');
        if not HttpClientL.Get(WebLink, ResponseMessage) then
            Error(ErrText001);

        if not ResponseMessage.IsSuccessStatusCode then
            Error(ErrText002, ResponseMessage.HttpStatusCode, ResponseMessage.ReasonPhrase);

        ResponseMessage.Content.ReadAs(JsonText);

        // Process JSON response
        if not JsonArrayL.ReadFrom(JsonText) then begin
            // probably single object
            JsonTokenL.ReadFrom(JsonText);
            Insert(JsonTokenL);
        end else begin
            // array
            for i := 0 to JsonArrayL.Count - 1 do begin
                JsonArrayL.Get(i, JsonTokenL);
                Insert(JsonTokenL);
            end;
        end;
    end;

    /// <summary>
    /// Insert JSON Data
    /// </summary>
    /// <param name="JsonTokenP">JsonToken.</param>
    procedure Insert(JsonTokenP: JsonToken);
    var
        JsonObjectL: JsonObject;
        JsonValueL: JsonValue;
        JsonDataL: Record "JSON Sample Data";
    begin
        JsonObjectL := JsonTokenP.AsObject;
        Clear(JsonDataL); // To reset autoincrement PK
        JsonDataL."Date" := GetJsonToken(JsonObjectL, 'date').AsValue.AsDate();
        JsonDataL."Local Name" := COPYSTR(GetJsonToken(JsonObjectL, 'localName').AsValue.AsText, 1, MaxStrLen(JsonDataL."Local Name"));
        JsonDataL."Name" := COPYSTR(GetJsonToken(JsonObjectL, 'name').AsValue.AsText, 1, MaxStrLen(JsonDataL.Name));
        JsonDataL."Country Code" := COPYSTR(GetJsonToken(JsonObjectL, 'countryCode').AsValue.AsCode(), 1, MaxStrLen(JsonDataL."Country Code"));
        JsonDataL."Fixed" := GetJsonToken(JsonObjectL, 'fixed').AsValue.AsBoolean();
        JsonDataL."Global" := GetJsonToken(JsonObjectL, 'global').AsValue.AsBoolean();
        if not (GetJsonToken(JsonObjectL, 'launchYear').AsValue.IsNull) then
            JsonDataL."Launch Year" := GetJsonToken(JsonObjectL, 'launchYear').AsValue.AsInteger();
        JsonDataL."Type" := COPYSTR(GetJsonToken(JsonObjectL, 'type').AsValue.AsText, 1, MaxStrLen(JsonDataL.Type));
        JsonDataL.Insert;
    end;

    /// <summary>
    /// GetJsonToken function to get JSON token or to give an error if there is no data for that
    /// </summary>
    /// <param name="JsonObject">JsonObject</param>
    /// <param name="TokenKey">text</param>
    /// <returns>Return variable JsonToken of type JsonToken.</returns>
    local procedure GetJsonToken(JsonObject: JsonObject; TokenKey: text) JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error(ErrText003, TokenKey);
    end;

    /// <summary>
    /// SelectJsonToken.
    /// </summary>
    /// <param name="JsonObject">JsonObject.</param>
    /// <param name="Path">text.</param>
    /// <returns>Return variable JsonToken of type JsonToken.</returns>
    local procedure SelectJsonToken(JsonObject: JsonObject; Path: text) JsonToken: JsonToken;
    begin
        if not JsonObject.SelectToken(Path, JsonToken) then
            Error(ErrText004, Path);
    end;

    /// <summary>
    /// WorkWithListsSample function represents how to work with List data type
    /// </summary>
    procedure WorkWithListsSample()
    var
        JsonObjectL: Record "JSON Sample Data";
        ListText: List of [Text];
        LocalNames: Text;
        i: Integer;
    begin
        if not JsonObjectL.FindSet() then begin
            Message(Text001);
            exit;
        end;
        repeat
            ListText.Add(JsonObjectL."Local Name");
        until JsonObjectL.Next() = 0;
        for i := 1 to ListText.Count do begin
            if LocalNames <> '' then
                LocalNames += '\';
            LocalNames += ListText.Get(i);
        end;
        Message(LocalNames);
    end;
}
