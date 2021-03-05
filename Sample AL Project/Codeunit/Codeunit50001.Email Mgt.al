/// <summary>
/// Codeunit E-mail Mgt. (ID 50001).
/// </summary>
codeunit 50001 "E-mail Mgt."
{
    trigger OnRun()
    begin

    end;

    var
        EmailPattern: Label '^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$';


    /// <summary>
    /// IsEmailCorrect.
    /// </summary>
    /// <param name="Input">Text.</param>
    /// <param name="Pattern">Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure IsEmailCorrect(Input: Text; Pattern: Text): Boolean
    var
        RegEx: Dotnet RegExp;
    begin
        if Pattern = '' then
            Pattern := EmailPattern;
        RegEx := RegEx.Regex(Pattern);
        Exit(RegEx.IsMatch(Input));
    end;
}