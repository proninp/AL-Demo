enum 50100 "Supply Header Status"
{
    Extensible = true;
    value(0; "Open") { Caption = 'Open'; }
    value(1; "Close") { Caption = 'Close'; }
}
enum 50101 "Supply Line Status"
{
    Extensible = true;
    value(0; "Registration") { Caption = 'Registration'; }
    value(1; "Verification") { Caption = 'Verification'; }
    value(2; "Funding") { Caption = 'Funding'; }
    value(3; "Payment") { Caption = 'Payment'; }
    value(4; "Commission accrual") { Caption = 'Commission accrual'; }
    value(5; "Comission repayment") { Caption = 'Comission repayment'; }
    value(6; "Closing") { Caption = 'Closing'; }
}