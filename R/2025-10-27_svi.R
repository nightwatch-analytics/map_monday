library(findSVI)
library(ggplot2)
library(sf)
library(tigris)
library(viridis)

# setup ----
options(tigris_use_cache = TRUE)

# import ----
harris_tracts <- get_census_data(2022, "tract", "TX", "Harris")
# tidy ----

# transform ----

# visualize ----

# model ----
