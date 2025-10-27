library(scales)
library(sf)
library(tidycensus)
library(tidyverse)
library(tigris)
library(viridis)

map_theme <- function(base_size = 12, title_size = 16) {
  theme(
    text = element_text(color = "black"),
    plot.title = element_text(size = title_size, colour = "black"),
    plot.subtitle = element_text(face = "italic"),
    plot.caption = element_text(hjust = 0),
    axis.ticks = element_blank(),
    panel.background = element_blank(),
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    strip.text.x = element_text(size = 14)
  )
}
