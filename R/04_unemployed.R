source("R/toolkit.R")

unemp_pop <- get_acs(
  geography = "tract",
  variables = c(total_pop = "DP05_0001",
                workforce = "DP03_0002",
                unemp = "DP03_0005",
                unemp_pct = "DP03_0005P",
                med_age = "DP05_0018"),
  county = "Dallas",
  state = "TX",
  output = "wide",
  geometry = TRUE
)

unemp_msa <- readxl::read_xlsx("data/laus_msa_2024-06-21.xlsx") %>%
  mutate(`Area Number` = str_remove(`Area Number`, "0")) %>%
  rename(GEOID = `Area Number`) %>%
  mutate(`Unemployment Rate` = `Unemployment Rate` / 100) %>%
  select(GEOID, `Unemployment Rate`)

cbsa <- core_based_statistical_areas(year = 2019, cb = TRUE)

msa <- cbsa %>%
  filter(LSAD == "M1", str_detect(NAME, "TX")) %>%
  select(GEOID)

msa <- msa %>%
  left_join(unemp_msa)

texas <- states(cb = TRUE) %>%
  filter(GEOID == "48")

ggplot() +
  geom_sf(data = texas, fill = NA) +
  geom_sf(data = msa, aes(fill = `Unemployment Rate`)) +
  scale_fill_viridis(
    option = "magma",
    begin = 1, end = 0,
    labels = scales::label_percent()
  ) +
  labs(title = "Unemployment Rates by MSA",
       subtitle = "May 2024") +
  map_theme()

ggsave("04_unemployed.png",
       width = 5, height = 5, dpi = 1200,
       path = "maps"
)
