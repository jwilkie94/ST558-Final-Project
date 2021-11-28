

library(shiny)
library(tidyverse)

shinyServer(function(input, output, session) {
    data<-read.csv("owid-co2-data.csv", header=TRUE)%>%na.omit()
})
