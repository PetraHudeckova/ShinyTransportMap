Transport Map
========================================================
author: Petra Hudeckova
date: 23 April 2017
autosize: false

Introduction
========================================================

This is a presentation about Peer-graded Assignment: Course Project: Shiny Application and Reproducible Pitch.
My application shows global transport points around the world. User can choose
- country in which locations are from
- type of location (airport, (train) station, ports)
- optional table output with all locations

About application
========================================================
Used technogies
- shiny package 
- data.table package for storing and fast searching data
- leaflet package to show map with locations

Source files: https://github.com/PetraHudeckova/ShinyTransportMap

Application url: https://petrahudeckova.shinyapps.io/AirportsByCountry/

About data
========================================================
  Data is from [http://openflights.org/data.html].

```r
library(data.table)
colNames <- c("Airport ID", "name", "city", "country", "lat", "lng", "type")
colSelect <- c(1:4,7,8,13)
data <- fread("airports.csv", header = FALSE, col.names = colNames, select = colSelect, encoding = 'UTF-8')
data[, lat := as.numeric(lat)]
data[, lng := as.numeric(lng)]
str(data)
```

```
Classes 'data.table' and 'data.frame':	10668 obs. of  7 variables:
 $ Airport ID: int  1 2 3 4 5 6 7 8 9 10 ...
 $ name      : chr  "Goroka Airport" "Madang Airport" "Mount Hagen Kagamuga Airport" "Nadzab Airport" ...
 $ city      : chr  "Goroka" "Madang" "Mount Hagen" "Nadzab" ...
 $ country   : chr  "Papua New Guinea" "Papua New Guinea" "Papua New Guinea" "Papua New Guinea" ...
 $ lat       : num  -6.08 -5.21 -5.83 -6.57 -9.44 ...
 $ lng       : num  145 146 144 147 147 ...
 $ type      : chr  "airport" "airport" "airport" "airport" ...
 - attr(*, ".internal.selfref")=<externalptr> 
```

Thanks
========================================================

