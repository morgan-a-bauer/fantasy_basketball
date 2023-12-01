# build_dataset.R
# Morgan Bauer
# Builds a dataset

library(mdsr)
library(tidyverse)
library(mosaic)
library(rvest)
library(methods)
library(lubridate)
library(stringi)

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
    mutate(last = substr(last, 1, 5)) %>%
    mutate(first = substr(first, 1, 2)) %>%
    mutate(id_num = "01") %>%
    select(-suff) %>%
    mutate(id_num = ifelse(row_number() %in% c(11, 15, 32, 38, 58, 68, 122, 135,
                                               138, 151, 163, 179, 183, 189,
                                               200, 201, 214, 217, 257, 259,
                                               265, 270, 272, 287, 289, 290,
                                               293, 298, 341, 344, 345, 348,
                                               361, 367, 392, 393, 418, 445,
                                               451, 460), '02', id_num)) %>%
    mutate(id_num = ifelse(row_number() %in% c(40, 95, 213, 271), '03',
                           id_num)) %>%
    mutate(id_num = ifelse(row_number() %in% c(33, 36, 99, 180, 267),
                           '04', id_num)) %>%
    mutate(id_num = ifelse(row_number() %in% c(98, 229, 266, 343), '05', id_num)) %>%
    mutate(id_num = ifelse(row_number() %in% c(30, 368), '06', id_num)) %>%
    mutate(id_num = ifelse(row_number() %in% c(31, 34), '07', id_num)) %>%
    mutate(id_num = ifelse(row_number() %in% c(268), '08', id_num)) %>%
    unite(col = id_code, last, first, id_num, sep = "") %>%
    unite(col = name, first_name, last_name, suffix, sep = " ", na.rm = TRUE) %>%
    arrange(name)

get_game_log <- function(player_code, season) {
    url = sprintf("https://www.basketball-reference.com/players/%s/%s/gamelog/%s",
                  letter, player_code, season)
    tables <- url %>%
        read_html() %>%
        html_nodes("table")
    new_table <- html_table(tables[[8]], header = TRUE, fill = TRUE, convert = TRUE)
    colnames(new_table) <- c('Rk', 'G', 'Date', 'Age', 'Tm', 'Home', 'Opp',
                             'Win', 'GS', 'MP', 'FG', 'FGA', 'FGP', 'TP', 'TPA',
                             'TPP', 'FT', 'FTA', 'FTP', 'ORB', 'DRB', 'TRB',
                             'AST', 'STL', 'BLK', 'TOV', 'PF', 'PTS', 'GmSc', 'PM')
    new_table <- new_table %>% filter(GS != 'Inactive') %>%
        separate(Age, into = c("Years", "Days"), sep = "-") %>%
        mutate(Age = as.integer(Years)) %>%
        filter(Rk != "Rk") %>%
        select(-c(Rk, G, Date, Years, Days, Tm, Win, GmSc, PM)) %>%
        mutate(Home = ifelse(Home == "@", "0", "1")) %>%
        separate(MP, into = c("Mins", "Secs")) %>%
        mutate(Home = as.integer(Home), GS = as.integer(GS),
               Mins = as.integer(Mins), Secs = as.integer(Secs),
               FG = as.integer(FG), FGA = as.integer(FGA),
               FGP = as.double(FGP), TP = as.integer(TP),
               TPA = as.integer(TPA), TPP = as.double(TPP),
               FT = as.integer(FT), FTA = as.integer(FTA),
               FTP = as.double(FTP), ORB = as.integer(ORB),
               DRB = as.integer(DRB), TRB = as.integer(TRB),
               AST = as.integer(AST), STL = as.integer(STL),
               BLK = as.integer(BLK), TOV = as.integer(TOV),
               PF = as.integer(PF), PTS = as.integer(PTS),
               Age = as.integer(Age)) %>%
        mutate(Secs = Secs / 60) %>%
        mutate(MP = Mins + Secs) %>%
        select(-c(Mins, Secs))
    return(new_table)
}

save_game_logs <- function() {

}