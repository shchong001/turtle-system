double MoneyManagement(double riskPercent, double stopLoss)
{
    double accountEquity = AccountInfoDouble(ACCOUNT_EQUITY);
    double risk = (riskPercent / 100) * accountEquity;
    double stopLossPoint = stopLoss / Point();
    double tickValue = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE);
    double tickSize = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_SIZE);

    return(NormalizeDouble((risk / stopLossPoint) / tickValue, 2));
}