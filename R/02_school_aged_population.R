source("R/toolkit.R")

dallas_isd <- school_districts(state = "TX", cb = TRUE) %>%
  filter(GEOID == "4816230") %>%
  select(GEOID, NAME)

school_aged_pop <- get_acs(
  geography = "tract",
  variables = c(
    "B01001_004",
    "B01001_005",
    "B01001_006",
    "B01001_028",
    "B01001_029",
    "B01001_030"
  ),
  county = "Dallas", state = "TX",
  geometry = TRUE
) %>%
  group_by(GEOID) %>%
  summarise(estimate = sum(estimate))

total_pop <- get_acs(
  geography = "tract",
  variables = "B01003_001",
  county = "Dallas", state = "TX",
) %>%
  select(GEOID, total = estimate)

school_demographics <- school_aged_pop %>%
  left_join(total_pop) %>%
  mutate(Percent = round(estimate / total, 2))

ggplot() +
  geom_sf(data = school_demographics, aes(fill = Percent)) +
  scale_fill_viridis(
    option = "magma", begin = 1, end = 0,
    labels = scales::label_percent()
  ) +
  geom_sf(data = dallas_isd, fill = NA, color = "deepskyblue3", linewidth = 1) +
  labs(
    title = "School-Aged Population (5-17 Years Old)",
    subtitle = "Dallas County; 2022"
  ) +
  map_theme()

ggsave("02_school_pop.png",
  width = 5, height = 5, dpi = 1200,
  path = "maps"
)
