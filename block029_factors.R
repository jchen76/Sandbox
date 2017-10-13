# http://stat545.com/block029_factors.html

library(gapminder)
library(tidyverse)
library(forcats)

gapminder
str(gapminder)
levels(gapminder$continent)
nlevels(gapminder$continent)
class(gapminder$continent)
summary(gapminder$continent)

gapminder %>% 
  count(continent)
fct_count(gapminder$continent)

# dropping unused levels
h_countries <- c("Egypt", "Haiti", "Romania", "Thailand", "Venezuela")
h_gap <- gapminder %>%
  filter(country %in% h_countries)
nlevels(h_gap$country)
# drop levels
h_gap_dropped <- h_gap %>% 
  droplevels()
nlevels(h_gap_dropped$country)
## use forcats::fct_drop() on a free-range factor
h_gap$country %>%
  fct_drop() %>%
  levels()

# Change order of the levels, principled
## default order is alphabetical
gapminder$continent %>%
  levels()
## order by frequency
gapminder$continent %>% 
  fct_infreq() %>%
  levels() %>% head()
## backwards!
gapminder$continent %>% 
  fct_infreq() %>%
  fct_rev() %>% 
  levels() %>% head()

## order countries by median life expectancy
fct_reorder(gapminder$country, gapminder$lifeExp) %>% 
  levels() %>% head()
## order accoring to minimum life exp instead of median
fct_reorder(gapminder$country, gapminder$lifeExp, min) %>% 
  levels() %>% head()
## backwards!
fct_reorder(gapminder$country, gapminder$lifeExp, .desc = TRUE) %>% 
  levels() %>% head()

# application
gap_asia_2007 <- gapminder %>% filter(year == 2007, continent == "Asia")
ggplot(gap_asia_2007, aes(x = lifeExp, y = country)) + geom_point()
ggplot(gap_asia_2007, aes(x = lifeExp, y = fct_reorder(country, lifeExp))) +
  geom_point()

# Use fct_reorder2() when you have a line chart of a quantitative x against
# another quantitative y and your factor provides the color.
h_countries <- c("Egypt", "Haiti", "Romania", "Thailand", "Venezuela")
h_gap <- gapminder %>%
  filter(country %in% h_countries) %>% 
  droplevels()
ggplot(h_gap, aes(x = year, y = lifeExp, color = country)) +
  geom_line()
ggplot(h_gap, aes(x = year, y = lifeExp,
                  color = fct_reorder2(country, year, lifeExp))) +
  geom_line() +
  labs(color = "country")

# Change order of the levels, “because I said so”
h_gap$country %>% levels()
h_gap$country %>% fct_relevel("Romania", "Haiti") %>% levels()

# Recode the levels
i_gap <- gapminder %>% 
  filter(country %in% c("United States", "Sweden", "Australia")) %>% 
  droplevels()
i_gap$country %>% levels()
i_gap$country %>%
  fct_recode("USA" = "United States", "Oz" = "Australia") %>% levels()
