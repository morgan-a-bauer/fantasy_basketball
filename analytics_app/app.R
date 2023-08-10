library(shiny)
library(tidyverse)
library(rvest)
load("fantasyBasketball2023.RData")

ui <- navbarPage("Bauer Analytics",
               tabPanel("Home"),
               tabPanel("Player Comparison",
                    sidebarLayout(
                        sidebarPanel(
                            fluidRow(
                                selectizeInput(
                                    inputId = "player_search",
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
                            plotOutput(outputId = "comparison_plot")
                        )
                    )
                ),
               fluid = TRUE
)

server <- function(input, output) {
    comparison_values <- reactiveValues()
    comparison_values$df <- data.frame()
    observe({
        new_player <- input$player_search

        if (!is.null(new_player) && new_player != "") {

            print(new_player)
            new_id <- subset(nba_players, name == new_player, select = id_code)

            if (length(new_id) > 0) {

            print(new_id)
            first_letter <- new_id[1]
            game_log_url <- sprintf("https://www.basketball-reference.com/players/%s/%s/gamelog/2023", first_letter, new_id)
            tables <- game_log_url %>%
                read_html() %>%
                html_nodes("table")
            new_table <- html_table(tables[[1]], header = TRUE)
            comparison_values$df <- bind_rows(comparison_values$df, new_table)
            print(new_table)
            }
        }
    })
}

shinyApp(ui, server)