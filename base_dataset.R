# TBD
# Morgan Bauer

library(mdsr)
library(tidyverse)
library(mosaic)
library(rvest)
library(methods)
library(lubridate)
library(RSelenium)

# Load team names and abbreviations from Wikipedia
team_abbr_url <- "https://en.wikipedia.org/wiki/Wikipedia:WikiProject_National_Basketball_Association/National_Basketball_Association_team_abbreviations"
team_abbr_tables <- team_abbr_url %>%
    read_html() %>%
    html_nodes("table")

# Create franchise name to abbreviation data frame
team_abbrs <- html_table(team_abbr_tables[[1]], header = TRUE) %>%
    rename(abbr = 'Abbreviation/Acronym',
           franchise = Franchise)

# Load 2022-23 NBA schedule from basketball reference
sched_csv <- read_csv("nba_schedule_2022_23.csv")

# Create league schedule data frame
league_sched <- sched_csv %>%
    select('Date', 'Start (ET)', 'Visitor/Neutral', 'Home/Neutral', 'Arena', 8) %>%
    rename(date = Date, time = 'Start (ET)', visitor = 'Visitor/Neutral',
           home = 'Home/Neutral', arena = Arena, ot = "...8") %>%
    mutate(ot = if_else(c(ot == 'OT'), 1, 0, missing = 0)) %>%
    separate(col = date, into = c('wday', 'month', 'day', 'year')) %>%
    select(-wday) %>%
    separate(col = time, into = c('hours', 'rest'), sep = ':') %>%
    separate(col = rest, into = c('minutes', 'del'), sep = 'p') %>%
    select(-del) %>%
    mutate(hours = as.integer(hours) + 12) %>%
    unite(col = time, hours, minutes, sep = ":") %>%
    unite(col = datetime, year, month, day, time, sep = " ") %>%
    mutate(datetime = ymd_hm(datetime, quiet = FALSE, tz = "US/Eastern",
                             locale = Sys.getlocale("LC_TIME"),
                             truncated = 0))

# Load table of players from NBA RealGM
player_lyst_url <- "https://basketball.realgm.com/nba/players"
player_lyst_tables <- player_lyst_url %>%
    read_html() %>%
    html_nodes("table")

# Load table of players from nba.com
player_lyst_url2 <- "https://nba.com/players"
player_lyst_tables2 <- player_lyst_url2 %>%
    read_html() %>%
    html_nodes("table")

# Start a Selenium server
selServ <- RSelenium::rsDriver(browser = "chrome")
remDr <- selServ$client

# Navigate to the page with the table
remDr$navigate("https://nba.com/players")

# Retrieve the HTML content after the JavaScript has executed
html <- remDr$getPageSource()[[1]]

# Close the Selenium server
remDr$close()
selServ$server$stop()

# Parse the HTML content and extract the table
table <- html %>% read_html() %>% html_node(".players-list") %>% html_table()

# Print the number of rows in the table
nrows <- nrow(table)
print(nrows)

# Create a data frame of players and player info
player_lyst2 <- html_table(player_lyst_tables2[[1]], header = TRUE)
    #rename(number = "#", player_name = "Player", pos = "Pos", height = "HT",
           weight = "WT", age = "Age", franchise = "Current Team",
           seasons_played = "YOS", pre_draft_team = "Pre-Draft Team",
           draft_pos = "Draft Status", nationality = "Nationality") %>%
    separate(col = player_name, into = c("first_name", "last_name", "suffix"),
             sep = " ") %>%
    mutate(first = tolower(first_name), last = tolower(last_name), suff = tolower(suffix)) %>%
    mutate(first = gsub("[[:punct:]]", "", first), last = gsub("[[:punct:]]", "", last), suff = gsub("[[:punct:]]", "", suff)) %>%
    unite(col = name, first_name, last_name, suffix, sep = " ", na.rm = TRUE) %>%
    unite(col = player_code, first, last, suff, sep = "-", na.rm = TRUE)


player_url()
# Links
## Abbreviations
# https://en.wikipedia.org/wiki/Wikipedia:WikiProject_National_Basketball_Association/National_Basketball_Association_team_abbreviations
## 2022-23 Schedule
# https://www.basketball-reference.com/leagues/NBA_2023_games-october.html
# https://www.basketball-reference.com/leagues/NBA_2023_games-november.html
# https://www.basketball-reference.com/leagues/NBA_2023_games-december.html
# https://www.basketball-reference.com/leagues/NBA_2023_games-january.html
# https://www.basketball-reference.com/leagues/NBA_2023_games-february.html
# https://www.basketball-reference.com/leagues/NBA_2023_games-march.html
# https://www.basketball-reference.com/leagues/NBA_2023_games-april.html
## List of Players
# https://basketball.realgm.com/nba/players

#ChatGPT