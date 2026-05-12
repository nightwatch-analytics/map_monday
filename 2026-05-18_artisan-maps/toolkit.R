# setup ----
library(grid)
library(osmdata)
library(sf)
library(showtext)
library(sysfonts)
library(tidyverse)

# import ----
get_bbox_sf <- function(place) {
  bbox <- getbb(place)[1:4]
  names(bbox) <- c("xmin", "ymin", "xmax", "ymax")
  st_as_sfc(st_bbox(bbox, crs = 4326))
}

# tidy ----
