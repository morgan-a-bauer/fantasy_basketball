# TBD
# Morgan Bauer

library(mdsr)
library(tidyverse)
library(mosaic)
library(rvest)
library(methods)
library(lubridate)
library(stringi)

###############################TEAM ABBREVIATIONS###############################

# Load team names and abbreviations from Wikipedia
team_abbr_url <- "https://en.wikipedia.org/wiki/Wikipedia:WikiProject_National_Basketball_Association/National_Basketball_Association_team_abbreviations"
team_abbr_tables <- team_abbr_url %>%
    read_html() %>%
    html_nodes("table")

# Create franchise name to abbreviation data frame
team_abbreviations <- html_table(team_abbr_tables[[1]], header = TRUE) %>%
    rename(abbr = 'Abbreviation/Acronym', franchise = Franchise)

###############################NBA 22-23 Schedule###############################

# Load 2022-23 NBA schedule from basketball reference
sched_csv <- read_csv("nba_schedule_2022_23.csv")

# Create league schedule data frame
league_schedule_2023 <- sched_csv %>%
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

player_table <- player_table %>% filter(To == 2024) # Only includes current players

# Create player data frame
nba_players <- player_table %>%
    rename(name = "Player", start_yr = "From", end_yr = "To", pos = "Pos",
           height = "Ht", weight = "Wt", birthdate = "Birth Date",
           colleges = "Colleges") %>%
    separate(col = name, into = c("first_name", "last_name", "suffix"),
             sep = " ") %>%
    mutate(first = tolower(first_name), last = tolower(last_name), suff = tolower(suffix)) %>%
    mutate(first = gsub("[[:punct:]]", "", first), last = gsub("[[:punct:]]", "", last), suff = gsub("[[:punct:]]", "", suff)) %>%
    mutate(first = stri_trans_general(first, "Latin-ASCII"),
           last = stri_trans_general(last, "Latin-ASCII"),
           suff = stri_trans_general(suff, "Latin-ASCII")) %>%
    select(-end_yr) %>%
    mutate(last = substr(last, 1, 5)) %>%
    mutate(first = substr(first, 1, 2)) %>%
    mutate(id_num = "01") %>%
    select(-suff) %>%
    mutate(id_num = ifelse(row_number() %in% c(12, 16, 18, 33, 37, 43, 65, 74, 126, 142, 144, 149, 159, 172, 192, 198, 205, 216, 231, 233, 236, 268, 282, 289, 290, 299, 317, 319, 321, 322, 327, 333, 376, 380, 381, 382, 392, 398, 403, 405, 442, 445, 472, 491, 509, 512, 518, 519), '02', id_num)) %>%
    mutate(id_num = ifelse(row_number() %in% c(27, 99, 230, 246, 297, 298, 510), '03', id_num)) %>%
    mutate(id_num = ifelse(row_number() %in% c(38, 41, 103, 194, 293, 295), '04', id_num)) %>%
    mutate(id_num = ifelse(row_number() %in% c(102, 291, 378), '05', id_num)) %>%
    mutate(id_num = ifelse(row_number() %in% c(32, 35, 404), '06', id_num)) %>%
    mutate(id_num = ifelse(row_number() %in% c(36, 39, 294), '07', id_num)) %>%
    unite(col = id_code, last, first, id_num, sep = "") %>%
    unite(col = name, first_name, last_name, suffix, sep = " ", na.rm = TRUE) %>%
    arrange(name)

save(team_abbreviations, league_schedule_2023, nba_players, file = "fantasyBasketball2023.RData")

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