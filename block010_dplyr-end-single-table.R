## http://stat545.com/block010_dplyr-end-single-table.html

library(tidyverse)
library(gapminder)

(my_gap <- gapminder)

## let output print to screen, but do not store
my_gap %>% filter(country == "Canada")

## store the output as an R object
my_precious <- my_gap %>% filter(country == "Canada")

## Use mutate() to add new variables
my_gap %>%
  mutate(gdp = pop * gdpPercap)

## reporte GDP per capita relative to Canada
ctib <- my_gap %>%
  filter(country == "Canada")
## this is a semi-dangerous way to add this variable
## I'd prefer to join on year, but we haven't covered joins yet
my_gap <- my_gap %>%
  mutate(tmp = rep(ctib$gdpPercap, nlevels(country)),
         gdpPercapRel = gdpPercap / tmp,
         tmp = NULL)

my_gap %>% 
  filter(country == "Canada") %>% 
  select(country, year, gdpPercapRel)
summary(my_gap$gdpPercapRel)

## Use arrange() to row-order data in a principled way
my_gap %>%
  arrange(year, country)
my_gap %>%
  filter(year == 2007) %>%
  arrange(lifeExp)
my_gap %>%
  filter(year == 2007) %>%
  arrange(desc(lifeExp))

## Use rename() to rename variables
my_gap %>%
  rename(life_exp = lifeExp,
         gdp_percap = gdpPercap,
         gdp_percap_rel = gdpPercapRel)

## select() can rename and reposition variables
my_gap %>%
  filter(country == "Burundi", year > 1996) %>% 
  select(yr = year, lifeExp, gdpPercap) %>% 
  select(gdpPercap, everything())

## group_by() is a mighty weapon
my_gap %>%
  group_by(continent) %>%
  summarize(n = n())
my_gap %>%
  group_by(continent) %>%
  tally()
my_gap %>% 
  count(continent)
my_gap %>%
  group_by(continent) %>%
  summarize(n = n(),
            n_countries = n_distinct(country))
## The following commands do not create table frames.
table(gapminder$continent)
str(table(gapminder$continent))

## The functions you’ll apply within summarize() include classical statistical summaries,
## like mean(), median(),  var(), sd(), mad(), IQR(), min(), and max(). 
my_gap %>%
  group_by(continent) %>%
  summarize(avg_lifeExp = mean(lifeExp))
# `summarise_each()` is deprecated.
# Use `summarise_all()`, `summarise_at()` or `summarise_if()` instead.
# To map `funs` over a selection of variables, use `summarise_at()`
my_gap %>%
  filter(year %in% c(1952, 2007)) %>%
  group_by(continent, year) %>%
  summarise_each(funs(mean, median), lifeExp, gdpPercap)
my_gap %>%
  filter(continent == "Asia") %>%
  group_by(year) %>%
  summarize(min_lifeExp = min(lifeExp), max_lifeExp = max(lifeExp))

# Computing with group-wise summaries
my_gap %>% 
  group_by(country) %>% 
  select(country, year, lifeExp) %>% 
  mutate(lifeExp_gain = lifeExp - first(lifeExp)) %>% 
  filter(year < 1963)
# Let’s revisit the worst and best life expectancies in Asia over time, 
# but retaining info about which country contributes these extreme values.
my_gap %>%
  filter(continent == "Asia") %>%
  select(year, country, lifeExp) %>%
  group_by(year) %>%
  filter(min_rank(desc(lifeExp)) < 2 | min_rank(lifeExp) < 2) %>% 
  arrange(year) %>%
  print(n = Inf)
# Wouldn’t it be nice to have one row per year?
asia <- my_gap %>%
  filter(continent == "Asia") %>%
  select(year, country, lifeExp) %>%
  group_by(year)
asia
asia %>%
  mutate(le_rank = min_rank(lifeExp),
         le_desc_rank = min_rank(desc(lifeExp))) %>% 
  filter(country %in% c("Afghanistan", "Japan", "Thailand"), year > 1995)
# If we had wanted just the min OR the max, an alternative approach using top_n() would have worked.
my_gap %>%
  filter(continent == "Asia") %>%
  select(year, country, lifeExp) %>%
  arrange(year) %>%
  group_by(year) %>%
  #top_n(1, wt = lifeExp)        ## gets the min
  top_n(1, wt = desc(lifeExp)) ## gets the max

# which country experienced the sharpest 5-year drop in life expectancy?
my_gap %>%
  select(country, year, continent, lifeExp) %>%
  group_by(continent, country) %>%
  ## within country, take (lifeExp in year i) - (lifeExp in year i - 1)
  ## positive means lifeExp went up, negative means it went down
  mutate(le_delta = lifeExp - lag(lifeExp)) %>% 
  ## within country, retain the worst lifeExp change = smallest or most negative
  summarize(worst_le_delta = min(le_delta, na.rm = TRUE)) %>% 
  ## within continent, retain the row with the lowest worst_le_delta
  top_n(-1, wt = worst_le_delta) %>% 
  arrange(worst_le_delta)
