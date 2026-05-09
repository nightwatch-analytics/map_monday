# setup ----

source("R/toolkit.R")
library(findSVI)

# import ----

harris_tracts24 <- get_acs("tract",
  variables = as.vector(
    unlist(census_variables_2022)
  ),
  county = "Harris County",
  state = "TX",
  output = "wide",
  geometry = T
)

harris_svi_raw <- get_svi(2022, harris_tracts24)

# tidy ----
harris_svi <- harris_svi_raw %>%
  select(
    GEOID,
    contains("theme")
  )

# transform ----
harris_svi_byTheme <- harris_svi %>%
  select(GEOID,
    "Socioeconomics" = RPL_theme1,
    "Household Characteristics" = RPL_theme2,
    "Minority Status" = RPL_theme3,
    "Housing/Transportation" = RPL_theme4
  ) %>%
  pivot_longer(!c(GEOID, geometry), names_to = "Theme") %>%
  mutate(Theme = factor(Theme,
    levels = c(
      "Socioeconomics",
      "Household Characteristics",
      "Minority Status",
      "Housing/Transportation"
    )
  ))
# visualize ----
ggplot() +
  geom_sf(data = harris_svi, aes(fill = RPL_themes)) +
  scale_fill_viridis(option = "A", name = "SVI", direction = -1) +
  labs(
    title = "SVI 2024",
    subtitle = "Harris County",
    caption = "Note that this calculation uses an accepted methodology from 2022."
  ) +
  map_theme()

ggplot() +
  geom_sf(data = harris_svi_byTheme, aes(fill = value)) +
  facet_wrap(~Theme) +
  scale_fill_viridis(option = "A", name = "SVI", direction = -1) +
  labs(
    title = "SVI 2024 by Theme",
    subtitle = "Harris County",
    caption = "Note that this calculation uses an accepted methodology from 2022"
  ) +
  map_theme()
