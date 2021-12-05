#
# This is the user-interface definition of a Shiny web application. You can
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
  dashboardHeader(title="ST558 Final Project"),
  dashboardSidebar(sidebarMenu(menuItem('About', tabName='about'),
                               menuItem('Data Exploration', tabName='exploration'),
                               menuItem('Modeling',tabName='modeling',
                                        menuSubItem('Modeling Info', tabName='info'),
                                        menuSubItem('Model Fitting', tabName='fitting'),
                                        menuSubItem('Prediction', tabName='prediction')),
                               menuItem('Data', tabName='data'))),
  dashboardBody(tabItems(tabItem(tabName='about',p("This app was created to test three surpervised learning models on a data set 
                    containing greenhouse gas emissions and us surface temperature data.  
                    The models will be used to predict the US surface temperature change from the greenhouse gas emission measurements. 
                    The data used in this shiny app was provided by the", 
                  a("US EPA",href="https://ourworldindata.org"), 
                  "and contains information regarding global greenhouse gas emissions and climate change in the US from 1979 to 2019. The data
                  was sourced from two data sets and combined.  Only the surface temperature data was used from the second data set.
                    The original data sets along with more information regarding their contents can be found", 
                  a("here.",href="https://www.epa.gov/climate-indicators/climate-change-indicators-climate-forcing"), "and"
                  ,a("here", href="https://www.epa.gov/climate-indicators/climate-change-indicators-us-and-global-temperature"),
                  "There are multiple pages to this app.",br(),  "The Data Exploration page allows the user to create 
                    plots based on selected variables.  The Modeling page allows the user to fit a linear model, 
                    a regression tree, and a random forest model. The Modeling page has three tabs: the Model 
                    Info tab where each type of model is explained; the Model Fitting tab where the chosen model
                    is fitted to the data; and the Prediciton tab where the model is used to predict the response.  
                    The Data page can be used to view and subset the data set and save the data as a csv file."), br(),
                img(src="photo.png", align= 'center',height='400px', width='400px')),
                         tabItem(tabName='exploration', radioButtons("summary", "Summary Statistic", choices=c('Mean', 
                                                                                                                'Standard Deviation'='sd',
                                                                                                                'Sum', 'Median', 'IQR'), inline=TRUE),
                                                        selectInput('type', 'Plot Type',choices = c('Histogram','Density Plot'='dp', 
                                                                                                    'Boxplot'='bp',
                                                                                                    'Scatter Plot'='sp')), 
                                                        selectInput('xvar', 'X-axis Variable', choices=c('Carbon 
                                                                                                         Dioxide'='Carbon.dioxide', 
                                                                                                         'Methane', 'Nitrous Oxide'
                                                                                                         ='Nitrous.oxide', 'Carbon 12'
                                                                                                         ='CFC.12', 'Carbon 11'='CFC.11',
                                                                                                         'Other Gases'='X15.other.gases',
                                                                                                         'Surface Temperature'='Earth.s.surface..land.and.ocean.')), 
                                                      conditionalPanel("input.type=='sp'",selectInput("yvar", 'Y-axis Variable', choices=c('Carbon 
                                                                                              Dioxide'='Carbon.dioxide', 
                                                                                              'Methane', 'Nitrous Oxide'
                                                                                               ='Nitrous.oxide', 'Carbon 12'
                                                                                              ='CFC.12', 'Carbon 11'='CFC.11',
                                                                                              'Other Gases'='X15.other.gases',
                                                                                              'Surface Temperature'='Earth.s.surface..land.and.ocean.')),
                                                                                           checkboxInput('corr', 'Show Correlation?'), 
                                                                                            checkboxInput('yr', 'Show Year?')),
                                                      numericInput('min', 'Choose Starting Year (1979-2019)', value=1979), 
                                                      numericInput('max', 'Choose Ending Year (1979-2019)', value=2019), textOutput("text"),textOutput("text2"),
                                                      plotOutput("plot")),
                         tabItem(tabName='modeling'),
                                tabItem(tabName='info',h4("The three modeling types that can be fit for this data set using 
                                                          this app are a multiple linear regression model, a regression tree,
                                                          and a random forest model."),br(), h4("A multiple linear model takes the formB0+B1x1+B2x2+...+Bpxp.  
                                                          Where x represents the value of the variable and B represents the change in the value of the response
                                                          for each unit of the variable.",br(),h4("The other model will be fit using a regression tree.  
                                                          The regression tree method splits the predictor space into regions with different predictions for each region.  
                                                          For each region the mean of the observations will be used as prediction."), br(),h4("The random forest model 
                                                          will create multiple trees from bootstrap samples and average the results.  Each tree uses a 
                                                          random subset of predictors for each tree fit."), br(), h4("There are benefits and drawbacks 
                                                          to each model.  A  linear model is simple and easy to interpret, but requires some assumptions.  
                                                          The user must assume that the response can take on any value on a line, which is not always the case.
                                                          , but poisson models are prone to deviance and overdispersion where the observed variance is higher
                                                          than the theoretical variance. Regression trees are simple to understand and interpret,
                                                          no statistical assumptions are necessary, there is built in variable selection, and predictors don't
                                                          need to be scaled.  On the downside, even small data changes can drastically change the tree and they 
                                                          usually need to be pruned.  A random forest model reduces the variance over an individual tree fit and is 
                                                          useful for looking at variable importance, but the model loses some interpretability result."))),
                                tabItem(tabName='fitting',h4('Choose parameters to train and test a multiple linear regression model, and regression tree, and a random forest model for the data.  Click the button to output fit statistics.'),
                                                          numericInput('train', 'Proportion of data to be used for training data set:', value=0.8, min=.1, max=.9, step=.05),
                                                           checkboxGroupInput('preds',"Choose Predictors", choices=c('Year','Carbon 
                                                                                                                      Dioxide'='Carbon.dioxide', 
                                                                                                                      'Methane', 'Nitrous Oxide'
                                                                                                                       ='Nitrous.oxide', 'Carbon 12'
                                                                                                                       ='CFC.12', 'Carbon 11'='CFC.11',
                                                                                                                       'Other Gases'='X15.other.gases')), actionButton('create', 'Get Fit Statistics'),tableOutput('fits')),
                                tabItem(tabName='prediction',h3('prediction')),
                                tabItem(tabName='data', h4('Use the options below to subset the dataset:'),h5('Select range of years:'), numericInput('start', 'From', value=1979), 
                                           numericInput('end', 'To', value=2019), br(),h5("Choose variables to display:"), checkboxGroupInput('cols', 'Variable:', choices=c('Year','Carbon 
                                                                                                                                                                  Dioxide'='Carbon.dioxide', 
                                                                                                                                                                  'Methane', 'Nitrous Oxide'
                                                                                                                                                                  ='Nitrous.oxide', 'Carbon 12'
                                                                                                                                                                  ='CFC.12', 'Carbon 11'='CFC.11',
                                                                                                                                                                  'Other Gases'='X15.other.gases',
                                                                                                                                                                  'Surface Temperature'='Earth.s.surface..land.and.ocean.'),
                                                                                                                                             selected=c('Year', 'Carbon.dioxide','Methane', 'Nitrous.oxide','CFC.12', 'CFC.11', 
                                                                                                                                                        'X15.other.gases','Earth.s.surface..land.and.ocean.')),
                                          br(),textInput('file','Enter a filename here to save dataset as csv:'),actionButton('save','Save as CSV'),tableOutput("data"))))
))

