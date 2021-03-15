library(shiny)
library(shinyjs)
library(DT)
library(ggplot2)
library(dplyr)
library(rgdal)
library(sp)
library(leaflet)

#print(getwd())

#read data

authors = read.csv('data/books_page.csv', header=TRUE)

dates =read.csv('data/books_page_date.csv', header=TRUE)
# 
world_spdf <- readOGR(
  dsn= "data" ,
  layer="TM_WORLD_BORDERS_SIMPL-0.3",
  verbose=FALSE
)

dates$date[dates$date == 'null'] <- NA #"Mar 10, 2018" #if date missing set to the start date
dates = dates[, names(dates) %in% c("title","date")] 

# set up the data
authors = left_join(authors, dates, by = "title")

authors$date[is.na(authors$date)] <- NA #"May 4, 2018"
authors$date <- as.Date(authors$date,format = "%b %d, %Y")


#start and end dates for reading
startdate <- sort(authors$date, na.last = FALSE)[which.min(is.na(sort(authors$date, na.last = FALSE)))]
enddate <- sort(authors$date, na.last = FALSE)[length(sort(authors$date, na.last = FALSE))]


#col palet
# count =  authors %>% count(country.1)
# pal <- colorBin("YlOrRd", count$n, bins=5, na.color = "#bdbdbd")

color <- c("blue", "red", 'green')


