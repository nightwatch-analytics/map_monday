library(scales)
library(sf)
library(tidycensus)
library(tidyverse)
library(tigris)
library(viridis)

source("/Users/Mohr/analysis/toolkit/map_theme.R")

options(tigris_use_cache = TRUE)

wfh_harris <- get_acs(
  geography = "tract",
  variables = c("B08006_017", "B01003_001"),
  state = 48,
  county = 201,
  geometry = TRUE,
  output = "wide"
)

check <- wfh_harris %>%
  filter(B08006_017E == max(B08006_017E)) %>%
  st_centroid()

ggplot() +
  geom_sf(data = wfh_harris, aes(fill = estimate)) +
  scale_fill_viridis(
    option = "viridis",
    begin = 1, end = 0
  ) +
  labs(title = "Remote Workers",
       subtitle = "Harris County, 2022") +
  map_theme()
