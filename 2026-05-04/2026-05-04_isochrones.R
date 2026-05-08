# setup ----
source("R/toolkit.R")
library(mapboxapi)
library(osmdata)
options(tigris_use_cache = TRUE)

# import ----
office <- mb_geocode("15502 Galveston Rd, Webster, TX 77598",
  output = "sf"
)

office2  <- mb_geocode("420 Garden Oaks Blvd, Houston, TX 77018",
                       output = "sf"
)

office_iso <- mb_isochrone(office, time = c(15, 30, 45))

office_iso2 <- mb_isochrone(office2, time = c(15, 30, 45))


cbsa_tx <- core_based_statistical_areas(cb = T)

htx_roads <- st_read("2026-05-04/data/Hwy/Hwy.shp")

# tidy ----

# transform ----

# visualize ----
ggplot() +
  geom_sf(data = htx_roads,
          color = "black")+
  geom_sf(
    data = harris_co,
    color = "black",
    fill = NA,
    size = 1
  ) +
  geom_sf(
    data = office_iso,
    aes(color = as.factor(time)),
    fill = NA,
    size = 1
  ) +
  geom_sf(
    data = office,
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
  geom_sf(data = htx_roads,
          color = "black")+
  geom_sf(
    data = harris_co,
    color = "black",
    fill = NA,
    size = 1
  ) +
  geom_sf(
    data = office_iso2,
    aes(color = as.factor(time)),
    fill = NA,
    size = 1
  ) +
  geom_sf(
    data = office2,
    shape = 21,
    color = "black",
    fill = "salmon1"
  ) + scale_color_viridis(
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

