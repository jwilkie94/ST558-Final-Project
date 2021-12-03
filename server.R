

library(shiny)
library(tidyverse)
library(caret)

#read in two data sets, remove years from data set 2 that are not captured in the first data set
data1<-read.csv("climate-forcing_fig-1.csv", header=TRUE, skip=6)
data2<-read.csv("temperature_fig-2_0.csv", header=TRUE, skip=6)%>%subset(Year<2020 & Year>1978)%>%select(c(Year,Earth.s.surface..land.and.ocean.))

#combine data sets
data<-cbind(data1,data2)

shinyServer(function(input, output) {

})
