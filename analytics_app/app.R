library(shiny)
library(tidyverse)
load("fantasyBasketball2023.RData")

ui <- fluidPage(
    titlePanel("Bauer Analytics")
)

server <- function(input, output) {

}

shinyApp(ui, server)