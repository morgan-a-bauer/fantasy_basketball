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
team_abbrs.df <- html_table(team_abbr_tables[[1]], header = TRUE) %>%
    rename(abbr = 'Abbreviation/Acronym', franchise = Franchise)

###############################NBA 22-23 Schedule###############################

# Load 2022-23 NBA schedule from basketball reference
sched_csv <- read_csv("nba_schedule_2022_23.csv")

# Create league schedule data frame
league_sched.df <- sched_csv %>%
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

player_table <- data.frame()

# All NBA and ABA players
append_letter_table <- function(letter, table) {
    url = sprintf("https://www.basketball-reference.com/players/%s/", letter)
    tables <- url %>%
        read_html() %>%
        html_nodes("table")
    new_table <- html_table(tables[[1]], header = TRUE)
    updated_table <- bind_rows(new_table, table)
    return(updated_table)
}

# Append players whose last names begin with each letter of the alphabet (except x)
for (letter in letters) {
    if (letter == "x") {
        next
    }
    player_table <- append_letter_table(letter, player_table)
    Sys.sleep(7) # To prevent HTTPS error 429
}

player_table <- player_table %>% filter(To == 2023) # Only includes current players

# Create player data frame
player_table.df <- player_table %>%
    rename(name = "Player", start_yr = "From", end_yr = "To", pos = "Pos",
           height = "Ht", weight = "Wt", birthdate = "Birth Date",
           colleges = "Colleges") %>%
    separate(col = name, into = c("first_name", "last_name", "suffix"),
             sep = " ") %>%
    mutate(first = tolower(first_name), last = tolower(last_name), suff = tolower(suffix)) %>%
    mutate(first = gsub("[[:punct:]]", "", first), last = gsub("[[:punct:]]", "", last), suff = gsub("[[:punct:]]", "", suff)) %>%
    unite(col = player_code, first, last, suff, sep = "-", na.rm = TRUE) %>%
    select(-end_yr)

save(team_abbrs.df, league_sched.df, player_table.df, file = "fantasyBasketball2023.RData")

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
# https://www.basketball-reference.com/players/
#ChatGPT