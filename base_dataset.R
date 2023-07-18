# TBD
# Morgan Bauer

library(mdsr)
library(tidyverse)
library(mosaic)
library(rvest)
library(methods)
library(lubridate)

###############################TEAM ABBREVIATIONS###############################

# Load team names and abbreviations from Wikipedia
team_abbr_url <- "https://en.wikipedia.org/wiki/Wikipedia:WikiProject_National_Basketball_Association/National_Basketball_Association_team_abbreviations"
team_abbr_tables <- team_abbr_url %>%
    read_html() %>%
    html_nodes("table")

# Create franchise name to abbreviation data frame
team_abbrs <- html_table(team_abbr_tables[[1]], header = TRUE) %>%
    rename(abbr = 'Abbreviation/Acronym',
           franchise = Franchise) %>%
    mutate(url_code = franchise) %>%
    separate(col = url_code, into = c('word1', 'word2', 'word3')) %>%
    mutate(word1 = tolower(word1), word2 = tolower(word2), word3 = tolower(word3)) %>%
    unite(col = url_code, word1, word2, word3, sep = '-', na.rm = TRUE) %>%
    mutate(url = paste('https://www.espn.com/nba/team/roster/_/name/', tolower(abbr), '/', url_code, sep = ""))

###############################NBA 22-23 Schedule###############################

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

##################################Player Frame##################################

player_table <- data.frame(img = c(), name = c(), pos = c(), age = c(),
                           hgt = c(), wgt = c(), college = c(), sal = c())

# Get the roster of an individual team
team_roster_table <- function(url, main_table) {
    tables <- url %>%
        read_html() %>%
        html_nodes("table")
        roster <- html_table(tables[[1]], header = FALSE)
        main_table <- full_join(main_table, roster)
}

# Load table of players from NBA RealGM
player_lyst_url <- "https://www.espn.com/nba/team/roster/_/name/"
player_lyst_tables <- player_lyst_url %>%
    read_html() %>%
    html_nodes("table")

# Create a data frame of players and player info
player_lyst <- html_table(player_lyst_tables[[1]], header = TRUE) %>%
    rename(number = "#", player_name = "Player", pos = "Pos", height = "HT",
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
# https://www.espn.com/nba/

#ChatGPT