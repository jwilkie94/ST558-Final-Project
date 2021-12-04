

library(shiny)
library(tidyverse)
library(caret)

#read in two data sets, remove years from data set 2 that are not captured in the first data set
data1<-read.csv("climate-forcing_fig-1.csv", header=TRUE, skip=6)
data2<-read.csv("temperature_fig-2_0.csv", header=TRUE, skip=6)%>%subset(Year<2020 & Year>1978)%>%select(c(Earth.s.surface..land.and.ocean.))

#combine data sets
dataStart<-cbind(data1,data2)

shinyServer(function(input, output, session) {
  
  #filter data based on input
  getData <- reactive({
   dataStart %>% filter(Year>= input$min & Year<=input$max)
  })
  
  #create a vector of choices to output summary statistic and plot labels
  choiceVec=c('carbon 
            dioxide'='Carbon.dioxide', 
            'methane'='Methane', 'nitrous oxide'
            ='Nitrous.oxide', 'carbon 12'
            ='CFC.12', 'carbon 11'='CFC.11',
            'other gases'='X15.other.gases',
            'surface temperature'='Earth.s.surface..land.and.ocean.')
  
  output$text<-renderText({
    newData<-getData()
    #if scatterplot, produce summary for both variables
    if(input$type=='sp'){
    if(input$summary=='Mean'){
      value<-round(mean(newData[,input$xvar]),4)
      value2<-round(mean(newData[,input$yvar]),4)
      stat<-'mean value'
    }else if(input$summary=='sd'){
      value<-round(sd(newData[,input$xvar]),4)
      value2<-round(sd(newData[,input$yvar]),4)
      stat<-'standard deviation'
    }else if(input$summary=='Sum'){
      value<-round(sum(newData[,input$xvar]),4)
      value2<-round(sum(newData[,input$yvar]),4)
      stat<-'cumulative sum'
    }else if(input$summary=='Median'){
      value<-round(median(newData[,input$xvar]),4)
      value2<-round(median(newData[,input$yvar]),4)
      stat<-'median value'
    }else if(input$summary=='IQR'){
      value<-round(IQR(newData[,input$xvar]),4)
      value2<-round(IQR(newData[,input$yvar]),4)
      stat<-'interquartile range'
    }
    
    paste("The ", stat, " of ", names(choiceVec)[choiceVec==input$xvar], " measured in this data set is ", value[1], " and the ", stat," of ",names(choiceVec)[choiceVec==input$yvar], " measured in this data set is ", value[1],"." )}
    else{
      if(input$summary=='Mean'){
      value<-round(mean(newData[,input$xvar]),4)
      stat<-'mean value'
    }else if(input$summary=='sd'){
      value<-round(sd(newData[,input$xvar]),4)
      stat<-'standard deviation'
    }else if(input$summary=='Sum'){
      value<-round(sum(newData[,input$xvar]),4)
      stat<-'cumulative sum'
    }else if(input$summary=='Median'){
      value<-round(median(newData[,input$xvar]),4)
      stat<-'median value'
    }else if(input$summary=='IQR'){
      value<-round(IQR(newData[,input$xvar]),4)
      stat<-'interquartile range'
    }
      
      paste("The ", stat, " of ", names(choiceVec)[choiceVec==input$xvar], " measured in this data set is ", value[1],".")}
  })
  
  #output correlation if requested
  output$text2<-renderText({if(input$corr){
    newData<-getData()
    x<-as.vector(newData[,input$xvar])
    y<-as.vector(newData[,input$yvar])
    correlation<-round(cor(x,y),4)
    paste("The correlation between ", names(choiceVec)[choiceVec==input$xvar], " and ", names(choiceVec)[choiceVec==input$yvar], " is ", correlation)
  }
  })
  
 output$plot<-renderPlot({
   newData<-getData()
   #create base for plots
   g<-ggplot(newData, aes_string(x =input$xvar))
   #create base for scatter plot
   g2<-ggplot(newData, aes_string(x = input$xvar, y = input$yvar))
   
#create selected plot
  if(input$type == 'Histogram'){
    if(input$xvar=='Carbon.dioxide'||input$xvar=='Earth.s.surface..land.and.ocean.'){
      g + geom_histogram(binwidth = .1, bins=10)+labs(x=names(choiceVec)[choiceVec==input$xvar])
      }else{
    g + geom_histogram(binwidth = .01, bins=10)}+labs(x=names(choiceVec)[choiceVec==input$xvar])
  }else if (input$type=='dp') {
    g + geom_density(kernel='gaussian', adjust=0.25,alpha=.05)+labs(x=names(choiceVec)[choiceVec==input$xvar])
  }else if (input$type=='bp'){
    g+geom_boxplot()+labs(names(choiceVec)[choiceVec==input$xvar])
  }else{
    #create plots depending on if year is selected
      if(input$yr){
        g2+geom_point(position="jitter")+labs(x=names(choiceVec)[choiceVec==input$xvar], y=names(choiceVec)[choiceVec==input$yvar])+geom_text(aes(label=Year))
      }
    else{g2+geom_point(position="jitter")+labs(x=names(choiceVec)[choiceVec==input$xvar], y=names(choiceVec)[choiceVec==input$yvar])}
    }
 }) 
})

