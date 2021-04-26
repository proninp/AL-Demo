codeunit 50010 "Check Input Data Mgt."
{
    var
        ErrText001: Label 'You must enter INN value.';
        ErrText002: Label 'Entered value does not compile to specified pattern.';
        InnPattern: Label '^\d{10}$';
        KppPattern: Label '^\d{9}$';

    procedure CheckInnPattern(InnTextP: text; InnPatternP: Text)
    var
        RegEx: Dotnet RegExp;
    begin
        if InnTextP = '' then
            Error(ErrText001);
        RegEx := RegEx.Regex(Format(InnPatternP));
        if not RegEx.IsMatch(InnTextP) then
            Error(ErrText002);
    end;

    procedure CheckInnPattern(InnTextP: text)
    begin
        CheckInnPattern(InnTextP, InnPattern);
    end;

    procedure CheckKppPattern(KppTextP: text; KppPatternP: Text)
    var
        RegEx: Dotnet RegExp;
    begin
        if KppTextP = '' then
            exit;
        RegEx := RegEx.Regex(Format(KppPatternP));
        if not RegEx.IsMatch(KppTextP) then
            Error(ErrText002);
    end;

    procedure CheckKppPattern(KppTextP: text)
    begin
        CheckKppPattern(KppTextP, KppPattern);
    end;
}