# setup ----
source("R/toolkit.R")
library(tidygeocoder)
options(tigris_use_cache = TRUE)

# functions ----

# import ----
fbisd_ms_sites <- st_read("2026-06-01/data/fbisd_schools.geojson") %>%
  filter(School_Type == "Middle School") %>%
  st_transform(crs = 6588)

fbisd_ms_zones <- st_read("2026-06-01/data/fbisd_02-ms.geojson") %>%
  st_transform(crs = 6588)

home_sites <- data.frame(
  address = c(
    "3503 Sapphire Ct, Richmond, TX 77469",
    "2111 Ardani Ln, Fresno, TX 77545",
    "17402 Aster Fls Ct, Richmond, TX 77407"
  )
) %>%
  geocode(address = address, method = "mapbox") %>%
  st_as_sf(coords = c("long", "lat"), crs = 4326) %>%
  st_transform(crs = 6588)

# tidy ----

fbisd_ms_zones <- fbisd_ms_zones %>%
  arrange(address)

fbisd_ms_sites <- fbisd_ms_sites %>%
  arrange(Place_addr)

# transform ----

buffers_ms <- NULL

for (i in 1:length(fbisd_ms_zones$address)) {
  tmp <- st_buffer(fbisd_ms_sites[i, ], dist = 5280 * 2) %>%
    st_intersection(fbisd_ms_zones[i, ])

  buffers_ms <- rbind(buffers_ms, tmp)
}
# visualize ----

ggplot() +
  geom_sf(
    data = fbisd_ms_zones,
    color = "black",
    fill = "#8A2A2B",
    size = 0.75
  ) +
  geom_sf(
    data = buffers_ms,
    color = "black",
    fill = "white",
    size = 0.5
  ) +
  geom_sf(
    data = home_sites,
    shape = 21,
    size = 2,
    color = "black",
    fill = "darkgoldenrod1"
  ) +
  geom_sf(
    data = fbisd_ms_sites
  ) +
  labs(
    title = "FBISD School Bus Service Areas",
    subtitle = "Middle School Attendance Zones"
  ) +
  map_theme()
