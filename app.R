# install.packages("shiny")
library(shiny)
source(file = 'ui.R')
source(file = 'server.R')


shiny::shinyApp(ui = ui, server = server)

