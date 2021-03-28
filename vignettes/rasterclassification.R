## ---- include = FALSE, message = FALSE, warning = FALSE-----------------------
devtools::load_all(".")
library(sits)
library(dtwclust)
library(sitsdata)
require(sits)

## -----------------------------------------------------------------------------
# Obtain a raster cube with 23 instances for one year
# Select the band "ndvi", "evi" from images available in the "sitsdata" package
data_dir <- system.file("extdata/sinop", package = "sitsdata")

# create a raster metadata file based on the information about the files
raster_cube <- sits_cube(source = "LOCAL",
                   satellite = "TERRA",
                   sensor  = "MODIS",
                   name = "Sinop",
                   data_dir = data_dir,
                   parse_info = c("X1", "X2", "band", "date"),
)

# get information on the data cube 
raster_cube %>% dplyr::select(source, satellite, sensor)
# get information on the coverage
raster_cube %>% dplyr::select(xmin, xmax, ymin, ymax)

