library(shiny)
library(tidyverse)
library(rvest)
library(RColorBrewer)
library(shinydashboard)
load("fantasyBasketball2023.RData")

ui <- dashboardPage(skin = "purple",
    dashboardHeader(title = "The Common Denominator", titleWidth = 400), # Set the header

    dashboardSidebar(
        # Sidebar content goes here
        sidebarMenu(
            menuItem("Home", tabName = "home", icon = icon("house")),
            menuItem("Manager Tools", tabName = "manager", icon = icon("clipboard"),
                     menuSubItem("Compare Players", tabName = "compare", icon = icon("user-group")),
                     menuSubItem("Player Stats", tabName = "player_stats", icon = icon("basketball")),
                     menuSubItem("Previous Results", tabName = "results", icon = icon("medal"))
            )
        )
    ),

    dashboardBody(
        # Body content goes here
        tabItems(
            tabItem(tabName = "home", "Home Content"),
            tabItem(tabName = "compare",
                    sidebarLayout(
                        sidebarPanel(
                            selectizeInput(
                                inputId = "player_comparison_search",
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
                        ),
                        mainPanel(
                            plotOutput("comparison_plot"),
                            dataTableOutput("comparison_table")
                        )
                    )
            ),
            tabItem(tabName = "player_stats",
                    sidebarLayout(
                        sidebarPanel(
                            selectizeInput(
                                inputId = "player_stat_search",
                                label = "Select Player to View",
                                multiple = FALSE,
                                choices = nba_players$name,
                                options = list(
                                    create = FALSE,
                                    placeholder = "Enter Player Name",
                                    maxItems = '10',
                                    onDropdownOpen = I("function (str) {if (!this.lastQuery.length) {this.close(); this.settings.openOnFocus = false;}}"),
                                    onType = I('function (str) {if (str === \"\") {this.close();}}')
                                )
                            )
                        ),
                        mainPanel(
                            dataTableOutput("player_stats_table")
                        )
                    )
            ),
            tabItem(tabName = "results",
                    dataTableOutput("results_table")
            )
        )
    )
)

server <- function(input, output) {

    # Compare Players Page
    observe({
        # Initialize a new reactiveValues object
        comparison_values <- reactiveValues()
        comparison_values$df <- data.frame()

        # Get input from search bar
        selected_players <- input$player_comparison_search

        if (!is.null(selected_players) && length(selected_players) > 0) {

            comparison_values$df <- data.frame()

            # Gather game logs from Basketball Reference and prepare comparison output
            for (new_player in selected_players) {

                new_id <- subset(nba_players, name == new_player, select = id_code)

                if (length(new_id) > 0) {

                    first_letter <- new_id[1]
                    game_log_url <- sprintf("https://www.basketball-reference.com/players/%s/%s/gamelog/2023", first_letter, new_id)

                    # Web-scraping the game logs
                    isolate({

                        tables <- game_log_url %>%
                            read_html() %>%
                            html_nodes("table")

                        # Modifying data table to only care about FAN_PTS for each individual player
                        new_table <- html_table(tables[[length(tables)]], header = TRUE) %>%
                            select(Rk, TRB, AST, STL, BLK, TOV, PTS) %>%
                            mutate(Player = new_player) %>%
                            filter(Rk != "Rk") %>%
                            select(Rk, TRB, AST, STL, BLK, TOV, PTS, Player) %>%
                            mutate(TRB = as.integer(TRB), AST = as.integer(AST),
                                   STL = as.integer(STL), BLK = as.integer(BLK),
                                   TOV = as.integer(TOV), PTS = as.integer(PTS)) %>%
                            rename(Game = 'Rk') %>%
                            mutate(FAN_PTS = PTS + (3 * BLK) + (3 * STL) - TOV + (1.5 * AST) + (1.2 * TRB)) %>%
                            select(Player, Game, FAN_PTS)

                        # Combining and modifying data tables from all players for both the plot and the table
                        comparison_values$df <- bind_rows(comparison_values$df, new_table)
                        comparison_plot_table <- comparison_values$df %>% replace(is.na(.), 0) %>%
                            mutate(Game = as.integer(Game))
                        wide_comparison_table <- comparison_values$df %>%
                            pivot_wider(names_from = "Game", values_from = "FAN_PTS")

            # Plot Output
            output$comparison_plot <- renderPlot(
                ggplot(data = comparison_plot_table) +
                    geom_line(mapping = aes(x = Game, y = FAN_PTS, color = Player)) +
                    scale_fill_brewer(palette = "Spectral") +
                    labs(title = "Fantasy Points for each Game") +
                    ylab("Fantasy Points") +
                    xlab("Game Number")
            )

            # Data Table Output
            output$comparison_table <- renderDataTable(wide_comparison_table)
                    })
                }
            }
        }
    })

    # Player Stats Page
    observe({
        # Initialize a new reactiveValues object
        player_stats_values <- reactiveValues()
        player_stats_values$game_log <- data.frame()

        # Get input from the search bar
        selected_player <- input$player_stat_search

        if (!is.null(selected_player) && length(selected_player) > 0) {

            player_stats_values$game_log <- data.frame()

            new_id <- subset(nba_players, name == selected_player, select = id_code)

            if (length(new_id) > 0) {

                first_letter <- new_id[1]
                game_log_url <- sprintf("https://www.basketball-reference.com/players/%s/%s/gamelog/2023", first_letter, new_id)
                isolate({

                    # Tidy game log for display
                    tables <- game_log_url %>%
                        read_html() %>%
                        html_nodes("table")
                    new_table <- html_table(tables[[length(tables)]], header = TRUE) %>%
                        select(Rk, TRB, AST, STL, BLK, TOV, PTS) %>%
                        filter(Rk != "Rk") %>%
                        select(Rk, TRB, AST, STL, BLK, TOV, PTS) %>%
                        mutate(TRB = as.integer(TRB), AST = as.integer(AST),
                               STL = as.integer(STL), BLK = as.integer(BLK),
                               TOV = as.integer(TOV), PTS = as.integer(PTS)) %>%
                        rename(Game = 'Rk') %>%
                        mutate(FAN_PTS = PTS + (3 * BLK) + (3 * STL) - TOV + (1.5 * AST) + (1.2 * TRB)) %>%
                        select(Game, FAN_PTS, PTS, AST, TRB, STL, BLK, TOV)

                    # Game Log Data Table Output
                    player_stats_values$game_log <- new_table
                    output$player_stats_table <- renderDataTable(player_stats_values$game_log)
                })
            }
        }
    })

    # Previous Results Page
    output$results_table <- renderDataTable(read_csv("COCA_results.csv"))
}

shinyApp(ui, server)