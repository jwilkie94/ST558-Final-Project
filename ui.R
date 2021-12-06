#
# This is the user - interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)


# Create Dashboard Page
shinyUI(dashboardPage(
  dashboardHeader(title = "ST558 Final Project"),
  dashboardSidebar(sidebarMenu(
    menuItem('About', tabName = 'about'),
    menuItem('Data Exploration', tabName = 'exploration'),
    menuItem(
      'Modeling',
      tabName = 'modeling',
      menuSubItem('Modeling Info', tabName =
                    'info'),
      menuSubItem('Model Fitting', tabName =
                    'fitting'),
      menuSubItem('Prediction', tabName =
                    'prediction')
    ),
    menuItem('Data', tabName = 'data')
  )),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = 'about',
        p(
          "This app was created to test three surpervised learning models on a data set containing greenhouse gas emissions and US surface temperature data. The models will be
          used to predict the US surface temperature change resulting from the greenhouse gas emission measurements.  The data used in this shiny app was provided by the",
          a("US EPA",
            href = "https://ourworldindata.org"),
          "and contains information regarding global greenhouse gas emissions and climate change in the US from 1979 to 2019. The photo pictured below is the US EPA logo.  The data was
          sourced from two data sets and combined.  Only the surface temperature data was used from the second data set, all other measurements came from the first data stet. The original 
          data sets along with more information regarding their contents can be found",
          a("here.", href = "https://www.epa.gov/climate-indicators/climate-change-indicators-climate-forcing"),
          "and",
          a("here", href = "https://www.epa.gov/climate-indicators/climate-change-indicators-us-and-global-temperature"),
          br(),br(),
          "There are multiple pages to this app.  The Data Exploration page allows the user to create different plots containing selected variables and to view some summary statistics.  
          The Modeling page has three tabs:
          The Model Info tab, where each type of model is explained, and some benefits and drawbacks of each are listed, the Model Fitting tab, where the data can be split into training
          and test sets based on user input, predictors can be chosen for each model, and the models will be trained and tested (the RMSE, R2, and MAE values will be reported along with
          some summary information for each model in the Model Fitting Tab), and the Prediciton tab where a linear model can be used to predict surface temperature based on inputs for
          the other variables in the data set. The Data page can be used to view and subset the data set and save the data as a csv file."
        ),
        br(),
        img(
          src = "photo.png",
          align = 'center',
          height = '400px',
          width = '500px'
        )
      ),
      tabItem(
        tabName = 'exploration',
        radioButtons(
          "summary",
          "Summary Statistic",
          choices = c('Mean', 'Standard Deviation' = 'sd', 'Sum', 'Median', 'IQR'),
          inline = TRUE
        ),
        
        selectInput(
          'type',
          'Plot Type',
          choices = c(
            'Histogram',
            'Density Plot' = 'dp',
            'Boxplot' = 'bp',
            'Scatter Plot' = 'sp'
          )
        ),
        selectInput(
          'xvar',
          'X-axis Variable',
          choices = c(
            'Carbon Dioxide' = 'Carbon.dioxide',
            'Methane',
            'Nitrous Oxide' = 'Nitrous.oxide',
            'Carbon 12' = 'CFC.12',
            'Carbon 11' = 'CFC.11',
            'Other Gases' = 'X15.other.gases',
            'Surface Temperature' = 'Earth.s.surface..land.and.ocean.'
          )
        ),
        conditionalPanel(
          "input.type=='sp'",
          selectInput(
            "yvar",
            'Y-axis Variable',
            choices = c(
              'Carbon Dioxide' = 'Carbon.dioxide',
              'Methane',
              'Nitrous Oxide' = 'Nitrous.oxide',
              'Carbon 12' = 'CFC.12',
              'Carbon 11' = 'CFC.11',
              'Other Gases' = 'X15.other.gases',
              'Surface Temperature' = 'Earth.s.surface..land.and.ocean.'
            )
          ),
          checkboxInput('corr', 'Show Correlation?'),
          checkboxInput('yr', 'Show Year?')
        ),
        numericInput('min', 'Choose Starting Year (1979-2019)', value =
                       1979),
        numericInput('max', 'Choose Ending Year (1979-2019)', value = 2019),
        textOutput("text"),
        textOutput("text2"),
        plotOutput("plot")
      ),
      tabItem(tabName = 'modeling'),
      tabItem(
        tabName = 'info',
        h4(
          "The three modeling types that can be fit for this data set using this app are a multiple linear regression model, a regression tree, and a random forest model."
        ),
        br(),
        h4(
          "A multiple linear model takes the form",
          withMathJax(),
          helpText('$$response=B_0+B_1*x_1+B_2*x_2+...+B_p*x_p$$'),
          "Where x represents the value of the variable and B represents
          the change in the value of the response for each unit of the variable. Another model will be fit using a regression tree. The regression tree method splits the predictor
          space into regions with different predictions for each region. For each region the mean of the observations will be used as prediction.  A final model will be fit using
          random forest.  The random forest model will create multiple trees from bootstrap samples and average the results.  Each tree uses a random subset of predictors for the
          model fit."
        ),
        br(),
        h4(
          "There are benefits and drawbacks to each model.  A  linear model is simple and easy to interpret, but requires some assumptions. The user must assume that the response
            can take on any value on a line, which is not always the case. Regression trees are simple to understand and interpret, no statistical assumptions are necessary, there
            is built in variable selection, and predictors don't need to be scaled.  On the downside, even small data changes can drastically change the tree and they usually need
            to be pruned.  A random forest model reduces the variance over an individual tree fit and is useful for looking at variable importance, but the model loses some
            interpretability result."
        )
      )
      ,
      tabItem(
        tabName = 'fitting',
        h4(
          'Choose parameters to train and test a multiple linear regression model, and regression tree, and a random forest model for the data.  Click the button to output fit statistics.  
          The summary statistics will be displayed for the linear model and regression tree.  A plot of RMSE values will be displayed for the random forest model.'
        ),
        numericInput(
          'train',
          'Proportion of data to be used for training data set:',
          value = 0.8,
          min = .1,
          max = .9,
          step = .05
        ),
        checkboxGroupInput(
          'preds',
          "Choose Predictors",
          choices = c(
            'Year',
            'Carbon Dioxide' = 'Carbon.dioxide',
            'Methane',
            'Nitrous Oxide' = 'Nitrous.oxide',
            'Carbon 12' = 'CFC.12',
            'Carbon 11' = 'CFC.11',
            'Other Gases' = 'X15.other.gases'
          )
        ),
        actionButton('create', 'Get Fit Statistics'),
        tableOutput('fits'),
        verbatimTextOutput("summaryLinear"),
        verbatimTextOutput("summaryTree"),
        plotOutput("plot2")
      ),
      tabItem(
        tabName = 'prediction',
        h3(
          "Enter variable values to predict the surface temperature using the linear model that was trained on the previous tab."
        ),
        numericInput('Year', 'Year', value = 0),
        numericInput('co2', 'Carbon Dioxide', value = 0),
        numericInput('Methane', 'Methane', value = 0),
        numericInput('no2', 'Nitrous Oxide', value = 0),
        numericInput('c12', 'Carbon 12', value = 0),
        numericInput('c11', 'Carbon 11', value = 0),
        numericInput('other', 'Other Gases', value = 0),
        h5("Predicted surface temperature (Celsius):"),
        verbatimTextOutput("prediction")
      ),
      tabItem(
        tabName = 'data',
        h4('Use the options below to subset the dataset:'),
        h5('Select range of years:'),
        numericInput('start', 'From', value = 1979),
        numericInput('end', 'To', value = 2019),
        br(),
        h5("Choose variables to display:"),
        checkboxGroupInput(
          'cols',
          'Variable:',
          choices = c(
            'Year',
            'Carbon Dioxide' = 'Carbon.dioxide',
            'Methane',
            'Nitrous Oxide' = 'Nitrous.oxide',
            'Carbon 12' = 'CFC.12',
            'Carbon 11' = 'CFC.11',
            'Other Gases' = 'X15.other.gases',
            'Surface Temperature' = 'Earth.s.surface..land.and.ocean.'
          ),
          selected =
            c(
              'Year',
              'Carbon.dioxide',
              'Methane',
              'Nitrous.oxide',
              'CFC.12',
              'CFC.11',
              'X15.other.gases',
              'Earth.s.surface..land.and.ocean.'
            )
        ),
        br(),
        textInput('file', 'Enter a filename here to save dataset as csv:'),
        actionButton('save', 'Save as CSV'),
        tableOutput("data")
      )
    )
  )
))
