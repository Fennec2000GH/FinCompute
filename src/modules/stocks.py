import yfinance as yf

def fetch_stocks_history(ticker: str, period='max'):
    obj = yf.Ticker(ticker)
    return obj.history(period)

def fetch_stocks_info(ticker: str):
    obj = yf.Ticker(ticker)
    return obj.info