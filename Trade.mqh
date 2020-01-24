enum ENUM_CHECK_RETCODE
{
    CHECK_RETCODE_OK,
    CHECK_RETCODE_ERROR
};



class CTrade
{
    public:
        void Buy(string pSymbol, double pVolume, double pPrice, double pStopLossPrice, int pMagic, ulong pTicket);
        void Sell(string pSymbol, double pVolume, double pPrice, double pStopLossPrice, int pMagic, ulong pTicket);
        void ModifyPositionSLTP(string pSymbol, double pStopLossPrice, double pTakeProfitPrice, ulong pTicket);
        
    private:
        MqlTradeRequest request;
        MqlTradeResult result;
        int CheckReturnCode(uint pRetCode);
};

void CTrade::Buy(string pSymbol, double pVolume, double pPrice, double pStopLossPrice, int pMagic, ulong pTicket)
{
    ZeroMemory(request);
    ZeroMemory(result);
    
    request.action = TRADE_ACTION_DEAL;
    request.type = ORDER_TYPE_BUY;
    request.symbol = pSymbol;
    request.volume = pVolume;
    request.type_filling = ORDER_FILLING_FOK;
    request.price = pPrice;
    request.sl = pStopLossPrice;
    request.magic = pMagic;
    request.position = pTicket;
    
    OrderSend(request, result);
}

void CTrade::Sell(string pSymbol, double pVolume, double pPrice, double pStopLossPrice, int pMagic, ulong pTicket)
{
    ZeroMemory(request);
    ZeroMemory(result);
    
    request.action = TRADE_ACTION_DEAL;
    request.type = ORDER_TYPE_SELL;
    request.symbol = pSymbol;
    request.volume = pVolume;
    request.type_filling = ORDER_FILLING_FOK;
    request.price = pPrice;
    request.sl = pStopLossPrice;
    request.magic = pMagic;
    request.position = pTicket;
    
    OrderSend(request, result);
}

void CTrade::ModifyPositionSLTP(string pSymbol, double pStopLossPrice, double pTakeProfitPrice, ulong pTicket)
{
    ZeroMemory(request);
    ZeroMemory(result);
    
    request.action = TRADE_ACTION_SLTP;
    request.symbol = pSymbol;
    request.sl = pStopLossPrice;
    request.tp = pTakeProfitPrice;
    request.position = pTicket;
    
    OrderSend(request, result);
}