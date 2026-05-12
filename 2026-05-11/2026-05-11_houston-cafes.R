# setup ----
source("R/toolkit.R")
library(osmdata)

# import ----

htx_major <- getbb(place_name = "Houston") %>%
  opq() %>%
  add_osm_feature(key = "highway",
                  value = c("motorway","primary","secondary")) %>%
  osmdata_sf()

htx_coffee_opq <- getbb(place_name = "Houston") %>%
  opq() %>%
  add_osm_feature(key = "amenity", value = "cafe") %>%
  osmdata_sf()
# tidy ----

htx_independent <- htx_coffee_opq$osm_points %>%
  select(osm_id, name, brand) %>%
  filter(is.na(brand)) %>%
  mutate(type = "Independent")

htx_corporate <- htx_coffee_opq$osm_points %>%
  select(osm_id, name, brand) %>%
  filter(!is.na(brand))%>%
  mutate(type = "Corporate")

# transform ----

htx_coffee <- bind_rows(htx_independent, htx_corporate)

# visualize ----
ggplot() +
  geom_sf(
    data = htx_major$osm_lines
    ) +
  geom_sf(data = htx_coffee,
          shape = 21,
          color = 'black',
          aes(fill = type))+
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  labs(
    title = "Cafe Landscape Analysis",
    subtitle = "Houston, TX",
    fill = "Business Type"
  ) +
  theme(legend.position = "bottom")+
  map_theme()
