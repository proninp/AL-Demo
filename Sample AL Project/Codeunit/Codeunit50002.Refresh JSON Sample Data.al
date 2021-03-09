/// <summary>
/// Codeunit Refresh JSON Sample Data (ID 50002).
/// </summary>
codeunit 50002 "Refresh JSON Sample Data"
{
    /// <summary>
    /// RefreshFunction for refrsh JSON Data
    /// </summary>
    procedure RefreshJson();
    var
        JsonData: Record "JSON Sample Data";
        HttpClient: HttpClient;
        ResponseMessage: HttpResponseMessage;
        JsonToken: JsonToken;
        JsonValue: JsonValue;
        JsonObject: JsonObject;
        JsonArray: JsonArray;
        JsonText: text;
        i: Integer;
    begin
        JsonData.DeleteAll;

        // Simple web service call
        HttpClient.DefaultRequestHeaders.Add('User-Agent', 'Dynamics 365');
        if not HttpClient.Get('https://bespredel.name/iGetMyJson.php', ResponseMessage) then
            Error('The call to the web service failed.');

        if not ResponseMessage.IsSuccessStatusCode then
            error('The web service returned an error message:\' +
                  'Status code: %1' +
                  'Description: %2',
                  ResponseMessage.HttpStatusCode,
                  ResponseMessage.ReasonPhrase);

        ResponseMessage.Content.ReadAs(JsonText);

        // Process JSON response
        if not JsonArray.ReadFrom(JsonText) then begin
            // probably single object
            JsonToken.ReadFrom(JsonText);
            Insert(JsonToken);
        end else begin
            // array
            for i := 0 to JsonArray.Count - 1 do begin
                JsonArray.Get(i, JsonToken);
                Insert(JsonToken);
            end;
        end;
    end;

    /// <summary>
    /// Insert JSON Data
    /// </summary>
    /// <param name="JsonToken">JsonToken.</param>
    procedure Insert(JsonToken: JsonToken);
    var
        JsonObject: JsonObject;
        JsonData: Record "JSON Sample Data";
    begin
        JsonObject := JsonToken.AsObject;

        JsonData.init;

        JsonData."Sample Text" := COPYSTR(GetJsonToken(JsonObject, 'string').AsValue.AsText, 1, 250);
        JsonData."Sample Integer" := GetJsonToken(JsonObject, 'integer').AsValue.AsInteger;
        JsonData."Sample Decimal" := COPYSTR(GetJsonToken(JsonObject, 'decimal').AsValue.AsText, 1, 250);

        JsonData.Insert;
    end;

    /// <summary>
    /// GetJsonToken.
    /// </summary>
    /// <param name="JsonObject">JsonObject.</param>
    /// <param name="TokenKey">text.</param>
    /// <returns>Return variable JsonToken of type JsonToken.</returns>
    procedure GetJsonToken(JsonObject: JsonObject; TokenKey: text) JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error('Could not find a token with key %1', TokenKey);
    end;

    /// <summary>
    /// SelectJsonToken.
    /// </summary>
    /// <param name="JsonObject">JsonObject.</param>
    /// <param name="Path">text.</param>
    /// <returns>Return variable JsonToken of type JsonToken.</returns>
    procedure SelectJsonToken(JsonObject: JsonObject; Path: text) JsonToken: JsonToken;
    begin
        if not JsonObject.SelectToken(Path, JsonToken) then
            Error('Could not find a token with path %1', Path);
    end;

}
