import yfinance as yf
from yfinance import ticker

def FetchStockHistory(ticker: str, period: str = "1yr"):
    obj = yf.Ticker(ticker)
    return obj.history(period)

def FetchStockInfo(ticker: str):
    obj = yf.Ticker(ticker)
    return obj.info

def FetchStock(ticker):
    obj = yf.Ticker(ticker)
    return obj

def FetchIndexFund(index: str):
    return yf.download(index, group_by = 'ticker')
