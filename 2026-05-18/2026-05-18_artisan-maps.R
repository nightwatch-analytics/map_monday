# setup ----
source("2026-05-18/toolkit.R")

places <- c("Austin", "Dallas", "Fort Worth", "Houston", "San Antonio")
set_overpass_url("https://overpass-api.de/api/interpreter")

# import ----
bbox <- get_bbox_sf("Dallas")
query <- opq(bbox = bbox)

natural <- query %>%
  add_osm_feature(
    key = "natural",
    value = c(
      "wood",
      "grassland",
      "scrub",
      "wetland"
    )
  ) %>%
  osmdata_sf()

rivers <- query %>%
  add_osm_feature(
    key = "natural",
    value = "water"
  ) %>%
  osmdata_sf()

lakes <- query %>%
  add_osm_feature(
    key = "water",
    value = c(
      "lake",
      "canal",
      "pond",
      "basin",
      "lock",
      "reservoir"
    )
  ) %>%
  osmdata_sf()

roads_main <- query %>%
  add_osm_feature(
    key = "highway",
    value = c(
      "motorway", "trunk", "primary",
      "motorway_link", "trunk_link", "primary_link"
    )
  ) %>%
  osmdata_sf()

roads_secondary <- query %>%
  add_osm_feature(
    key = "highway",
    value = c(
      "secondary", "tertiary", "unclassified", "residential",
    )
  ) %>%
  osmdata_sf()

recreation <- query %>%
  add_osm_features(
    list(
      "landuse" = c("grass", "forest", "recreation_ground"),
      "leisure" = c("playground", "park", "garden", "dog_park")
    )
  ) %>%
  osmdata_sf()

# tidy ----
natural_valid <- natural$osm_polygons %>%
  validate_features()

rivers_cropped <- st_crop(rivers$osm_multipolygons, bbox)
lakes_cropped <- st_crop(lakes$osm_polygons, bbox)
roads_a_cropped <- st_crop(roads_main$osm_lines, bbox)
roads_b_cropped <- st_crop(roads_b$osm_lines, bbox)
natural_cropped <- st_crop(natural_valid, bbox)
natural2_cropped <- st_crop(lakes$osm_multipolygons, bbox)
rec_cropped <- st_crop(rec$osm_polygons, bbox)

# transform ----

# visualize ----
# define colour palette
colors <- tibble(
  background = "#f4f1de",
  natural = "#879600",
  parks = "#8cb369",
  roads_main = "#000000",
  roads_secondary = "#171717",
  water = "cadetblue3"
)

ggplot() +
  geom_sf(
    data = natural_cropped, fill = colors$natural, color = NA
  )+
  geom_sf(
    data = natural2_cropped, fill = colors$natural, color = NA
  ) +
  geom_sf(
    data = parks_cropped, fill = colors$parks, color = NA
  ) +
  geom_sf(
    data = rivers_cropped, fill = colors$water, color = NA
  ) +
  geom_sf(
    data = lakes_cropped, fill = water_colour, color = NA
  ) +
  geom_sf(
    data = roads_main, colour = roads_a_colour, size = 0.8, alpha = 0.9
  ) +
  geom_sf(
    data = roads_secondary, colour = roads_b_colour, size = 0.5, alpha = 0.7
  ) +
  # remove margins
  coord_sf(expand = FALSE) +
  theme_void() +
  theme(
    panel.background = element_rect(fill = colors$background)
  )
