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
library(ggplot2)
library(reticulate)
library(rstudioapi)

# finance packages
library(quantmod)

# configurations
setwd(dir = dirname(path = rstudioapi::getActiveDocumentContext()$path))
getwd()

# setup python
env <- dotenv::load_dot_env()
Sys.getenv(x = 'PYTHON')
reticulate::use_python(python = Sys.getenv(x = 'PYTHON'), required = TRUE)
reticulate::py_run_string(code = "print('hello world')")

# Define server logic
server <- shiny::shinyServer(function(input, output) {

    output$distPlot <- shiny::renderPlot(expr = {

        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        graphics::hist(x, breaks = bins, col = 'darkgray', border = 'white')

    })
    
    output$stocksPlot <- shiny::renderPlot(expr = {
        reticulate::py_run_string(code = "import yfinance")
        
    })

})
