
library(dplyr)
library(leaflet)

dd <- read.csv('./data/spills_lsd.csv', stringsAsFactors = FALSE) %>%
  setNames(c('id', 'lsd')) %>%
  left_join(read.csv('./data/lsd_geocoded.csv', stringsAsFactors=FALSE)) %>%
  sample_frac(.50)


m <- leaflet(data = dd) %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(~lng, ~lat, popup=id)

m
