# setup ----
source("R/toolkit.R")

options(tigris_use_cache = TRUE)

# import ----
fbisd_schools <- st_read("2026-06-01/data/fbisd_schools.geojson")

fbisd_el <- st_read("2026-06-01/data/fbisd_01-el.geojson") %>%
  st_transform(crs = 6588)
fbisd_ms <- st_read("2026-06-01/data/fbisd_02-ms.geojson") %>%
  st_transform(crs = 6588)
fbisd_hs <- st_read("2026-06-01/data/fbisd_03-hs.geojson") %>%
  st_transform(crs = 6588)

fbisd_el_sites <- fbisd_schools %>%
  filter(School_Type == "Elementary School") %>%
  st_transform(crs = 6588)

fbisd_ms_sites <- fbisd_schools %>%
  filter(School_Type == "Middle School") %>%
  st_transform(crs = 6588)

fbisd_hs_sites <- fbisd_schools %>%
  filter(School_Type == "High School") %>%
  st_transform(crs = 6588)

# tidy ----
fbisd_el <- fbisd_el

fbisd_ms <- fbisd_ms %>%
  arrange(address)

fbisd_hs <- fbisd_hs %>%
  arrange(address)

fbisd_el_sites <- fbisd_el_sites %>%
  arrange(Place_addr)
fbisd_ms_sites <- fbisd_ms_sites %>%
  arrange(Place_addr)
fbisd_hs_sites <- fbisd_hs_sites %>%
  arrange(Place_addr)

# transform ----
test_zone <- fbisd_hs %>% filter(name == "KEMPNER HS")
test_site <- fbisd_hs_sites %>% filter(USER_School_Name == "KEMPNER H S")

buffer_hs <- st_buffer(fbisd_hs_sites[3,], dist = 5280*2) %>%
  st_intersection(fbisd_hs[4,])

# visualize ----
ggplot() +
  geom_sf(
    data = fbisd_hs,
    fill = NA, size = 0.5
  ) +
  geom_sf(
    data = test,
    color = "#8A2A2B",
    fill = NA, size = 0.5
  ) +
  geom_sf(
    data = fbisd_hs_sites
    ) +
  labs(
    title = "FBISD School Bus Service Area",
    subtitle = "Subtitle"
  ) +
  map_theme()

