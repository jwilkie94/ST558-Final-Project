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
                               menuItem('Data'))),
  dashboardBody(tabItems(tabItem(tabName='about',p("This app was created to test three surpervised learning models on a data set 
                    containing greenhouse gas emissions.  The models will be used to predict the US surface temperature change
                    from the greenhouse gas emissions. 
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
                    The Data page can be used to view and subset the data set and save the data as a csv file."), 
                img(src='climate-forcing_figure1_2021.png')),
                         tabItem(tabName='exploration', checkboxGroupInput("summary", "Summary Statistic", choices=c('Mean', 
                                                                                                                'Standard Deviation'='sd',
                                                                                                                'Sum', 'Median', 'IQR')),
                                                        selectInput('type', 'Plot Type',choices = c('Histogram','Density Plot'='dp', 
                                                                                                    'Boxplot'='bp',
                                                                                                    'Scatter Plot'='sp')), 
                                                        selectInput('xvar', 'X-axis Variable', choices=c('Carbon 
                                                                                                         Dioxide'='Carbon.dioxide', 
                                                                                                         'Methane', 'Nitrous Oxide'
                                                                                                         ='Nitrous.oxide', 'Carbon 12'
                                                                                                         ='CFC.12', 'Carbon 11'='CFC.11',
                                                                                                         'Other Gases'='X.15.other.gases',
                                                                                                         'Surface Temperature'='Earth.s.surface..and.land.ocean.')), 
                                                      conditionalPanel("input.type=='sp'",selectInput("yvar", 'Y-axis Variable', choices=c('Carbon 
                                                                                              Dioxide'='Carbon.dioxide', 
                                                                                              'Methane', 'Nitrous Oxide'
                                                                                               ='Nitrous.oxide', 'Carbon 12'
                                                                                              ='CFC.12', 'Carbon 11'='CFC.11',
                                                                                              'Other Gases'='X.15.other.gases',
                                                                                              'Surface Temperature'='Earth.s.surface..and.land.ocean.'))),
                                                      numericInput('min', 'Choose Starting Year (1979-2019)', value=1979), 
                                                      numericInput('max', 'Choose Ending Year (1979-2019)', value=2019),
                                                      plotOutput("plot"), tableOutput("table")),
                         tabItem(tabName='modeling'),
                                tabItem(tabName='info',h3("The three modeling types that can be fit for this data set using 
                                                          this app are a multiple linear regression model, a regression tree,
                                                          and a random forest model."),br(), h3("A multiple linear model takes the formB0+B1x1+B2x2+...+Bpxp.  
                                                          Where x represents the value of the variable and B represents the change in the value of the response
                                                          for each unit of the variable.",br(),h3("The other model will be fit using a regression tree.  
                                                          The regression tree method splits the predictor space into regions with different predictions for each region.  
                                                          For each region the mean of the observations will be used as prediction."), br(),h3("The random forest model 
                                                          will create multiple trees from bootstrap samples and average the results.  Each tree uses a 
                                                          random subset of predictors for each tree fit."), br(), h3("There are benefits and drawbacks 
                                                          to each model.  A generaized linear model allows for both continuous and categorical predictors.
                                                          , but poisson models are prone to deviance and overdispersion where the observed variance is higher
                                                          than the theoretical variance. Regression trees are simple to understand and interpret,
                                                          no statistical assumptions are necessary, there is built in variable selection, and predictors don't
                                                          need to be scaled.  On the downside, even small data changes can drastically change the tree and they 
                                                          usually need to be pruned.  A random forest model reduces the variance over an individual tree fit and is 
                                                          useful for looking at variable importance, but the model loses some interpretability result."))),
                                tabItem(tabName='fitting',h2('fitting')),
                                tabItem(tabName='prediction',h3('prediction')),
                tabItem(tabName='data', h2('data')))
)))

