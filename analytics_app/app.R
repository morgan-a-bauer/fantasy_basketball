library(shiny)
library(tidyverse)
load("fantasyBasketball2023.RData")

ui <- navbarPage("Bauer Analytics",
               tabPanel("Home"),
               tabPanel("Player Comparison",
                    sidebarLayout(
                        sidebarPanel(
                            fluidRow(
                                selectizeInput(
                                    inputId = "searchme",
                                    label = "Select Players to Compare",
                                    multiple = TRUE,
                                    choices = nba_players$name,
                                    options = list(
                                        create = FALSE,
                                        placeholder = "Enter Player Name",
                                        maxItems = '10',
                                        onDropdownOpen = I("function (str) {if (!this.lastQuery.length) {this.close(); this.settings.openOnFocus = false;}}"),
                                        onType = I('function (str) {if (str === \"\") {this.close();}}')
                                    )
                                )
                            )
                        ),
                        mainPanel(

                        )
                    )
                ),
               fluid = TRUE
)

server <- function(input, output) {
    observe({
        print(input$searchme)
    })
}

shinyApp(ui, server)