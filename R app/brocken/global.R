library(shiny)
library(shinyjs)
library(DT)
library(ggplot2)
library(dplyr)

lexicon <- "afinn"


#read data
authors = read.csv('data/books_page.csv', header=TRUE)

dates =read.csv('data/books_page_date.csv', header=TRUE)
dates = dates[, names(dates) %in% c("title","date")] 

authors = left_join(authors, dates, by = "title")

authors$date[authors$date =='null'] <- NA
authors$date <- as.Date(authors$date,format = "%b %d, %Y")

startdate <- sort(authors$date, na.last = FALSE)[which.min(is.na(sort(authors$date, na.last = FALSE)))]
enddate <- sort(authors$date, na.last = FALSE)[length(sort(authors$date, na.last = FALSE))]


