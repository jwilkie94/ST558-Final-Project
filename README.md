# ST558-Final-Project

## App Purpose

This app was created to perform exploratory data analysis on a data set and compare three surpervised learning models through fit statistics to find the best model.  The data used in this shiny app was provided by the [US EPA](https://www.epa.gov/) and contains information regarding greenhouse gas emissions and surface temperature changes from 1979 to 2019 in the US. This data was sourced from two data sets and combined for this project.  The original data sets along with more information regarding their contents can be found [here](https://www.epa.gov/climate-indicators/climate-change-indicators-climate-forcing) and [here](https://www.epa.gov/climate-indicators/climate-change-indicators-us-and-global-temperature).  

The image used in the "About" page is the US EPA logo.

## Packages

The packages needed to run this app are the **shiny**, **shinydashboard**, **caret**, **randomForest**, and **tidyverse** packages.  This code can be used to install all packages necessary for this project:  **install.packages(c("shiny", "shinydashboard", "caret", "randomForest","tidyverse"))**

# Code Needed to Run App

This app can be initialized by running the following code: **shiny::runGitHub("ST558-Final-Project", "jwilkie94", ref="main")**
