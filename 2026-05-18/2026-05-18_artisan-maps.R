# setup ----
source("2026-05-18/toolkit.R")

places <- c("Austin", "Dallas", "Fort Worth", "Houston", "San Antonio")
set_overpass_url("https://overpass-api.de/api/interpreter")

# import ----
bbox <- get_bbox_sf("Dallas")
query <- opq(bbox = bbox)

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

roads_a <- query %>%
  add_osm_feature(
    key = "highway",
    value = c(
      "motorway", "trunk", "primary",
      "motorway_link", "trunk_link", "primary_link"
    )
  ) %>%
  osmdata_sf()

roads_b <- query %>%
  add_osm_feature(
    key = "highway",
    value = c(
      "secondary", "tertiary", "unclassified", "residential",
      "secondary_link", "tertiary_link"
    )
  ) %>%
  osmdata_sf()

natural <- query %>%
  add_osm_feature(
    key = "natural",
    value = c(
      "wood",
      "grassland",
      "scrub",
      "wetland",
    )
  ) %>%
  osmdata_sf()

meadow <- query %>%
  add_osm_feature(
    key = "natural"
  ) %>%
  osmdata_sf()

rec <- query %>%
  add_osm_features(
    list(
      "landuse" = c("grass", "forest", "recreation_ground"),
      "leisure" = c("playground", "park", "garden", "dog_park")
    )
  ) %>%
  osmdata_sf()

# tidy ----
natural_valid <- natural$osm_polygons %>%
  sf::st_make_valid(
    s2_options = s2::s2_options(
      split_crossing_edges = TRUE
    )
  )

water_a_cropped <- st_crop(water_a$osm_multipolygons, bbox)
water_a_cropped <- st_crop(water_a$osm_multipolygons, bbox)
water_b_cropped <- st_crop(water_b$osm_polygons, bbox)
roads_a_cropped <- st_crop(roads_a$osm_lines, bbox)
roads_b_cropped <- st_crop(roads_b$osm_lines, bbox)
natural_cropped <- st_crop(natural_valid, bbox)
rec_cropped <- st_crop(rec$osm_polygons, bbox)

# transform ----

# visualize ----
# define colour palette

water_colour <- "cadetblue3"
roads_a_colour <- "#"
roads_b_colour <- "#171717"
natural_colour <- "#879600"
rec_colour <- "#8cb369"
bkgd_colour <- "#f4f1de"

ggplot() +
  # rivers
  geom_sf(
    data = water_a_cropped, fill = water_colour, color = NA
  ) +
  # other bodies of water
  geom_sf(
    data = water_b_cropped, fill = water_colour, color = NA
  ) +
  # natural vegetation
  geom_sf(
    data = natural_cropped, fill = natural_colour, color = NA
  ) +
  # recreational spaces
  geom_sf(
    data = rec_cropped, fill = rec_colour, color = NA
  ) +
  # major roads
  geom_sf(
    data = roads_a_cropped, colour = roads_a_colour, size = 0.8, alpha = 0.9
  ) +
  # minor roads
  geom_sf(
    data = roads_b_cropped, colour = roads_b_colour, size = 0.5, alpha = 0.7
  ) +
  # remove margins
  coord_sf(expand = FALSE) +
  theme_void() +
  theme(
    panel.background = element_rect(fill = bkgd_colour)
  )

page_colour <- "#ffffff"
text_colour <- "#000000"
city <- "HOUSTON"
country <- "TEXAS"
coordinates <- "29.7608°N | 95.3695°W"

sysfonts::font_add_google(name = "Montserrat")
png("houston-map.png",
  width = 8,
  height = 10,
  units = "in",
  res = 300
)
showtext::showtext_begin()

vp1 <- viewport(
  x = 0.5,
  y = 0.5,
  width = 1,
  height = 1
)
pushViewport(vp1)
grid.rect(gp = gpar(fill = page_colour))
upViewport()

vp2 <- viewport(
  x = 0.5,
  y = 0.575,
  width = 0.9,
  height = 0.75
)

pushViewport(vp2)
print(plt, newpage = FALSE)
upViewport()

vp3 <- viewport(
  x = 0.75,
  y = 0.15,
  width = 0.4,
  height = 0.06,
  just = "left"
)
pushViewport(vp3)
grid.text(
  city,
  just = "right",
  gp = gpar(
    fontfamily = font,
    fontsize = 36,
    col = text_colour
  )
)
upViewport()

vp4 <- viewport(
  x = 0.75,
  y = 0.1,
  width = 0.4,
  height = 0.03,
  just = "left"
)

pushViewport(vp4)
grid.text(
  country,
  just = "right",
  gp = gpar(
    fontfamily = "Montserrat",
    fontsize = 18,
    col = text_colour
  )
)
upViewport()

vp5 <- viewport(
  x = 0.75,
  y = 0.065,
  width = 0.4,
  height = 0.03,
  just = "left"
)

pushViewport(vp5)
grid.text(
  coordinates,
  just = "right",
  gp = gpar(
    fontfamily = "Montserrat",
    fontsize = 18,
    col = text_colour
  )
)
upViewport()

showtext::showtext_end()
dev.off()
