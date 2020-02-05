#define EA_MAGIC 1000

#include <TurtleSystemOne.mqh>
#include <Trade.mqh>
#include <MoneyManagement.mqh>

CTurtleSystemOne SystemOne;
CTrade Trade;

string symbol = Symbol();
int symbolDigits = Digits();

void OnTick()
{
    MqlTick lastTick;
    if(!SymbolInfoTick(symbol, lastTick)) Print("Error ...");
    
    int positionsTotal = PositionsTotal();
    int eaPositionsTotal = 0;
    for(int i = 0; i < positionsTotal; i++)
    {
        PositionGetSymbol(i);
        if(PositionGetInteger(POSITION_MAGIC) == EA_MAGIC) eaPositionsTotal++;
    }
    
    double averageTrueRange = 0;
    double stopLossPrice = 0;
    static double nextPyramidingPrice = 0;
    
    if(eaPositionsTotal == 0)
    {
        double fourWeeksHigh = SystemOne.GetWeeksHigh(4);
        double fourWeeksLow = SystemOne.GetWeeksLow(4);
        
        if(lastTick.ask >= fourWeeksHigh)
        {
            averageTrueRange = SystemOne.CalcAverageTrueRange(4);
            stopLossPrice = lastTick.ask - NormalizeDouble(averageTrueRange * 2, symbolDigits);
            nextPyramidingPrice = lastTick.ask + NormalizeDouble(averageTrueRange, symbolDigits);
            
            double tradeVolume = MoneyManagement(2, averageTrueRange * 2);
            
            Trade.Buy(symbol, tradeVolume, lastTick.ask, stopLossPrice, EA_MAGIC, 0);
        }
        else if(lastTick.bid <= fourWeeksLow)
        {
            averageTrueRange = SystemOne.CalcAverageTrueRange(4);
            stopLossPrice = lastTick.bid + NormalizeDouble(averageTrueRange * 2, symbolDigits);
            nextPyramidingPrice = lastTick.bid - NormalizeDouble(averageTrueRange, symbolDigits);
            
            double tradeVolume = MoneyManagement(2, averageTrueRange * 2);
            
            Trade.Sell(symbol, tradeVolume, lastTick.bid, stopLossPrice, EA_MAGIC, 0);
        }
    }
    else
    {
        ENUM_POSITION_TYPE positionsType;
        for(int i = 0; i < positionsTotal; i++)
        {
            PositionGetSymbol(i);
            if(PositionGetInteger(POSITION_MAGIC) == EA_MAGIC) positionsType = PositionGetInteger(POSITION_TYPE);
        }
        
        if(positionsType == 0)
        {
            double twoWeeksLow = SystemOne.GetWeeksLow(2);
            if(lastTick.bid <= twoWeeksLow)
            {
                for(int i = 0; i < positionsTotal; i++)
                {
                    ulong positionTicket = PositionGetTicket(i);
                    if(PositionGetInteger(POSITION_MAGIC) == EA_MAGIC)
                    {
                        double positionVolume = PositionGetDouble(POSITION_VOLUME);
                        Trade.Sell(symbol, positionVolume, lastTick.bid, 0, EA_MAGIC, positionTicket);
                    }
                }
            }
            else if(lastTick.ask >= nextPyramidingPrice && eaPositionsTotal < 5)
            {
                averageTrueRange = SystemOne.CalcAverageTrueRange(4);
                stopLossPrice = lastTick.ask - NormalizeDouble(averageTrueRange * 2, symbolDigits);
                nextPyramidingPrice = lastTick.ask + NormalizeDouble(averageTrueRange, symbolDigits);
                
                for(int i = 0; i < positionsTotal; i++)
                {
                    // Modify the stop loss prices of all positions
                    ulong positionTicket = PositionGetTicket(i);
                    if(PositionGetInteger(POSITION_MAGIC) == EA_MAGIC)
                    {
                        Trade.ModifyPositionSLTP(symbol, stopLossPrice, 0, positionTicket);
                    }
                }
                
                double tradeVolume = MoneyManagement(2, averageTrueRange * 2);
                Trade.Buy(symbol, tradeVolume, lastTick.ask, stopLossPrice, EA_MAGIC, 0);
            }
        }
        else if(positionsType == 1)
        {
            double twoWeeksHigh = SystemOne.GetWeeksHigh(2);
            if(lastTick.ask >= twoWeeksHigh)
            {
                for(int i = 0; i < positionsTotal; i++)
                {
                    ulong positionTicket = PositionGetTicket(i);
                    if(PositionGetInteger(POSITION_MAGIC) == EA_MAGIC)
                    {
                        double positionVolume = PositionGetDouble(POSITION_VOLUME);
                        Trade.Buy(symbol, positionVolume, lastTick.ask, 0, EA_MAGIC, positionTicket);
                    }
                }
            }
            else if(lastTick.bid <= nextPyramidingPrice && eaPositionsTotal < 5)
            {
                averageTrueRange = SystemOne.CalcAverageTrueRange(4);
                stopLossPrice = lastTick.bid + NormalizeDouble(averageTrueRange * 2, symbolDigits);
                nextPyramidingPrice = lastTick.bid - NormalizeDouble(averageTrueRange, symbolDigits);
                
                for(int i = 0; i < positionsTotal; i++)
                {
                    // Modify the stop loss prices of all positions
                    ulong positionTicket = PositionGetTicket(i);
                    if(PositionGetInteger(POSITION_MAGIC) == EA_MAGIC)
                    {
                        Trade.ModifyPositionSLTP(symbol, stopLossPrice, 0, positionTicket);
                    }
                }
                
                double tradeVolume = MoneyManagement(2, averageTrueRange * 2);
                Trade.Sell(symbol, tradeVolume, lastTick.bid, stopLossPrice, EA_MAGIC, 0);
            }
        }        
    }
}