options(repos=structure(c(CRAN="https://mirror.rcg.sfu.ca/mirror/CRAN/")))
library(shiny)
source(file = 'ui.R')
source(file = 'server.R')

shiny::shinyApp(ui = ui, server = server)