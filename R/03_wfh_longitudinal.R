source("R/toolkit.R")

wfh_15 <- get_acs(
  geography = "tract",
  variables = "B08006_017",
  year = 2015,
  state = "TX",
  county = "Dallas",
  geometry = TRUE
) %>%
  select(estimate) %>%
  st_transform(6584)

wfh_17 <- get_acs(
  geography = "tract",
  variables = "B08006_017",
  year = 2017,
  state = "TX",
  county = "Dallas",
  geometry = TRUE
) %>%
  select(estimate) %>%
  st_transform(6584)

wfh_20 <- get_acs(
  geography = "tract",
  variables = "B08006_017",
  year = 2020,
  state = "TX",
  county = "Dallas",
  geometry = TRUE
) %>%
  st_transform(6584) %>%
  mutate(year = 2020)

wfh_22 <- get_acs(
  geography = "tract",
  variables = "B08006_017",
  year = 2022,
  state = "TX",
  county = "Dallas",
  geometry = TRUE
) %>%
  st_transform(6584) %>%
  mutate(year = 2022)

dallas_blocks <- blocks(
  "TX",
  "Dallas",
  year = 2020
)

wfh_15_to_20 <- interpolate_pw(
  from = wfh_15,
  to = wfh_20,
  to_id = "GEOID",
  weights = dallas_blocks,
  weight_column = "POP20",
  crs = 6584,
  extensive = TRUE
) %>% mutate(year = 2015)

wfh_17_to_22 <- interpolate_pw(
  from = wfh_17,
  to = wfh_22,
  to_id = "GEOID",
  weights = dallas_blocks,
  weight_column = "POP20",
  crs = 6584,
  extensive = TRUE
) %>% mutate(year = 2017)

ggplot() +
  geom_sf(data = wfh_17, aes(fill = estimate)) +
  scale_fill_viridis(
    option = "viridis",
    begin = 1, end = 0
  ) +
  labs(title = "WFH Workforce in 2017",
       subtitle = "2010 Census Tracts") +
  map_theme()

ggplot() +
  geom_sf(data = wfh_20, aes(fill = estimate)) +
  scale_fill_viridis(
    option = "viridis",
    begin = 1, end = 0
  ) +
  labs(title = "WFH 2020") +
  map_theme()

ggplot() +
  geom_sf(data = wfh_17_to_22, aes(fill = estimate)) +
  scale_fill_viridis(
    option = "viridis",
    begin = 1, end = 0
  ) +
  labs(title = "WFH Workforce in 2017 (Interpolated)",
       subtitle = "2020 Census Tracts") +
  map_theme()

wfh_01 <- bind_rows(wfh_15_to_20, wfh_20)

ggplot() +
  geom_sf(data = wfh_01, aes(fill = estimate)) +
  facet_wrap(~year)+
  scale_fill_viridis(
    option = "viridis",
    begin = 1, end = 0
  ) +
  labs(title = "Change in WFH Workforce from 2015 to 2020 (Interpolated)",
       subtitle = "Dallas County") +
  map_theme(title_size = 12)

wfh_02 <- bind_rows(wfh_17_to_22, wfh_22)

ggplot() +
  geom_sf(data = wfh_02, aes(fill = estimate)) +
  facet_wrap(~year)+
  scale_fill_viridis(
    option = "viridis",
    begin = 1, end = 0
  ) +
  labs(title = "Change in WFH Workforce from 2017 to 2022 (Interpolated)",
       subtitle = "Dallas County") +
  map_theme(title_size = 12)

ggsave("03_04_wfh_interpolated.png",
       width = 5, height = 5, dpi = 1200,
       path = "maps"
)
