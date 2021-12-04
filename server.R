

library(shiny)
library(tidyverse)
library(caret)

#read in two data sets, remove years from data set 2 that are not captured in the first data set
data1<-read.csv("climate-forcing_fig-1.csv", header=TRUE, skip=6)
data2<-read.csv("temperature_fig-2_0.csv", header=TRUE, skip=6)%>%subset(Year<2020 & Year>1978)%>%select(c(Earth.s.surface..land.and.ocean.))

#combine data sets
data<-cbind(data1,data2)

shinyServer(function(input, output, session) {
  
  #filter data based on input
  getData <- reactive({
    newData <- data %>% filter(Year>= input$min & Year<=input$max)
  })
  
 
  

 output$plot<-renderPlot({
   newData<-getData()
   #create base for plots
   g<-reactive({ggplot(getData, aes(x =input$xvar))})
   #create base for scatter plot
   g2<-reactive({ggplot(getData, aes(x = input$xvar, y = input$yvar))})
   
#create selected plot
  if(input$type == 'Histogram'){
    g + geom_histogram(binwidth = .1, bins=10)
  }else if (input$type=='dp') {
    g + geom_density(kernel='gaussian', adjust=0.25,alpha=.05)
  }else if (input$type=='bp'){
    g+geom_boxplot()
  }else{
    g2+geom_point(position="jitter")
  }
 }) 
})

