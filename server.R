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
# print(stock$cashflow)   
# 
# FetchIndexFund(index="BBY")


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
      
      stock.index <- FetchIndexFund(index=input$stocksSearch) 
      plotly::plot_ly(
        data = stock.index,
        x = rownames(x = stock.index),
        y = stock.index[, c("High")],
        type = "scatter"
      )
    })
  
    output$stocksHistory <- shiny::renderTable(expr = {
      message("output$stocksHistory")
      message("stock.history")
      stock.history <- as.data.frame(x = FetchStockHistory(
        ticker=input$stocksSearch, 
        period=input$stocksPeriod
      ))
      
      message(typeof(x = stock.history))
      stock.history
    })
    
    output$stocksInfo <- shiny::renderTable(expr = {
      message("output$stocksInfo")
      stock.info <- FetchStockInfo(ticker=input$stocksSearch)
      unlist(x = stock.info)
    })
    
    output$sentiment <- shiny::renderDataTable(expr = {
      files <- input$uploadFile
      
      if (is.null(x = files)) {
        return (NULL)
      }
      
      # readChar(con = files$datapath, file.info(files$datapath)$size)
      message(files$type)
      files <- files %>% mutate(sentiment =
          # {
          ifelse(
            test = startsWith(x = type,  prefix="text/"),
            yes = readr::read_file(file = datapath),
            no = pdftools::pdf_text(pdf = datapath)
          )
          # message(content)
          # content
          # }
        )
       
      files
    })
}


