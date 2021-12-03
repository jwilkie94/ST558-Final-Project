

library(shiny)
library(tidyverse)
library(caret)


shinyServer(function(input, output) {
    data<-read.csv("owid-co2-data.csv", header=TRUE)%>%na.omit()
    
})
