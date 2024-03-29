library(lidR) # Point cloud classification
library(papeR) # summary tables
library(tidyverse) # tidy essentials (ggplot, purr, tidyr, readr, dplyr)
library(lubridate) # handling dates and time
library(tmap) # map visualization
# library(leaflet) # interactive maps
library(terra) # handling spatial data
library(sf) # handling spatial data
library(rgdal) # export raster objects
library(ncdf4) # export ncdf files
library(janitor) # clean and consistent naming
library(forcats) # handling factor levels
library(raster) # rasterizing vector data
library(knitr) # for pretty tables
library(rayshader) # for pretty DTMs
library(RCSF) # for CSF ground classification
library(RMCC) # for MCC ground classification
library(geometry) # for raserize_canopy function
library(lmom) # for Key structural features of boreal forests
library(purrr) # for map function
library(rjson) # for JSON generation
library(rgl) # for RGL Viewer control functions
library(sabre) # for mapcurves (goodness-of-fit function)
library(fasterize) # for faster rasterization

# Generate rectangular polygon of area of interest
gen_xy_tls <- structure(list(dat = c("AOI TLS", "AOI TLS", 
                                     "AOI TLS", "AOI TLS"),
                             Longitude = c(2575340, 2575340, 
                                           2575480, 2575480),
                             Latitude = c(1178520, 1178780, 
                                          1178780, 1178520)),
                        class = "data.frame", row.names = c(NA,-4L))

bounding_box_tls <- gen_xy_tls %>%
  st_as_sf(coords = c("Longitude", "Latitude"), crs = 2056) %>%
  group_by(dat) %>%
  summarise(geometry = st_combine(geometry)) %>%
  st_cast("POLYGON")

# Read Shapefiles
csf_aoi_shp <- read_sf(dsn = "C:/Daten/math_gubelyve/pcc_standalone/data/dut_filter_230315/dut_filter_230315.shp") 

# Generate raster for total aoi
# to downsample
# tif_path <- "C:/Daten/math_gubelyve/tiff_data/110721_bg.tif"

?aggregate()

tif <- terra::rast("C:/Daten/math_gubelyve/tiff_data/110721_bg.tif")
e <- extent(2575009, 2575489, 1178385, 1178900)
tot_aoi <- raster(crs=2056, ext=e, resolution=0.2, vals=NULL)  
t0_tif_crop <- crop(tif, tot_aoi)

t2 <- terra::aggregate(t0_tif_crop, 20)
t2
t0_tif_crop
tm1 <- tm_shape(t2) +
  tm_rgb(r=1, g=2, b=3, saturation = 0, contrast = c(1), alpha = 0.5)
  # tm_shape(csf_aoi_shp) +
  # tm_borders(col="red", lwd=2.0, alpha = 0.9) +
  # tm_shape(bounding_box_tls) +
  # tm_borders(col="yellow", lwd=2.0, alpha = 0.9)
tm1


rf <- terra::writeRaster(t0_tif_crop, filename="C:/Daten/math_gubelyve/tiff_data/310522_bg.tif", overwrite=TRUE)


tmap_save(tm1, "export/study_site.png", width=1920, height=1920, dpi = 600)
