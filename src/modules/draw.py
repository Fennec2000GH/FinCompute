import pandas as pd
from pandas_datareader import data as web
import plotly.graph_objects as go
from plotly.subplots import make_subplots
import plotly.express as px

import stocks

def LineStocks(ticker: str, volume = False, period='1y'):
    stock = stocks.FetchStockHistory(ticker, period)
    fig = make_subplots(specs=[[{"secondary_y": True}]])
    fig.add_trace(go.Scatter(x=stock.index,y=stock['Close'],name='Price'),secondary_y=False)
    if volume:
        fig.add_trace(go.Bar(x=stock.index,y=stock['Volume'],name='Volume'),secondary_y=True)
        fig.update_yaxes(range=[0,7000000000],secondary_y=True)
        fig.update_yaxes(visible=False, secondary_y=True)
    return fig
    
def LineMultipleStocks(tickerList: str):
    fig = make_subplots(specs=[[{"secondary_y": True}]])
    for ticker in tickerList.split(" "):
        stock = stocks.FetchStockHistory(ticker)
        fig.add_trace(go.Scatter(x=stock.index,y=stock['Close'],name=ticker),secondary_y=False)
    return fig

def CandleStick(ticker: str):
    stock = stocks.FetchStockHistory(ticker, period='5y')
    fig = make_subplots(specs=[[{"secondary_y": True}]])
    fig.add_trace(go.Candlestick(x=stock.index,
                              open=stock['Open'],
                              high=stock['High'],
                              low=stock['Low'],
                              close=stock['Close'],
                             ))
    fig.add_trace(go.Bar(x=stock.index, y=stock['Volume'], name='Volume'),secondary_y=True)
    fig.update_layout(xaxis_rangeslider_visible=False)
    return fig

def GetHTMLCanvas(fig, path=r'data\graph.html'):   
    fig.write_html(path)