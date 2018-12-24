# http://stat545.com/block016_secrets-happy-graphing.html

library(gapminder)
library(tidyverse)

# Hidden data wrangling problems
# If you are struggling to make a figure, don’t assume it’s a problem between you and ggplot2.
# Stop and ask yourself which of these rules you are breaking:
# + Keep stuff in data frames
# + Keep your data frames tidy; be willing to reshape your data often
# + Use factors and be the boss of them

# Keep stuff in data frames
# error example
life_exp <- gapminder$lifeExp
year <- gapminder$year
ggplot(aes(x = year, y = life_exp)) + geom_jitter()
#> Error: ggplot2 doesn't know how to deal with data of class uneval

ggplot(data = gapminder, aes(x = year, y = life_exp)) + geom_jitter()

# Explicit data frame creation via tibble::tibble() and tribble()
# The tibble() function is an improved version of the built-in data.frame(), which makes it possible
# to define one variable in terms of another and which won’t turn character data into factor.
my_dat <-
  tibble(x = 1:5,
         y = x ^ 2,
         text = c("alpha", "beta", "gamma", "delta", "epsilon"))
my_dat
## if you're truly "hand coding", tribble() is an alternative
my_dat <- tribble(
  ~ x, ~ y,    ~ text,
  1,   1,   "alpha",
  2,   4,    "beta",
  3,   9,   "gamma",
  4,  16,   "delta",
  5,  25, "epsilon"
)
str(my_dat)
#> Classes 'tbl_df', 'tbl' and 'data.frame':    5 obs. of  3 variables:
#>  $ x   : num  1 2 3 4 5
#>  $ y   : num  1 4 9 16 25
#>  $ text: chr  "alpha" "beta" "gamma" "delta" ...
ggplot(my_dat, aes(x, y)) + geom_line() + geom_text(aes(label = text))

# Sidebar: with(). Sadly, not all functions offer a data = argument.
cor(year, lifeExp, data = gapminder)
#> Error in cor(year, lifeExp, data = gapminder): unused argument (data = gapminder)
cor(gapminder$year, gapminder$lifeExp)
#> [1] 0.4356112

with(gapminder,
     cor(year, lifeExp))
#> [1] 0.4356112

library(magrittr)
#> 
#> Attaching package: 'magrittr'
#> The following object is masked from 'package:purrr':
#> 
#>     set_names
#> The following object is masked from 'package:tidyr':
#> 
#>     extract
gapminder %$%
  cor(year, lifeExp)
#> [1] 0.4356112

# Worked example: How can I focus in on country, Japan for example, and plot all the quantitative variables against year?
# Reshape your data
library(tidyr)
japan_dat <- gapminder %>%
  filter(country == "Japan")
japan_tidy <- japan_dat %>%
  gather(key = var, value = value, pop, lifeExp, gdpPercap)
dim(japan_dat)
#> [1] 12  6
dim(japan_tidy)
#> [1] 36  5

# Iterate over the variables via facetting
p <- ggplot(japan_tidy, aes(x = year, y = value)) +
  facet_wrap(~ var, scales="free_y")
p + geom_point() + geom_line() +
  scale_x_continuous(breaks = seq(1950, 2011, 15))

# Recap
japan_tidy <- gapminder %>%
  filter(country == "Japan") %>%
  gather(key = var, value = value, pop, lifeExp, gdpPercap)
ggplot(japan_tidy, aes(x = year, y = value)) +
  facet_wrap(~ var, scales="free_y") +
  geom_point() + geom_line() +
  scale_x_continuous(breaks = seq(1950, 2011, 15))