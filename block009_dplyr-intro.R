## ref: http://stat545.com/block009_dplyr-intro.html

library(gapminder)
library(tidyverse)

## Meet the new pipe operator, CTRL + SHIFT + M
gapminder %>% head()

## Use filter() to subset data row-wise
filter(gapminder, lifeExp < 29)
filter(gapminder, country == "Rwanda", year > 1979)
filter(gapminder, country %in% c("Rwanda", "Afghanistan"))

## Use select() to subset the data on variables or columns
select(gapminder, year, lifeExp)
gapminder %>%
  select(year, lifeExp) %>%
  head(4)
gapminder %>%
  filter(country == "Cambodia") %>%
  select(year, lifeExp)
