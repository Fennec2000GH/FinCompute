#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyWidgets)

# Define UI for application that draws a histogram
ui <- shiny::shinyUI(ui = shiny::bootstrapPage(
    # shiny::includeCSS(path = "app.css"),
    shiny::titlePanel(title = "FinCompute", windowTitle = "FinCompute (Running...)"),
    
    shiny::tabsetPanel(
      shiny::tabPanel(title = "Stock Market", 
        shiny::inputPanel(
          shiny::textInput(inputId = "stocksSearch", label = "Symbol/Name", value = "SPY"),
          shiny::selectInput(inputId = "stocksPeriod", label = "Period", choices = c("1w", "1m", "1yr", "5yr"), selected = "1yr")
        ),

        shiny::mainPanel(
          plotly::plotlyOutput(outputId = "stocksPlot"),
          shiny::titlePanel(title = "Analysis"),
          shiny::dataTableOutput(outputId = "stocksAnalysis"),
          shiny::titlePanel(title = "Quick History"),
          shiny::tableOutput(outputId = "stocksHistory"),
          shiny::titlePanel(title = "Detailed History"),
          shiny::dataTableOutput(outputId = "stocksTimeSeries"),
          # shiny::tableOutput(outputId = "stocksInfo")
          shiny::titlePanel(title = "Balance Sheet"),
          shiny::tableOutput(outputId = "stocksBalanceSheet")
        )
      ),
      
      shiny::tabPanel(title = "Goals",
            # shiny::checkboxGroupInput(
            #   inputId = "goals",
            #   label = "List of 2022 Financial Goals",
            #   choiceNames = c(),
            #   choiceValues = c()
            #   ),
            shiny::titlePanel(title = "Enter financial goals for 2022:"),
            shiny::sidebarLayout(
              shiny::sidebarPanel(width = 1,
                shinyWidgets::switchInput(inputId = "c1", label = "1", labelWidth = "80px"),
                shinyWidgets::switchInput(inputId = "c2", label = "2", labelWidth = "80px"),
                shinyWidgets::switchInput(inputId = "c3", label = "3", labelWidth = "80px"),
                shinyWidgets::switchInput(inputId = "c4", label = "4", labelWidth = "80px"),
                shinyWidgets::switchInput(inputId = "c5", label = "5", labelWidth = "80px"),
                shinyWidgets::switchInput(inputId = "c6", label = "6", labelWidth = "80px"),
                shinyWidgets::switchInput(inputId = "c7", label = "7", labelWidth = "80px"),
                shinyWidgets::switchInput(inputId = "c8", label = "8", labelWidth = "80px"),
                shinyWidgets::switchInput(inputId = "c9", label = "9", labelWidth = "80px"),
                shinyWidgets::switchInput(inputId = "c10", label = "10", labelWidth = "80px")
              ),
              shiny::mainPanel(width = 11,
                shiny::textInput(inputId = "c1Label", label = "", placeholder = "Goal #1"),
                shiny::textInput(inputId = "c2Label", label = "", placeholder = "Goal #2"),
                shiny::textInput(inputId = "c3Label", label = "", placeholder = "Goal #3"),
                shiny::textInput(inputId = "c4Label", label = "", placeholder = "Goal #4"),
                shiny::textInput(inputId = "c5Label", label = "", placeholder = "Goal #5"),
                shiny::textInput(inputId = "c6Label", label = "", placeholder = "Goal #6"),
                shiny::textInput(inputId = "c7Label", label = "", placeholder = "Goal #7"),
                shiny::textInput(inputId = "c8Label", label = "", placeholder = "Goal #8"),
                shiny::textInput(inputId = "c9Label", label = "", placeholder = "Goal #9"),
                shiny::textInput(inputId = "c10Label", label = "", placeholder = "Goal #10")
              )
            )
            # shiny::textInput(
            #   inputId = "goalInput", 
            #   label = "Enter a financial goal here:",
            #   placeholder = "For example, get a mortgage..."
            # ),
            # shiny::actionButton(inputId = "goalsButton", label = "Add Goal")
            # shiny::incProgress()
      ),
      
      shiny::tabPanel(title = "Financial Sentiment Analysis",
        shiny::fileInput(
          inputId = "uploadFile",
          label = "Upload any financial newsletter, report, or discussion:",
          buttonLabel = "Upload File",
          multiple = FALSE,
          accept = c("text/*", "application/pdf")
        ),
        
        shiny::dataTableOutput(outputId = "sentiment"),
        shiny::textOutput(outputId = "content")
      )
    )
))
