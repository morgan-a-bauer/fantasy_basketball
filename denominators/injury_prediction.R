library(tidyverse)
library(rvest)

load('denominators/fantasyBasketball2023.RData')

#Building Training Set
per_game_1 <- "https://www.basketball-reference.com/leagues/NBA_2022_per_game.html"
totals_1 <- "https://www.basketball-reference.com/leagues/NBA_2022_totals.html"
advanced_1 <- "https://www.basketball-reference.com/leagues/NBA_2022_advanced.html"
per_game_2 <- "https://www.basketball-reference.com/leagues/NBA_2021_per_game.html"
totals_2 <- "https://www.basketball-reference.com/leagues/NBA_2021_totals.html"
advanced_2 <- "https://www.basketball-reference.com/leagues/NBA_2021_advanced.html"
per_game_3 <- "https://www.basketball-reference.com/leagues/NBA_2020_per_game.html"
totals_3 <- "https://www.basketball-reference.com/leagues/NBA_2020_totals.html"
advanced_3 <- "https://www.basketball-reference.com/leagues/NBA_2020_advanced.html"
per_game_4 <- "https://www.basketball-reference.com/leagues/NBA_2019_per_game.html"
totals_4 <- "https://www.basketball-reference.com/leagues/NBA_2019_totals.html"
advanced_4 <- "https://www.basketball-reference.com/leagues/NBA_2019_advanced.html"
per_game_5 <- "https://www.basketball-reference.com/leagues/NBA_2018_per_game.html"
totals_5 <- "https://www.basketball-reference.com/leagues/NBA_2018_totals.html"
advanced_5 <- "https://www.basketball-reference.com/leagues/NBA_2018_advanced.html"

get_stats_training_table <- function(url, yr) {
    tables <- url %>%
        read_html() %>%
        html_nodes("table")
    table <- html_table(tables[[1]], header = TRUE) %>%
        mutate(year = yr)
    return(table)
}

get_advanced_stats_training_table <- function(url, yr) {
    tables <- url %>%
        read_html() %>%
        html_nodes("table")
    table <- html_table(tables[[1]], header = TRUE) %>%
        select('Rk', 'Player', 'Pos', 'Age', 'Tm', 'G', 'MP', 'PER', 'TS%', '3PAr',
               'FTr', 'ORB%', 'DRB%', 'TRB%', 'AST%', 'STL%', 'BLK%', 'TOV%', 'USG%',
               'OWS', 'DWS', 'WS', 'WS/48', 'OBPM', 'DBPM', 'BPM', 'VORP') %>%
        mutate(year = yr)
    return(table)
}

per_game_training_table <- bind_rows(get_stats_training_table(per_game_1, 2022),
                                     get_stats_training_table(per_game_2, 2021),
                                     get_stats_training_table(per_game_3, 2020),
                                     get_stats_training_table(per_game_4, 2019),
                                     get_stats_training_table(per_game_5, 2018)) %>%
    filter(Rk != "Rk") %>%
    rename(MPPG = "MP", FGPG = "FG", FGAPG = "FGA", FGPPG = "FG%", ThPPG = "3P",
           ThPAPG = "3PA", ThPPPG = "3P%", TwPPG = "2P", TwPAPG = "2PA",
           TwPPPG = "2P%", eFGP = "eFG%", FTPG = "FT", FTAPG = "FTA",
           FTPPG = "FT%", ORBPG = "ORB", DRBPG = "DRB", TRBPG = "TRB",
           APG = "AST", SPG = "STL", BPG = "BLK", TPG = "TOV", PFPG = "PF",
           PPG = "PTS")

totals_training_table <- bind_rows(get_stats_training_table(totals_1, 2022),
                                   get_stats_training_table(totals_2, 2021),
                                   get_stats_training_table(totals_3, 2020),
                                   get_stats_training_table(totals_4, 2019),
                                   get_stats_training_table(totals_5, 2018)) %>%
    filter(Rk != "Rk") %>%
    rename(FGP = "FG%", ThP = "3P", ThPA = "3PA", ThPP = "3P%", TwP = "2P",
           TwPA = "2PA", TwPP = "2P%", eFGP = "eFG%", FTP = "FT%")

advanced_training_table <- bind_rows(get_advanced_stats_training_table(advanced_1, 2022),
                                     get_advanced_stats_training_table(advanced_2, 2021),
                                     get_advanced_stats_training_table(advanced_3, 2020),
                                     get_advanced_stats_training_table(advanced_4, 2019),
                                     get_advanced_stats_training_table(advanced_5, 2018)) %>%
    filter(Rk != 'Rk') %>%
    rename(TSP = "TS%", ORBP = "ORB%", DRBP = "DRB%", TRBP = "TRB%", ASTP = "AST%",
           STLP = "STL%", BLKP = "BLK%", TOVP = "TOV%", USGr = "USG%", WSp48 = "WS/48",
    )

master_training_table <- per_game_training_table %>%
    left_join(totals_training_table, by = join_by(Rk == Rk, Player == Player, Pos == Pos,
                                                  Age == Age, Tm == Tm, G == G,
                                                  GS == GS, eFGP == eFGP)) %>%
    left_join(advanced_training_table, by = join_by(Rk == Rk, Player == Player, Pos == Pos,
                                                    Age == Age, Tm == Tm, G == G, MP == MP)) %>%
    select(-Rk) %>%
    rename(ThPAr = "3PAr", ) %>%
    mutate(Age = as.integer(Age), G = as.integer(G), GS = as.integer(GS),
           MPPG = as.double(MPPG), FGPG  = as.double(FGPG), FGAPG = as.double(FGAPG),
           FGPPG = as.double(FGPPG), ThPPG = as.double(ThPPG), ThPAPG = as.double(ThPAPG),
           ThPPPG = as.double(ThPPPG), TwPPG = as.double(TwPPG), TwPAPG = as.double(TwPAPG),
           TwPPPG = as.double(TwPPPG), eFGP = as.double(eFGP), FTPG = as.double(FTPG),
           FTAPG = as.double(FTAPG), FTPPG = as.double(FTPPG), ORBPG = as.double(ORBPG),
           DRBPG = as.double(DRBPG), TRBPG = as.double(TRBPG), APG = as.double(APG),
           SPG = as.double(SPG), BPG = as.double(BPG), TPG = as.double(TPG),
           PFPG = as.double(PFPG), PPG = as.double(PPG), MP = as.integer(MP),
           FG = as.integer(FG), FGA = as.integer(FGA), FGP = as.double(FGP),
           ThP = as.integer(ThP), ThPA = as.integer(ThPA), ThPP = as.double(ThPP),
           TwP = as.integer(TwP), TwPA = as.integer(TwPA), TwPP = as.double(TwPP),
           FT = as.integer(FT), FTA = as.integer(FTA), FTP = as.double(FTP),
           ORB = as.integer(ORB), DRB = as.integer(DRB), TRB = as.integer(TRB),
           AST = as.integer(AST), STL = as.integer(STL), BLK = as.integer(BLK),
           TOV = as.integer(TOV), PF = as.integer(PF), PTS = as.integer(PTS),
           PER = as.double(PER), TSP = as.double(TSP), ThPAr = as.double(ThPAr),
           FTr = as.double(FTr), ORBP = as.double(ORBP), DRBP = as.double(DRBP),
           TRBP = as.double(TRBP), ASTP = as.double(ASTP), STLP = as.double(STLP),
           BLKP = as.double(BLKP), TOVP = as.double(TOVP), USGr = as.double(USGr),
           OWS = as.double(OWS), DWS = as.double(DWS), WS = as.double(WS),
           WSp48 = as.double(WSp48), OBPM = as.double(OBPM), DBPM = as.double(DBPM),
           BPM = as.double(BPM), VORP = as.double(VORP)) %>%
    mutate(FAN_PTS_PG = PPG + (1.5 * APG) + (1.2 * TRBPG) + (3 * SPG) + (3 * BPG) - TPG) %>%
    mutate(FAN_PTS = PTS + (1.5 * AST)  + (1.2 * TRB) + (3 * STL) + (3 * BLK) - TOV) %>%
    relocate(FAN_PTS_PG, .after = GS) %>%
    relocate(FAN_PTS, .after = FAN_PTS_PG)

new_player_training_table <- nba_players %>%
    separate(col = height, into = c("feet", "inches"), sep = "-") %>%
    mutate(start_yr = as.integer(start_yr), feet = as.integer(feet),
           inches = as.integer(inches), weight = as.integer(weight)) %>%
    mutate(feet = feet * 12) %>%
    mutate(height = feet + inches) %>%
    select(-c(feet, inches)) %>%
    relocate(height, .before = weight)

modified_master_training <- master_table %>%
    select(Player, Pos, Age, G, GS, MPPG, FTAPG, TRBPG, BPG, PFPG, MP, FTA, TRB, BLK) %>%
    group_by(Player) %>%
    summarize(Pos = Pos, Age = Age, G = sum(G), GS = sum(GS), MPPG = mean(MPPG),
              FTAPG = mean(FTAPG), TRBPG = mean(TRBPG), BPG = mean(BPG),
              PFPG = mean(PFPG), MP = sum(MP), FTA = sum(FTA), TRB = sum(TRB), BLK = sum(BLK)) %>%
    group_by(Player, Pos, Age, G, GS, MPPG, FTAPG, TRBPG, BPG, PFPG, MP, FTA, TRB, BLK) %>%
    summarize()

test_table <- new_player_table %>% left_join(modified_master, by = join_by(name == Player))

# Building table of all stats -- Per Game, Total, and Advanced
per_game_url <- "https://www.basketball-reference.com/leagues/NBA_2023_per_game.html"
totals_url <- "https://www.basketball-reference.com/leagues/NBA_2023_totals.html"
advanced_url <- "https://www.basketball-reference.com/leagues/NBA_2023_advanced.html"

get_stats_test_table <- function(url, yr) {
    tables <- url %>%
        read_html() %>%
        html_nodes("table")
    table <- html_table(tables[[1]], header = TRUE) %>%
        mutate(year = yr)
    return(table)
}

per_game_table <- get_stats_table(per_game_url) %>%
    filter(Rk != "Rk") %>%
    rename(MPPG = "MP", FGPG = "FG", FGAPG = "FGA", FGPPG = "FG%", ThPPG = "3P",
           ThPAPG = "3PA", ThPPPG = "3P%", TwPPG = "2P", TwPAPG = "2PA",
           TwPPPG = "2P%", eFGP = "eFG%", FTPG = "FT", FTAPG = "FTA",
           FTPPG = "FT%", ORBPG = "ORB", DRBPG = "DRB", TRBPG = "TRB",
           APG = "AST", SPG = "STL", BPG = "BLK", TPG = "TOV", PFPG = "PF",
           PPG = "PTS")

totals_table <- get_stats_table(totals_url) %>%
    filter(Rk != "Rk") %>%
    rename(FGP = "FG%", ThP = "3P", ThPA = "3PA", ThPP = "3P%", TwP = "2P",
           TwPA = "2PA", TwPP = "2P%", eFGP = "eFG%", FTP = "FT%")

advanced_table <- get_stats_table(advanced_url) %>%
    select('Rk', 'Player', 'Pos', 'Age', 'Tm', 'G', 'MP', 'PER', 'TS%', '3PAr',
           'FTr', 'ORB%', 'DRB%', 'TRB%', 'AST%', 'STL%', 'BLK%', 'TOV%', 'USG%',
           'OWS', 'DWS', 'WS', 'WS/48', 'OBPM', 'DBPM', 'BPM', 'VORP') %>%
    filter(Rk != 'Rk') %>%
    rename(TSP = "TS%", ORBP = "ORB%", DRBP = "DRB%", TRBP = "TRB%", ASTP = "AST%",
           STLP = "STL%", BLKP = "BLK%", TOVP = "TOV%", USGr = "USG%", WSp48 = "WS/48",
    )

master_table <- per_game_table %>%
    left_join(totals_table, by = join_by(Rk == Rk, Player == Player, Pos == Pos,
                                         Age == Age, Tm == Tm, G == G,
                                         GS == GS, eFGP == eFGP)) %>%
    left_join(advanced_table, by = join_by(Rk == Rk, Player == Player, Pos == Pos,
                                           Age == Age, Tm == Tm, G == G, MP == MP)) %>%
    select(-Rk) %>%
    rename(ThPAr = "3PAr", ) %>%
    mutate(Age = as.integer(Age), G = as.integer(G), GS = as.integer(GS),
           MPPG = as.double(MPPG), FGPG  = as.double(FGPG), FGAPG = as.double(FGAPG),
           FGPPG = as.double(FGPPG), ThPPG = as.double(ThPPG), ThPAPG = as.double(ThPAPG),
           ThPPPG = as.double(ThPPPG), TwPPG = as.double(TwPPG), TwPAPG = as.double(TwPAPG),
           TwPPPG = as.double(TwPPPG), eFGP = as.double(eFGP), FTPG = as.double(FTPG),
           FTAPG = as.double(FTAPG), FTPPG = as.double(FTPPG), ORBPG = as.double(ORBPG),
           DRBPG = as.double(DRBPG), TRBPG = as.double(TRBPG), APG = as.double(APG),
           SPG = as.double(SPG), BPG = as.double(BPG), TPG = as.double(TPG),
           PFPG = as.double(PFPG), PPG = as.double(PPG), MP = as.integer(MP),
           FG = as.integer(FG), FGA = as.integer(FGA), FGP = as.double(FGP),
           ThP = as.integer(ThP), ThPA = as.integer(ThPA), ThPP = as.double(ThPP),
           TwP = as.integer(TwP), TwPA = as.integer(TwPA), TwPP = as.double(TwPP),
           FT = as.integer(FT), FTA = as.integer(FTA), FTP = as.double(FTP),
           ORB = as.integer(ORB), DRB = as.integer(DRB), TRB = as.integer(TRB),
           AST = as.integer(AST), STL = as.integer(STL), BLK = as.integer(BLK),
           TOV = as.integer(TOV), PF = as.integer(PF), PTS = as.integer(PTS),
           PER = as.double(PER), TSP = as.double(TSP), ThPAr = as.double(ThPAr),
           FTr = as.double(FTr), ORBP = as.double(ORBP), DRBP = as.double(DRBP),
           TRBP = as.double(TRBP), ASTP = as.double(ASTP), STLP = as.double(STLP),
           BLKP = as.double(BLKP), TOVP = as.double(TOVP), USGr = as.double(USGr),
           OWS = as.double(OWS), DWS = as.double(DWS), WS = as.double(WS),
           WSp48 = as.double(WSp48), OBPM = as.double(OBPM), DBPM = as.double(DBPM),
           BPM = as.double(BPM), VORP = as.double(VORP)) %>%
    mutate(FAN_PTS_PG = PPG + (1.5 * APG) + (1.2 * TRBPG) + (3 * SPG) + (3 * BPG) - TPG) %>%
    mutate(FAN_PTS = PTS + (1.5 * AST)  + (1.2 * TRB) + (3 * STL) + (3 * BLK) - TOV) %>%
    relocate(FAN_PTS_PG, .after = GS) %>%
    relocate(FAN_PTS, .after = FAN_PTS_PG)

new_player_table <- nba_players %>%
    separate(col = height, into = c("feet", "inches"), sep = "-") %>%
    mutate(start_yr = as.integer(start_yr), feet = as.integer(feet),
           inches = as.integer(inches), weight = as.integer(weight)) %>%
    mutate(feet = feet * 12) %>%
    mutate(height = feet + inches) %>%
    select(-c(feet, inches)) %>%
    relocate(height, .before = weight)

modified_master <- master_table %>%
    select(Player, Pos, Age, G, GS, MPPG, FTAPG, TRBPG, BPG, PFPG, MP, FTA, TRB, BLK) %>%
    group_by(Player) %>%
    summarize(Pos = Pos, Age = Age, G = sum(G), GS = sum(GS), MPPG = mean(MPPG),
              FTAPG = mean(FTAPG), TRBPG = mean(TRBPG), BPG = mean(BPG),
              PFPG = mean(PFPG), MP = sum(MP), FTA = sum(FTA), TRB = sum(TRB), BLK = sum(BLK)) %>%
    group_by(Player, Pos, Age, G, GS, MPPG, FTAPG, TRBPG, BPG, PFPG, MP, FTA, TRB, BLK) %>%
    summarize()

test_table <- new_player_table %>% left_join(modified_master, by = join_by(name == Player))
