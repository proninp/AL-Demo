codeunit 50300 "Telegram Management"
{
    trigger OnRun()
    begin

    end;

    var
        RequestLine: Text;
        ChatId: BigInteger;
        BotToken: Text;
        Text001: label 'Produced shipment for amount %1 to customer %2.';
        Text002: label 'You were successfully subscrined';
        Text003: label 'You are already subscribed';
}