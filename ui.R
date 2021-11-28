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

# Create 'About' Page
shinyUI(dashboardPage(
    dashboardHeader(title="About"),
    dashboardSidebar(collapsed=TRUE),
    dashboardBody(p("This app was created to test three surpervised learning models on a data set containing greenhouse gas emissions.  The models will be used to predict the ghg (green house gases) per capita based on the other information provided in the data set. The data used in this shiny app was provided by", a("Our World in Data",href="https://ourworldindata.org"), "and contains information regarding greenhouse gas emissions for multiple countries from 1990 to 2016. This data set has been modified from the original to remove any rows that are missing data to make the predictive modeling process more accurate for the remaining data. As a result of removing this data, several countries have been omitted.   The original data set along with more information regarding its contents can be found", a("here.",href="https://ourworldindata.org/co2-and-other-greenhouse-gas-emissions"),"There are multiple tabs to this app.  The Data Exploration page allows the user to create plots based on selected variables.  The Modeling page allows the user to fit a linear model, a regression tree, and a random forest model. The Modeling page has three tabs: the Model Info tab where each type of model is explained; the Model Fitting tab where the chosen model is fitted to the data; and the Prediciton tab where the model is used to predict the response.  The Data page can be used to view and subset the data set and save the data as a csv file."))
                  ))