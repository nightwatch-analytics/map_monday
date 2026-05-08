# setup ----
source("R/toolkit.R")
library(mapboxapi)
library(osmdata)
library(tigris)

options(tigris_use_cache = TRUE)

# import ----
office1 <- mb_geocode("15502 Galveston Rd, Webster, TX 77598",
  output = "sf"
)
office1_iso <- mb_isochrone(office1, time = c(15, 30, 45))

office2 <- mb_geocode("420 Garden Oaks Blvd, Houston, TX 77018",
  output = "sf"
)

office2_iso <- mb_isochrone(office2, time = c(15, 30, 45))

harris_co <- counties(state = 48, cb = T) %>%
  filter(NAME == "Harris")

htx_roads <- st_read("2026-05-04/data/Hwy/Hwy.shp")

# tidy ----

# transform ----

# visualize ----
ggplot() +
  geom_sf(
    data = htx_roads,
    color = "black"
  ) +
  geom_sf(
    data = harris_co,
    color = "black",
    fill = NA,
    size = 1
  ) +
  geom_sf(
    data = office1_iso,
    aes(color = as.factor(time)),
    fill = NA,
    size = 1
  ) +
  geom_sf(
    data = office1,
    shape = 21,
    color = "black",
    fill = "salmon1"
  ) +
  scale_color_viridis(
    option = "D",
    name = "Drive Time",
    discrete = T,
    direction = -1
  ) +
  labs(
    title = "Service Area by Drive Time",
    subtitle = "15, 30, and 45 Minutes"
  ) +
  map_theme()

ggplot() +
  geom_sf(
    data = htx_roads,
    color = "black"
  ) +
  geom_sf(
    data = harris_co,
    color = "black",
    fill = NA,
    size = 1
  ) +
  geom_sf(
    data = office2_iso,
    aes(color = as.factor(time)),
    fill = NA,
    size = 1
  ) +
  geom_sf(
    data = office2,
    shape = 21,
    color = "black",
    fill = "salmon1"
  ) +
  scale_color_viridis(
    option = "D",
    name = "Drive Time",
    discrete = T,
    direction = -1
  ) +
  labs(
    title = "Service Area by Drive Time",
    subtitle = "15, 30, and 45 Minutes"
  ) +
  map_theme()
