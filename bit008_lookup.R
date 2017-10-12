# http://stat545.com/bit008_lookup.html

library(gapminder)
library(tidyverse)

# Work with a tiny subset of Gapminder, mini_gap.
mini_gap <- gapminder %>% 
  filter(country %in% c("Belgium", "Canada", "United States", "Mexico"),
         year > 2000) %>% 
  select(-pop, -gdpPercap) %>% 
  droplevels()
mini_gap

# Add a food table
food <- tribble(
  ~ country,    ~ food,
  "Belgium",  "waffle",
  "Canada", "poutine",
  "United States", "Twinkie"
)
food

# lookup national food, limited to vectors
(indices <- match(x = mini_gap$country, table = food$country))
add_column(food[indices, ], x = mini_gap$country)
mini_gap %>% 
  mutate(food = food$food[indices])
# or left_join, with data type mismatch warning
mini_gap %>% 
  left_join(food)

# lazy table lookup
(food_vec <- setNames(food$food, food$country))
# wrong result, because we match index, not char
mini_gap %>% 
  mutate(food = food_vec[country])
# fix
unclass(mini_gap$country)
mini_gap %>% 
  mutate(food = food_vec[as.character(country)])
