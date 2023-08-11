library(shiny)
library(tidyverse)
library(rvest)
library(RColorBrewer)
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
                            plotOutput("comparison_plot"),
                            dataTableOutput("comparison_table")
                        )
                    )
                ),
               fluid = TRUE
)

server <- function(input, output) {
    comparison_values <- reactiveValues()
    comparison_values$df <- data.frame()

    observe({
        selected_players <- input$player_search

        if (!is.null(selected_players) && length(selected_players) > 0) {

            comparison_values$df <- data.frame()

            for (new_player in selected_players) {

                print(new_player)
                new_id <- subset(nba_players, name == new_player, select = id_code)

                if (length(new_id) > 0) {

                    print(new_id)
                    first_letter <- new_id[1]
                    game_log_url <- sprintf("https://www.basketball-reference.com/players/%s/%s/gamelog/2023", first_letter, new_id)
                    isolate({

                        tables <- game_log_url %>%
                            read_html() %>%
                            html_nodes("table")
                        new_table <- html_table(tables[[length(tables)]], header = TRUE) %>%
                            select(Rk, TRB, AST, STL, BLK, TOV, PTS) %>%
                            mutate(Player = new_player) %>%
                            filter(Rk != "Rk") %>%
                            select(Rk, TRB, AST, STL, BLK, TOV, PTS, Player) %>%
                            mutate(TRB = as.integer(TRB), AST = as.integer(AST),
                                   STL = as.integer(STL), BLK = as.integer(BLK),
                                   TOV = as.integer(TOV), PTS = as.integer(PTS)) %>%
                            rename(Game = 'Rk') %>%
                            mutate(FAN_PTS = PTS + (3 * BLK) + (3 * STL) - TOV + (1.2 * AST) + (1.5 * TRB)) %>%
                            select(Player, Game, FAN_PTS)

                        comparison_values$df <- bind_rows(comparison_values$df, new_table)
                        comparison_plot_table <- comparison_values$df %>% replace(is.na(.), 0) %>%
                            mutate(Game = as.integer(Game))
                        wide_comparison_table <- comparison_values$df %>%
                            pivot_wider(names_from = "Game", values_from = "FAN_PTS")

            output$comparison_plot <- renderPlot(
                ggplot(data = comparison_plot_table) +
                    geom_line(mapping = aes(x = Game, y = FAN_PTS, color = Player)) +
                    scale_fill_brewer(palette = "Spectral") +
                    labs(title = "Fantasy Points for each Game") +
                    ylab("Fantasy Points") +
                    xlab("Game Number")
            )
            output$comparison_table <- renderDataTable(wide_comparison_table)
                    })
                }
            }
        }
    })
}

shinyApp(ui, server)