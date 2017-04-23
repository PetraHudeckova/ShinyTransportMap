#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      uiOutput("countrySelector"),
      uiOutput("typeSelector"),
      checkboxInput("showTable", "Show in table")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel(
         "Output",
         h3(textOutput("country")),
         textOutput("numberOfAirports"),
         leafletOutput("mapPlot", height = 500, width = 700),
         h3(textOutput("locationHeader")),
         dataTableOutput("table")
        ),
        tabPanel(
          "About/help",
          includeMarkdown("documentation.md")
        )
      )
    )
  )
))
