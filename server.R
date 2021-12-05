


library(shiny)
library(tidyverse)
library(caret)
library(randomForest)

#read in two data sets, remove the years from data set 2 that are not captured in the first data set.  Only keep surface temperature column from second data set.

data1 <- read.csv("climate-forcing_fig-1.csv",
                  header = TRUE,
                  skip = 6)
data2 <-
  read.csv("temperature_fig-2_0.csv",
           header = TRUE,
           skip = 6) %>% subset(Year < 2020 &
                                  Year > 1978) %>% select(c(Earth.s.surface..land.and.ocean.))

#combine data sets
startData <- cbind(data1, data2)

shinyServer(function(input, output, session) {
  #filter data based on input for exploration page
  getData <- reactive({
    startData %>% filter(Year >= input$min & Year <= input$max)
  })
  
  #filter data based on input for data page
  getData2 <- reactive({
    startData %>% filter(Year >= input$start &
                           Year <= input$end) %>% select(input$cols)
  })
  
  #filter data for model training based on choices from modeling page
  getData3 <-
    reactive({
      startData %>% select(input$preds, Earth.s.surface..land.and.ocean.)
    })
  
  #create a vector of choices to output summary statistic and plot labels
  choiceVec = c(
    'carbon dioxide' = 'Carbon.dioxide',
    'methane' = 'Methane',
    'nitrous oxide' = 'Nitrous.oxide',
    'carbon 12' = 'CFC.12',
    'carbon 11' = 'CFC.11',
    'other gases' = 'X15.other.gases',
    'surface temperature' = 'Earth.s.surface..land.and.ocean.'
  )
  
  output$text <- renderText({
    newData <- getData()
    #if scatterplot, produce summary for both variables
    if (input$type == 'sp') {
      if (input$summary == 'Mean') {
        value <- round(mean(newData[, input$xvar]), 4)
        value2 <- round(mean(newData[, input$yvar]), 4)
        stat <- 'mean value'
      } else if (input$summary == 'sd') {
        value <- round(sd(newData[, input$xvar]), 4)
        value2 <- round(sd(newData[, input$yvar]), 4)
        stat <- 'standard deviation'
      } else if (input$summary == 'Sum') {
        value <- round(sum(newData[, input$xvar]), 4)
        value2 <- round(sum(newData[, input$yvar]), 4)
        stat <- 'cumulative sum'
      } else if (input$summary == 'Median') {
        value <- round(median(newData[, input$xvar]), 4)
        value2 <- round(median(newData[, input$yvar]), 4)
        stat <- 'median value'
      } else if (input$summary == 'IQR') {
        value <- round(IQR(newData[, input$xvar]), 4)
        value2 <- round(IQR(newData[, input$yvar]), 4)
        stat <- 'interquartile range'
      }
      
      paste(
        "The ",
        stat,
        " of ",
        names(choiceVec)[choiceVec == input$xvar],
        " measured in this data set is ",
        value[1],
        " and the ",
        stat,
        " of ",
        names(choiceVec)[choiceVec == input$yvar],
        " measured in this data set is ",
        value[1],
        "."
      )
    }
    else{
      if (input$summary == 'Mean') {
        value <- round(mean(newData[, input$xvar]), 4)
        stat <- 'mean value'
      } else if (input$summary == 'sd') {
        value <- round(sd(newData[, input$xvar]), 4)
        stat <- 'standard deviation'
      } else if (input$summary == 'Sum') {
        value <- round(sum(newData[, input$xvar]), 4)
        stat <- 'cumulative sum'
      } else if (input$summary == 'Median') {
        value <- round(median(newData[, input$xvar]), 4)
        stat <- 'median value'
      } else if (input$summary == 'IQR') {
        value <- round(IQR(newData[, input$xvar]), 4)
        stat <- 'interquartile range'
      }
      
      paste("The ",
            stat,
            " of ",
            names(choiceVec)[choiceVec == input$xvar],
            " measured in this data set is ",
            value[1],
            ".")
    }
  })
  
  #output correlation if requested
  output$text2 <- renderText({
    if (input$corr) {
      newData <- getData()
      x <- as.vector(newData[, input$xvar])
      y <- as.vector(newData[, input$yvar])
      correlation <- round(cor(x, y), 4)
      paste(
        "The correlation between ",
        names(choiceVec)[choiceVec == input$xvar],
        " and ",
        names(choiceVec)[choiceVec == input$yvar],
        " is ",
        correlation,
        "."
      )
    }
  })
  
  #create plot output for exploration page
  output$plot <- renderPlot({
    newData <- getData()
    #create base for plots
    g <- ggplot(newData, aes_string(x = input$xvar))
    #create base for scatter plot
    g2 <-
      ggplot(newData, aes_string(x = input$xvar, y = input$yvar))
    
    #create selected plot
    if (input$type == 'Histogram') {
      if (input$xvar == 'Carbon.dioxide' ||
          input$xvar == 'Earth.s.surface..land.and.ocean.') {
        g + geom_histogram(binwidth = .1, bins = 10) + labs(x = names(choiceVec)[choiceVec ==
                                                                                   input$xvar])
      } else{
        g + geom_histogram(binwidth = .01, bins = 10)
      } + labs(x = names(choiceVec)[choiceVec == input$xvar])
    } else if (input$type == 'dp') {
      g + geom_density(kernel = 'gaussian',
                       adjust = 0.25,
                       alpha = .05) + labs(x = names(choiceVec)[choiceVec == input$xvar])
    } else if (input$type == 'bp') {
      g + geom_boxplot() + labs(names(choiceVec)[choiceVec == input$xvar])
    } else{
      #create plots depending on if year is selected
      if (input$yr) {
        g2 + geom_point(position = "jitter") + labs(x = names(choiceVec)[choiceVec ==
                                                                           input$xvar], y = names(choiceVec)[choiceVec == input$yvar]) + geom_text(aes(label =
                                                                                                                                                         Year))
      }
      else{
        g2 + geom_point(position = "jitter") + labs(x = names(choiceVec)[choiceVec ==
                                                                           input$xvar], y = names(choiceVec)[choiceVec == input$yvar])
      }
    }
  })
  
  table <- eventReactive(input$create, {
    newData <- getData3()
    if (is.null(input$preds)) {
      return()
    }
    train_index <-
      createDataPartition(
        newData$Earth.s.surface..land.and.ocean.,
        p = input$train,
        list = FALSE
      )
    training <- newData[train_index, ]
    test <- newData[-train_index, ]
    #create output for modeling page
    linearFit <- train(
      Earth.s.surface..land.and.ocean. ~ .,
      data = training,
      method = "lm",
      trControl = trainControl(method = "cv", number = 5),
      preProcess = c("center", "scale")
    )
    treeFit <- train(
      Earth.s.surface..land.and.ocean. ~ .,
      data = training,
      method = "rpart",
      trControl = trainControl(method = "cv", number = 5),
      preProcess = c("center", "scale"),
      tuneGrid = data.frame(cp = seq(
        from = 0, to = 0.1, by = 0.001
      ))
    )
    rfFit <-
      train(
        Earth.s.surface..land.and.ocean. ~ .,
        data = training,
        method = "rf",
        trControl = trainControl(method = "cv", number = 5),
        preProcess = c("center", "scale"),
        tuneGrid = data.frame(mtry = (1:(ncol(
          training
        ))))
      )
    
    
    #predict using test sets
    linearPred <- predict(linearFit, test)
    treePred <- predict(treeFit, test)
    rfPred <- predict(rfFit, test)
    
    #return best model from each prediction
    linear <-
      postResample(linearPred, test$Earth.s.surface..land.and.ocean.)
    tree <-
      postResample(treePred, test$Earth.s.surface..land.and.ocean.)
    rf <-
      postResample(rfFit$bestTune, test$Earth.s.surface..land.and.ocean.)
    
    result <-
      data.frame(
        "Model" = c(
          "Linear Model Train",
          "Regression Tree Model Train",
          "Random Forest Model Train"
        ),
        "RMSE" = c(linearFit$results[1, 2], treeFit$results[1, 2], rfFit$results[rfFit$bestTune$mtry, 2]),
        "Rsquared" = c(linearFit$results[1, 3], treeFit$results[1, 3], rfFit$results[rfFit$bestTune$mtry, 3]),
        "MAE" = c(linearFit$results[1, 4], treeFit$results[1, 4], rfFit$results[rfFit$bestTune$mtry, 4])
      )
    
    result2 <-
      data.frame(
        "Model" = c(
          "Linear Model Test",
          "Regression Tree Model Test",
          "Random Forest Model Test"
        ),
        "RMSE" = c(linear[1], tree[1], rf[1]),
        "Rsquared" = c(linear[2], tree[2], rf[2]),
        "MAE" = c(linear[3], tree[3], rf[3])
      )
    result3 <- rbind(result, result2)
    
    
    summaryLinear <- summary(linearFit)
    summaryTree <- summary(treeFit)
    list(result3, summaryLinear, summaryTree, rfFit, linearFit)
    
  })
  
  #output results from linear model fitting and summary statistics
  output$fits <- renderTable({
    modelOut <- table()
    modelOut[[1]]
  })
  
  output$summaryLinear <- renderPrint({
    modelOut <- table()
    modelOut[[2]]
  })
  
  output$summaryTree <- renderPrint({
    modelOut <- table()
    modelOut[[3]]
  })
  
  output$plot2 <- renderPlot({
    modelOut <- table()
    plot.train(modelOut[[4]])
  })
  
  
  #create data frame of input predictions
  
  predictData <- reactive({
    data.frame(
      Year = input$Year,
      Carbon.dioxide = input$co2,
      Methane = input$Methane,
      Nitrous.oxide = input$no2,
      CFC.12 = input$c12,
      CFC.11 = input$c11,
      X15.other.gases = input$other
    )
  })
  
  #create output for prediction tab
  output$prediction <- renderText({
    model <- lm(Earth.s.surface..land.and.ocean. ~ ., data = startData)
    newData2 <- predictData()
    result <- predict(model, newdata = newData2)
    result
    
  })
  
  
  #create table output for data page
  output$data <- renderTable({
    table <- getData2()
  })
  
  
  observeEvent(input$save, {
    write.csv(getData2(), paste0(input$file, ".csv"))
  })
})
