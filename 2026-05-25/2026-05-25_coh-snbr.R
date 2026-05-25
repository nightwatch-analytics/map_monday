# setup ----
source("R/toolkit.R")

options(tigris_use_cache = TRUE)

# import ----

snbr_raw <- st_read("2026-05-25/data/coh_super_neighborhoods.geojson")
read_snbr <- function(sp_file) {
  st_read(sp_file) %>%
    select(
      POLYID,
      SNBNAME,
      COUNCIL_ACTIVE,
      RECOGNITION_DATE,
      WeCan,
      Top10,
      CEA_FLAG
    ) %>%
    arrange(POLYID)
}

snbr <- read_snbr("2026-05-25/data/coh_super_neighborhoods.geojson")
places_tx <- places(state = "TX",cb = T)

houston <- places_tx %>% filter(NAME == "Houston")

counties_tx <- counties(state = "TX", cb = T)
harris <- counties_tx %>% filter(NAME == "Harris")
# tidy ----
snbr <- snbr %>%
  mutate(COUNCIL_ACTIVE = replace_na(COUNCIL_ACTIVE,"No"),
         STATUS = recode_values(COUNCIL_ACTIVE,
                                "Yes" ~ "Active",
                                "No" ~ "Inactive")
         )
# transform ----

# visualize ----
ggplot() +
  geom_sf(
    data = houston,fill = "gray70", size = 0.5, color = "black"
  ) +
  geom_sf(
    data = snbr, aes(fill = STATUS)
  ) +
  geom_sf(
    data = harris,fill = NA, size = 1, color = "black"
  ) +
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  labs(
    title = "City of Houston Super Neighborhoods",
    subtitle = "Active Status",
    fill = "Status"
  ) +
  map_theme()
