# http://stat545.com/block033_working-with-two-tables.html
# bind, join, lookup

library(gapminder)
library(tidyverse)
library(stringr)

### bind, row biding
fship <- tribble(
  ~Film,    ~Race, ~Female, ~Male,
  "The Fellowship Of The Ring",    "Elf",    1229,   971,
  "The Fellowship Of The Ring", "Hobbit",      14,  3644,
  "The Fellowship Of The Ring",    "Man",       0,  1995
)
rking <- tribble(
  ~Film,    ~Race, ~Female, ~Male,
  "The Return Of The King",    "Elf",     183,   510,
  "The Return Of The King", "Hobbit",       2,  2673,
  "The Return Of The King",    "Man",     268,  2459
)
ttow <- tribble(
  ~Film,    ~Race, ~Female, ~Male,
  "The Two Towers",   " Elf",     331,   513,
  "The Two Towers", "Hobbit",       0,  2463,
  "The Two Towers",    "Man",     401,  3589
)
(lotr_untidy <- bind_rows(fship, ttow, rking))

ttow_no_Female <- ttow %>% mutate(Female = NULL)
bind_rows(fship, ttow_no_Female, rking)
rbind(fship, ttow_no_Female, rking)

# different sequence
x <- tribble(
  ~key, ~val,
  "a", 1,
  "b", 2)
y <- tribble(
  ~val, ~key,
  3, "c",
  4, "d")
bind_rows(x,y)

# different data type
x <- tribble(
  ~key, ~val,
  "a", 1,
  "b", 2)
y <- tribble(
  ~val, ~key,
  "c", -1,
  "d", -2)
bind_rows(x,y)

# different layers
x <- tribble(
  ~key, ~val,
  "a", 1,
  "b", 2)
y <- tribble(
  ~key, ~key2, ~val,
  "c", "c1", -1,
  "c", "c2", -2,
  "d", "d1", -3,
  "d", "d2", -4)
bind_rows(x,y)

### bind, column binding
# may not make sense
life_exp <- gapminder %>%
  select(country, year, lifeExp)

pop <- gapminder %>%
  arrange(year) %>% 
  select(pop)

gdp_percap <- gapminder %>% 
  arrange(pop) %>% 
  select(gdpPercap)

(gapminder_garbage <- bind_cols(life_exp, pop, gdp_percap))
summary(gapminder$lifeExp)
summary(gapminder_garbage$lifeExp)
range(gapminder$gdpPercap)
range(gapminder_garbage$gdpPercap)

# another example
gapminder_mostly <- gapminder %>% select(-pop, -gdpPercap)
gapminder_leftovers_filtered <- gapminder %>% 
  filter(country == "Canada") %>% 
  select(pop, gdpPercap)
gapminder_nonsense <- cbind(gapminder_mostly, gapminder_leftovers_filtered)
head(gapminder_nonsense, 14)

### bind, join
gapminder %>% 
  select(country, continent) %>% 
  group_by(country) %>% 
  slice(1) %>% 
  left_join(country_codes)

# next, join, http://stat545.com/bit001_dplyr-cheatsheet.html
# next, lookup, http://stat545.com/bit008_lookup.html