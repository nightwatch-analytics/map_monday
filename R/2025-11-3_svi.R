library(dplyr)
library(findSVI)
library(ggplot2)
library(sf)
library(tigris)
library(viridis)

# setup ----
options(tigris_use_cache = TRUE)

# import ----
harris_tracts <- get_census_data(year = 2022, geography = "tract",
                                 state = "TX", county = "Harris County",
                                 geometry = T)

harris_svi_raw <- get_svi(2022, harris_tracts)

harris <- counties(state = "TX", cb = TRUE) %>%
  filter(NAME == "Harris")
# tidy ----
harris_svi <- harris_svi_raw %>%
  select(GEOID, contains("theme"))
# transform ----

# visualize ----

# model ----
