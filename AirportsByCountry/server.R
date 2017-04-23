#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(data.table)

shinyServer(function(input, output) {
  
  if (! file.exists("airports.csv")) {
    download.file("https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports-extended.dat", destfile = "airports.csv")
  }
  colNames <- c("Airport ID", "name", "city", "country", "lat", "lng", "type")
  colSelect <- c(1:4,7,8,13)
  data <- fread("airports.csv", header = FALSE, col.names = colNames, select = colSelect, encoding = 'UTF-8')
  data[, lat := as.numeric(lat)]
  data[, lng := as.numeric(lng)]
  setkey(data, country, type)

  # selected country
  selectedCountry <- reactive({
    input$selectedCountry
  })
  
  # selected type
  selectedType <- reactive({
    input$selectedType
  })
  
  # type selector for ui.R
  typeNames <- c("all types", sort(unique(data[,type])))
  output$typeSelector <- renderUI({
    radioButtons("selectedType", "Select type", as.list(typeNames))
  })
  
  # country selector for ui.R
  countryNames <- c("All countries", unique(data[,country]))
  output$countrySelector <- renderUI({
    selectInput("selectedCountry", "Select country:", as.list(countryNames)) 
  })
  
  # data used for further computation and map
  # takes data from selectedCountry() and selectedType()
  usedData <- reactive({
    countryNullOrAll <- selectedCountry() == "All countries" || is.null(selectedCountry())
    typeNullOrAll <- selectedType() == "all types" || is.null(selectedType())
    
    if (countryNullOrAll && typeNullOrAll){
      data
    } else if (countryNullOrAll){
      data[.(unique(country), selectedType())]
    } else if (typeNullOrAll) {
      data[.(selectedCountry())]
    } else {
      data[.(selectedCountry(), selectedType())]
    }
  })
  
  # leaflet map with locations
  mapPlot <- reactive({
    usedData() %>%
      leaflet() %>%
      addTiles() %>%
      addMarkers(popup=usedData()$name, lng=~lng, lat=~lat, clusterOptions = markerClusterOptions())
  })
  output$mapPlot <- renderLeaflet({
    mapPlot()
  })
  
  output$country <- renderText({
    selectedCountry()
  })
  
  output$numberOfAirports <- renderText({
    paste("Number of shown locations: ", nrow(usedData()))
  })
  
  output$locationHeader<- renderText({
    if (input$showTable){
      c("Locations")
    }
  })
  
  # show data table
  output$table <- renderDataTable({
    if (input$showTable) {
      usedData()[, .(city, name, country, type) ]
    }
  })
  
})
