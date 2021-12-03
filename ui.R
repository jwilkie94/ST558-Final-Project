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
                    containing greenhouse gas emissions.  The models will be used to predict the ghg 
                    (green house gases) per capita based on the other information provided in the data set. 
                    The data used in this shiny app was provided by", 
                  a("Our World in Data",href="https://ourworldindata.org"), 
                  "and contains information regarding greenhouse gas emissions for multiple countries from 
                    1990 to 2016. This data set has been modified from the original to remove any rows that 
                    are missing data to make the predictive modeling process more accurate for the remaining 
                    data. As a result of removing this data, several countries have been omitted.   
                    The original data set along with more information regarding its contents can be found", 
                  a("here.",href="https://ourworldindata.org/co2-and-other-greenhouse-gas-emissions"),
                  "There are multiple tabs to this app.  The Data Exploration page allows the user to create 
                    plots based on selected variables.  The Modeling page allows the user to fit a linear model, 
                    a regression tree, and a random forest model. The Modeling page has three tabs: the Model 
                    Info tab where each type of model is explained; the Model Fitting tab where the chosen model
                    is fitted to the data; and the Prediciton tab where the model is used to predict the response.  
                    The Data page can be used to view and subset the data set and save the data as a csv file."), 
                img(src='GHG image.jpeg')),
                         tabItem(tabName='exploration', h2('exploration')),
                         tabItem(tabName='modeling'),
                                tabItem(tabName='info',h3("The three modeling types that can be fit for this data set using 
                                                          this app are a general linear regression model, a regression tree,
                                                          and a random forest model."),br(), h3("A generalized linear model allows for the use 
                                                          of continuous and categorical predictors like are shown in the data.  The logit function
                                                          links the mean to the linear form of the model. This general model will be performed using
                                                          the poisson regression which has a link funciton of ln(lambdai/exposurei)=B0+B1x1+B2x2+...+Bpxp.",br(),h3("The 
                                                          other model will be fit using a regression tree.  The regression tree method splits the predictor
                                                          space into regions with different predictions for each region.  For each region
                                                          the mean of the observations will be used as prediction."), br(),h3("The random forest model 
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
                                tabItem(tabName='prediction',h3('prediction')))))
)

