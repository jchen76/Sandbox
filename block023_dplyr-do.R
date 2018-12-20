# http://stat545.com/block023_dplyr-do.html

# Computing by groups within data.frames with dplyr and broom

#There are three main options for data aggregation:
# + base R functions, often referred to as the apply family of functions
# + the plyr add-on package
# + the dplyr add-on package

suppressPackageStartupMessages(library(dplyr))
library(gapminder)
library(magrittr)
library(ggplot2)

gapminder %>%
  tbl_df() %>%
  glimpse()

gapminder %>%
  group_by(continent) %>%
  summarize(avg_lifeExp = mean(lifeExp))

qdiff <- function(x, probs = c(0, 1), na.rm = TRUE) {
  the_quantiles <- quantile(x = x, probs = probs, na.rm = na.rm)
  return(max(the_quantiles) - min(the_quantiles))
}
qdiff(gapminder$lifeExp)
#> [1] 59.004

## on the whole dataset
gapminder %>%
  summarize(qdiff = qdiff(lifeExp))
## on each continent
gapminder %>%
  group_by(continent) %>%
  summarize(qdiff = qdiff(lifeExp))
## on each continent, specifying which quantiles
gapminder %>%
  group_by(continent) %>%
  summarize(qdiff = qdiff(lifeExp, probs = c(0.2, 0.8)))

# What if we want something other than 1 number back from each group?
gapminder %>%
  group_by(continent) %>%
  summarize(range = range(lifeExp))
#> Error in eval(expr, envir, enclos): expecting a single value

# If the thing you compute is an unnamed data.frame, they get row-bound together, with the grouping variables retained.
gapminder %>%
  filter(year == 2007) %>% 
  group_by(continent) %>%
  do(head(., 2))

# Challenge: Modify the example above to get the 10th most populous country in 2002 for each continent
# Oops, where did Oceania go?
gapminder %>% 
  filter(year == 2002) %>% 
  group_by(continent) %>% 
  arrange(desc(pop)) %>% 
  do(slice(., 10))
gapminder %>% 
  filter(year == 2002) %>% 
  group_by(continent) %>% 
  filter(min_rank(desc(pop)) == 10)

# What if thing(s) computed within do() are not data.frame? What if we name it?
gapminder %>%
  group_by(continent) %>%
  do(range = range(.$lifeExp)) %T>% str

# Challenge: Create a data.frame with named 3 variables: 
# continent, a variable for mean life expectancy, a list-column holding the typical 
# five number summary of GDP per capita. Inspect an individual row, e.g. for Europe. 
# Try to get at the mean life expectancy and the five number summary of GDP per capita.
(chal01 <- gapminder %>%
    group_by(continent) %>%
    do(mean = mean(.$lifeExp),
       fivenum = summary(.$gdpPercap)))
chal01[4, ]
chal01[[4, "mean"]]
chal01[[4, "fivenum"]]

# Fit a linear regression within country
ggplot(gapminder, aes(x = year, y = lifeExp)) +
  geom_jitter() +
  geom_smooth(lwd = 3, se = FALSE, method = "lm")
# overall correlation between year and lifeExp
(ov_cor <- gapminder %$%
    cor(year, lifeExp))
#> [1] 0.4356112
# correlation by country
(gcor <- gapminder %>%
    group_by(country) %>%
    summarize(correlation = cor(year, lifeExp)))
ggplot(gcor, aes(x = correlation)) +
  geom_density() +
  geom_vline(xintercept = ov_cor, linetype = "longdash") +
  geom_text(data = NULL, x = ov_cor, y = 10, label = round(ov_cor, 2),
            hjust = -0.1)

le_lin_fit <- function(dat, offset = 1952) {
  the_fit <- lm(lifeExp ~ I(year - offset), dat)
  setNames(coef(the_fit), c("intercept", "slope"))
}

le_lin_fit(gapminder %>% filter(country == "Canada"))
#>  intercept      slope 
#> 68.8838462  0.2188692
ggplot(gapminder %>% filter(country == "Canada"),
       aes(x = year, y = lifeExp)) +
  geom_smooth(lwd = 1.3, se = FALSE, method = "lm") +
  geom_point()

# return data.frame rather than a numeric vector for Canada.
le_lin_fit <- function(dat, offset = 1952) {
  the_fit <- lm(lifeExp ~ I(year - offset), dat)
  setNames(data.frame(t(coef(the_fit))), c("intercept", "slope"))
}
le_lin_fit(gapminder %>% filter(country == "Canada"))

# apply to all countries.
gfits_me <- gapminder %>%
  group_by(country) %>% 
  do(le_lin_fit(.))
gfits_me

# summarized script.
library(dplyr)
library(gapminder)
le_lin_fit <- function(dat, offset = 1952) {
  the_fit <- lm(lifeExp ~ I(year - offset), dat)
  setNames(data.frame(t(coef(the_fit))), c("intercept", "slope"))
}
gfits_me <- gapminder %>%
  group_by(country, continent) %>% 
  do(le_lin_fit(.))

# What do you expect to be true about the intercepts? What does the intercept mean? What min and max do you expect.
ggplot(gfits_me, aes(x = intercept)) + geom_density() + geom_rug()
# What do you expect to be true about the slopes? What sign are you expecting to see?
ggplot(gfits_me, aes(x = slope)) + geom_density() + geom_rug()
# What relationship do you expect between intercept and slopes?
ggplot(gfits_me, aes(x = intercept, y = slope)) +
  geom_point() +
  geom_smooth(se = FALSE)

# Meet the broom package
## install.packages("broom")
library(broom)

gfits_broom <- gapminder %>%
  group_by(country, continent) %>% 
  do(tidy(lm(lifeExp ~ I(year - 1952), data = .)))
gfits_broom 

# If we want to use some other broom functions for working with models, it’s convenient if we store the fits first.
fits <- gapminder %>% 
  group_by(country, continent) %>%
  do(fit = lm(lifeExp ~ I(year - 1952), .))
fits
## one row per country, overall model stuff
fits %>% 
  glance(fit)
## one row per country per parameter estimate, statistical inference stuff
fits %>% 
  tidy(fit)
## one row per original observation, giving fitted value, residual, etc.
fits %>% 
  augment(fit)
