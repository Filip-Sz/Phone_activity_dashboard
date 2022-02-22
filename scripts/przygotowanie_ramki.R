malwina <- read.csv("data/apps_m.csv", encoding="UTF-8", stringsAsFactors=FALSE)
jedrek <- read.csv("data/apps_j.csv", encoding="UTF-8", stringsAsFactors=FALSE)
filip <- read.csv("data/apps_f.csv", encoding="UTF-8", stringsAsFactors=FALSE)
source("scripts/konwersja_danych.R")
library(tidyverse)

przygotowanie_pliku <- function(plikCSV, startDate, endDate){
  plikCSV <- convert_data(plikCSV)
  plikCSV <- plikCSV[plikCSV$Data >= startDate, ]
  plikCSV <- plikCSV[plikCSV$Data <= endDate, ]
  plikCSV <- plikCSV %>% group_by(App.name) %>% 
    summarise(time_sum = sum(duration_minutes))
}

przygotowanie_ramki <- function(malwina, jedrek, filip, startDate, endDate){
  malwina <- przygotowanie_pliku(malwina, startDate, endDate)
  colnames(malwina)[2] <- "Malwina"
  jedrek <- przygotowanie_pliku(jedrek, startDate, endDate)
  colnames(jedrek)[2] <- "Jedrek"
  filip <- przygotowanie_pliku(filip, startDate, endDate)
  colnames(filip)[2] <- "Filip"

  data <- merge(malwina, jedrek, by="App.name", all = TRUE)
  data <- merge(data, filip, by = "App.name", all = TRUE) 
  malwina <- NULL
  jedrek <- NULL
  filip <- NULL
  data[is.na(data)] <- 0
  data <- data %>% add_row(App.name = "Browser", 
                           Malwina = data[data$App.name == "Chrome", "Malwina"],
                           Jedrek = data[data$App.name == "Opera Touch", "Jedrek"],
                           Filip = data[data$App.name == "Chrome", "Filip"])
  data <- data %>% add_row(App.name = "PhoneW", 
                           Malwina = data[data$App.name == "Telefon", "Malwina"],
                           Jedrek = data[data$App.name == "Phone", "Jedrek"],
                           Filip = data[data$App.name == "Telefon", "Filip"])
  #data <- data[!(data$App.name == "Phone"), ]
  #data["App.name"][data["App.name"] == "PhoneW"] <- "Phone"
  data <- data %>% add_row(App.name = "Spotify/Tidal", 
                           Malwina = data[data$App.name == "Spotify", "Malwina"],
                           Jedrek = data[data$App.name == "TIDAL", "Jedrek"],
                           Filip = data[data$App.name == "Spotify", "Filip"])
  data <- data %>% add_row(App.name = "WiadomosciW", 
                           Malwina = data[data$App.name == "Wiadomości", "Malwina"],
                           Jedrek = data[data$App.name == "Messages", "Jedrek"],
                           Filip = data[data$App.name == "Wiadomości", "Filip"])
  #data <- data[!(data$App.name == "Messages"), ]
  #data["App.name"][data["App.name"] == "MessagesW"] <- "Messages"
}

# #sprawdzam co mamy najczesciej
# mal <- data %>%
#   arrange(desc(Malwina))
# jdr <- data %>%
#   arrange(desc(Jedrek))
# fil <- data %>%
#   arrange(desc(Filip))

# 
#  malwina <- przygotowanie_pliku(malwina, "2021-12-09", "2021-12-26")
# colnames(malwina)[2] <- "Malwina"
#  jedrek <- przygotowanie_pliku(jedrek, "2021-12-09", "2021-12-26")
#  colnames(jedrek)[2] <- "Jedrek"
#  filip <- przygotowanie_pliku(filip, "2021-12-09", "2021-12-26")
#  colnames(filip)[2] <- "Filip"
# # 
# # 
# data <- merge(malwina, jedrek, by="App.name", all = TRUE)
# data <- merge(data, filip, by = "App.name", all = TRUE)
# # # rm(malwina)
# # # rm(jedrek)
# # # rm(filip)
# data[is.na(data)] <- 0
# data <- data %>% add_row(App.name = "Browser",
#                          Malwina = data[data$App.name == "Chrome", "Malwina"],
#                          Jedrek = data[data$App.name == "Opera Touch", "Jedrek"],
#                          Filip = data[data$App.name == "Chrome", "Filip"])
# data <- data %>% add_row(App.name = "PhoneW",
#                          Malwina = data[data$App.name == "Telefon", "Malwina"],
#                          Jedrek = data[data$App.name == "Phone", "Jedrek"],
#                          Filip = data[data$App.name == "Telefon", "Filip"])
# # data <- data[!(data$App.name == "Phone"), ]
# # data["App.name"][data["App.name"] == "PhoneW"] <- "Phone"
# data <- data %>% add_row(App.name = "Spotify/Tidal",
#                          Malwina = data[data$App.name == "Spotify", "Malwina"],
#                          Jedrek = data[data$App.name == "TIDAL", "Jedrek"],
#                          Filip = data[data$App.name == "Spotify", "Filip"])
# data <- data %>% add_row(App.name = "MessagesW",
#                          Malwina = data[data$App.name == "Wiadomości", "Malwina"],
#                          Jedrek = data[data$App.name == "Messages", "Jedrek"],
#                          Filip = data[data$App.name == "Wiadomości", "Filip"])
# # data <- data[!(data$App.name == "Messages"), ]
# # data["App.name"][data["App.name"] == "MessagesW"] <- "Messages"
