class CTurtleSystemOne
{
    public:
        double GetWeeksHigh(int weeksRange);
        double GetWeeksLow(int weeksRange);
        double CalcAverageTrueRange(int weeksRange);
        
    private:
        void CalcTrueRange(MqlRates &rates[], double &maxTrueRange[]);
};

double CTurtleSystemOne::GetWeeksHigh(int weeksRange)
{
    int daysRange = weeksRange * 5;
    int weeksHighIndex = iHighest(NULL, PERIOD_D1, MODE_HIGH, daysRange, 1);
    
    return(iHigh(NULL, PERIOD_D1, weeksHighIndex));
}

double CTurtleSystemOne::GetWeeksLow(int weeksRange)
{
    int daysRange = weeksRange * 5;
    int weeksLowIndex = iLowest(NULL, PERIOD_D1, MODE_LOW, daysRange, 1);
    
    return(iLow(NULL, PERIOD_D1, weeksLowIndex));
}

double CTurtleSystemOne::CalcAverageTrueRange(int weeksRange)
{
    MqlRates dailyRates[]; // Resize?
    int daysRange = weeksRange * 5;
    ArrayResize(dailyRates, daysRange);
    int barsCopied = CopyRates(Symbol(), PERIOD_D1, 1, daysRange + 1, dailyRates);
    if(barsCopied <= 0) Print("Error");
    
    double maximumTrueRange[];
    ArrayResize(maximumTrueRange, daysRange);
    CalcTrueRange(dailyRates, maximumTrueRange);
    
    double maximumTrueRangeTotal = 0;
    for(int i = 0; i < daysRange; i++)
    {
        maximumTrueRangeTotal += maximumTrueRange[i];
    }
    
    return(maximumTrueRangeTotal / daysRange);
}

void CTurtleSystemOne::CalcTrueRange(MqlRates &rates[], double &maxTrueRange[])
{
    int arraySize = ArraySize(maxTrueRange);
    double trueRange[][3];
    ArrayResize(trueRange, arraySize);
    for(int i = 0; i < arraySize; i++)
    {
        trueRange[i][0] = rates[i + 1].high - rates[i + 1].low;
        trueRange[i][1] = MathAbs(rates[i].close - rates[i + 1].high);
        trueRange[i][2] = MathAbs(rates[i].close - rates[i + 1].low);
        
        maxTrueRange[i] = MathMax(trueRange[i][0], MathMax(trueRange[i][1], trueRange[i][2]));
    }
}