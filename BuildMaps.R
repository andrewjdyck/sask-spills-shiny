
library(dplyr)
library(leaflet)

dd <- read.csv('./data/spills_lsd.csv', stringsAsFactors = FALSE) %>%
  setNames(c('id', 'lsd')) %>%
  left_join(read.csv('./data/lsd_geocoded.csv', stringsAsFactors=FALSE)) %>%
  sample_frac(1) %>%
  filter(!is.na(lat))


m <- leaflet(data = dd) %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(~lng, ~lat, popup=id)

m

# Trying a static map
library(raster)
provinces <- c("Alberta", "Saskatchewan", "Manitoba")

canada <- getData("GADM",country="CAN",level=1)
ca.provinces <- canada[canada$NAME_1 %in% provinces,]
sk <- canada[canada$NAME_1 == "Saskatchewan",]

ca.bbox <- bbox(ca.provinces)

xlim <- c(ca.bbox[1,1],ca.bbox[1,2])
ylim <- c(ca.bbox[2,1],ca.bbox[2,2])
plot(ca.provinces, xlim=xlim, ylim=ylim)

points(dd$lng, dd$lat)


plot(ca.provinces, xlim=xlim, ylim=ylim)
symbols(dd$lng, dd$lat, 
        # circles=.008*sqrt(airports$alt), 
        circles = rep(.5,nrow(dd)),
        add=TRUE, inches=FALSE, 
        # bg="#F4C3B9", 
        # bg=rgb(red=238, green=137, blue=116, alpha=.5),
        bg=rgb(red=1, green=0, blue=0, alpha=.5),
        fg='#F4C3B9',
        lwd=0.5)


conterm_proj4 <- "+proj=aea +lat_1=29.5 +lat_2=45.5 +lon_0=97.2w"
ca_projected <- spTransform(ca.provinces, CRS(conterm_proj4))

plot(ca_projected)
latlon <- data.frame(dd$lng, dd$lat)
coordinates(latlon) <- c("dd.lng", "dd.lat")
proj4string(latlon) <- CRS("+proj=longlat")
latlon_projected <- spTransform(latlon, CRS(conterm_proj4))
# points(latlon_projected)

plot(ca_projected, border="#cccccc", lwd=0.5,
     main="Oil spills reported in Saskatchewan (2005 - 2017)",
     sub="@andrewjdyck"
)
symbols(latlon_projected@coords,
        # circles=.008*sqrt(airports$alt), 
        circles = rep(20000,nrow(dd)),
        add=TRUE, inches=FALSE, 
        # bg="#F4C3B9", 
        # bg=rgb(red=238, green=137, blue=116, alpha=.5),
        bg=rgb(red=1, green=0, blue=0, alpha=.5),
        fg='#F4C3B9',
        lwd=0.5)


library(ggplot2)
tt <- st_as_sf(ca.provinces)
# tt <- st_as_sf(ca_projected)
pp <- ggplot(tt) + 
  geom_sf() +
  geom_point(data = dd, aes(x = lng, y = lat), size = 2, 
             shape = "circle", color=rgb(red=1, green=0, blue=0, alpha=.5), alpha=.1) +
  labs(x="", y="", title="Oil spills reported in Saskatchewan (2005 - 2017)") + #labels
  theme(axis.ticks.y = element_blank(),axis.text.y = element_blank(), # get rid of x ticks/text
        axis.ticks.x = element_blank(),axis.text.x = element_blank(), # get rid of y ticks/text
        plot.title = element_text(lineheight=.8, face="bold", vjust=1)) # make title bold and add space

logo_path <- file.path(system.file("extdata", package = 'opendataskr'),"ODS-open-data-saskatchewan-logo.png")
opendataskr::finalise_plot(pp, source_name = "", logo_image_path = logo_path)


footer <- grid::rasterGrob(png::readPNG(logo_image_path), x = 0.99, just="right")


plot_grid <- ggpubr::ggarrange(pp, footer,
                               ncol = 1, nrow = 2,
                               heights = c(1, 0.045/(450/450)))


# from flowingdata
library(maptools)
library(rgdal)
library(maps)
library(nycflights13)

usa <- readShapePoly("~/Downloads/geographic-r-course/data/census_bureau/cb_2013_us_state_20m/cb_2013_us_state_20m.shp", proj4string=CRS("+proj=longlat"))
conterm <- usa[usa$STATEFP != "02" & usa$STATEFP != "15" & usa$STATEFP != "72",]
plot(conterm)
points(airports$lon, airports$lat)

plot(conterm)
symbols(airports$lon, airports$lat, circles=.008*sqrt(airports$alt), add=TRUE, inches=FALSE, bg="#00000050", lwd=0.5)

conterm_proj4 <- "+proj=aea +lat_1=29.5 +lat_2=45.5 +lon_0=97.2w"
conterm_projected <- spTransform(conterm, CRS(conterm_proj4))

plot(conterm_projected)



# map testing ggplot
usa <- map_data("usa") # we already did this, but we can do it again
ggplot() + geom_polygon(data = usa, aes(x=long, y = lat, group = group)) + 
  coord_fixed(1.3)

library(sf)
tt <- st_as_sf(ca.provinces)
ggplot(data=tt) + 
  # geom_polygon(data=tt)
  geom_sf()
