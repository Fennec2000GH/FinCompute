#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# primary packages
library(shiny)
library(dotenv)
library(dplyr)
library(ggplot2)
library(pdftools)
library(plotly)
library(readr)
library(reticulate)
library(rstudioapi)
library(zoo)

# finance packages
# library(quantmod)


# configurations
# setwd(dir = dirname(path = rstudioapi::getActiveDocumentContext()$path))
getwd()
stocks.path <- file.path(getwd(), "src", "modules", "stocks.py")
draw.path <- file.path(getwd(), "src", "modules", "draw.py")
sentiment.path <- file.path(getwd(), "src", "modules",  "sentiment_analysis.py")

# setup python
env <- dotenv::load_dot_env(file = '.env')
Sys.getenv(x = 'PYTHON')
reticulate::use_python(python = Sys.getenv(x = 'PYTHON'), required = TRUE)
reticulate::py_run_string(code = "import os; os.system('which python3.9')")
reticulate::source_python(file = stocks.path)
reticulate::source_python(file = draw.path)
reticulate::source_python(file = sentiment.path)

# stock <- FetchStock(ticker = "TSLA")
# print(stock$analysis)

# helper function to convert selected period to days
periodToDays <- function(period) {
  num <- as.numeric(x = unlist(x = stringr::str_split(string = period, pattern = "[^\\d]"))[1])
  if (endsWith(x = period, suffix = "d")) {
    num
  } else if (endsWith(x = period, suffix = "w")) {
    num * 7
  } else if (endsWith(x = period, suffix = "m")) {
    num * 30
  } else {
    num * 365
  }
}
  
# Define server logic
server <- function(input, output, session) {
    output$stocksPlot <- plotly::renderPlotly(expr = {
      message("output$stocksPlot")
      # fig <- CandleStick(
      #   ticker=input$stocksSearch,
      #   period=input$stocksPeriod
      # )
      # message(typeof(x = fig))
      # GetHTMLCanvas(fig = fig)
      # shiny::includeHTML(path = file.path("src", "data", "graph.html"))
      # fig  
      
      stock.name <- input$stocksSearch
      quantmod::getSymbols(Symbols = "TSLA", src = "yahoo")
      df <- data.frame(
        Date = zoo::index(x = TSLA),
        zoo::coredata(x = TSLA)
      )
      df <- tail(x = df, n = periodToDays(period = input$stocksPeriod))
      fig <- df %>% plotly::plot_ly(x = ~Date, type="candlestick",
                                    open = ~TSLA.Open,
                                    close = ~TSLA.Close,
                                    high = ~TSLA.High,
                                    low = ~TSLA.Low
                                  )
      fig <- fig %>% plotly::layout(title = "Candlestick Chart")
      fig
    })
  
    output$stocksAnalysis <- shiny::renderDataTable(expr = {
      message("output$stocksAnalysis")
      stock <- FetchStock(ticker = input$stocksSearch)
      stock$analysis
    })

    output$stocksTimeSeries <- shiny::renderDataTable(expr = {
      message("output$stocksTimeSeries")
      FetchIndexFund(index=input$stocksSearch) 
    })
  
    output$stocksHistory <- shiny::renderTable(expr = {
      message("output$stocksHistory")
      message("stock.history")
      stock.history <- FetchStockHistory(
        ticker=input$stocksSearch, 
        period=input$stocksPeriod
      )
      
      message(typeof(x = stock.history))
      stock.history
    })
    
    output$stocksInfo <- shiny::renderTable(expr = {
      message("output$stocksInfo")
      stock.info <- FetchStockInfo(ticker=input$stocksSearch)
      unlist(x = stock.info)
    })
    
    output$stocksBalanceSheet <- shiny::renderTable(expr = {
      message("output$stocksIBalanceSheet")
      stock <- FetchStock(ticker=input$stocksSearch)
      message(typeof(x = stock$balance_sheet))
      unlist(x = stock$balance_sheet)
    })
    
    output$sentiment <- shiny::renderDataTable(expr = {
      files <- input$uploadFile
      
      if (is.null(x = files)) {
        return (NULL)
      }
      
      # readChar(con = files$datapath, file.info(files$datapath)$size)
      message(files$type)
      files <- files %>% mutate(
        content = (function() {
            content <- ifelse(
              test = startsWith(x = type,  prefix="text/"),
              yes = readr::read_file(file = datapath),
              no = pdftools::pdf_text(pdf = datapath)
            )
            message(content)
            sentiment.obj <- analyze_sentiment(text = content)
            toString(x = sentiment.obj)
          })()
        )
       
      files
    })
    
    output$content <- shiny::renderText(expr = {
      files <- input$uploadFile
      
      if (is.null(x = files)) {
        return (NULL)
      }
      
      ifelse(
        test = startsWith(x = files$type,  prefix="text/"),
        yes = readr::read_file(file = files$datapath),
        no = pdftools::pdf_text(pdf = files$datapath)
      )
    })
}


