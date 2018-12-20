# http://stat545.com/block012_function-regress-lifeexp-on-year.html

# Load the Gapminder data
library(gapminder)
library(ggplot2)
suppressPackageStartupMessages(library(dplyr))

j_country <- "France" # pick, but do not hard wire, an example
(j_dat <- gapminder %>% 
    filter(country == j_country))
p <- ggplot(j_dat, aes(x = year, y = lifeExp))
p + geom_point() + geom_smooth(method = "lm", se = FALSE)

j_fit <- lm(lifeExp ~ year, j_dat)
coef(j_fit)
##  (Intercept)         year 
## -397.7646019    0.2385014

j_fit <- lm(lifeExp ~ I(year - 1952), j_dat)
coef(j_fit)
##    (Intercept) I(year - 1952) 
##     67.7901282      0.2385014

# Turn working code into a function
le_lin_fit <- function(dat, offset = 1952) {
  the_fit <- lm(lifeExp ~ I(year - offset), dat)
  coef(the_fit)
}
le_lin_fit(j_dat)
##      (Intercept) I(year - offset) 
##       67.7901282        0.2385014

le_lin_fit <- function(dat, offset = 1952) {
  the_fit <- lm(lifeExp ~ I(year - offset), dat)
  setNames(coef(the_fit), c("intercept", "slope"))
}
le_lin_fit(j_dat)
##  intercept      slope 
## 67.7901282  0.2385014

# Test on other data and in a clean workspace
j_country <- "Zimbabwe"
(j_dat <- gapminder %>% filter(country == j_country))
p <- ggplot(j_dat, aes(x = year, y = lifeExp))
p + geom_point() + geom_smooth(method = "lm", se = FALSE)
le_lin_fit(j_dat)
##   intercept       slope 
## 55.22124359 -0.09302098

# final test by cleaning up environemnt
rm(list = ls())
le_lin_fit <- function(dat, offset = 1952) {
  the_fit <- lm(lifeExp ~ I(year - offset), dat)
  setNames(coef(the_fit), c("intercept", "slope"))
}
le_lin_fit(gapminder %>% filter(country == "Zimbabwe"))
##   intercept       slope 
## 55.22124359 -0.09302098