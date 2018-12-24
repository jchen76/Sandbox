# http://stat545.com/block019_enforce-color-scheme.html

# Load packages and prepare the Gapminder data
library(ggplot2)
library(gapminder)
suppressPackageStartupMessages(library(dplyr))
jdat <- gapminder %>% 
  filter(continent != "Oceania") %>% 
  droplevels() %>% 
  mutate(country = reorder(country, -1 * pop)) %>% 
  arrange(year, country)

# Take control of the size and color of points
j_year <- 2007
q <-
  jdat %>% 
  filter(year == j_year) %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  scale_x_log10(limits = c(230, 63000))
q + geom_point()

## do I have control of size and fill color? YES!
q + geom_point(pch = 21, size = 8, fill = I("darkorchid1"))

# Circle area = population
q + geom_point(aes(size = pop), pch = 21)
(r <- q +
    geom_point(aes(size = pop), pch = 21, show.legend = FALSE) +
    scale_size_continuous(range = c(1,40)))

# Circle fill color determined by a factor
(r <- r + facet_wrap(~ continent) + ylim(c(39, 87)))
r + aes(fill = continent)

# Get the color scheme for the countries
str(country_colors)
#>  Named chr [1:142] "#7F3B08" "#833D07" "#873F07" "#8B4107" ...
#>  - attr(*, "names")= chr [1:142] "Nigeria" "Egypt" "Ethiopia" "Congo, Dem. Rep." ...
head(country_colors)
#>          Nigeria            Egypt         Ethiopia Congo, Dem. Rep. 
#>        "#7F3B08"        "#833D07"        "#873F07"        "#8B4107" 
#>     South Africa            Sudan 
#>        "#8F4407"        "#934607"

# Prepare the color scheme for use with ggplot2
# Make the ggplot2 bubble chart
r + aes(fill = country) + scale_fill_manual(values = country_colors)

# All together now
j_year <- 2007
jdat %>% 
  filter(year == j_year) %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp, fill = country)) +
  scale_fill_manual(values = country_colors) +
  facet_wrap(~ continent) +
  geom_point(aes(size = pop), pch = 21, show.legend = FALSE) +
  scale_x_log10(limits = c(230, 63000)) +
  scale_size_continuous(range = c(1,40)) + ylim(c(39, 87))
