# http://stat545.com/block024_group-nest-split-map.html

library(gapminder)
library(tidyverse)

# group_by
gapminder %>%
  group_by(continent) %>%
  summarize_each(funs(min, max), lifeExp)

# nesting
(gap_nested <- gapminder %>% 
    group_by(continent, country) %>% 
    nest())
gap_nested[[1, "data"]]

# apply map() and mutate()
(fit <- lm(lifeExp ~ I(year - 1950), data = gap_nested[[1, "data"]]))
# define a function
le_vs_yr <- function(df) {
  lm(lifeExp ~ I(year - 1950), data = df)
}
le_vs_yr(gap_nested[[1, "data"]])
# apply map()
fits <- map(gap_nested$data[1:2], le_vs_yr)
fits
# put all together
(gap_nested <- gap_nested %>% 
    mutate(fit = map(data, le_vs_yr)))

# simplify and combine
library(broom)
tidy(gap_nested$fit[[1]])
# add as a new variable
(gap_nested <- gap_nested %>% 
    mutate(tidy = map(fit, tidy)))
# unset them
(gap_coefs <- gap_nested %>% 
    select(continent, country, tidy) %>% 
    unnest(tidy))

# summary
gap_nested <- gapminder %>% 
  group_by(continent, country) %>% 
  nest()

le_vs_yr <- function(df) {
  lm(lifeExp ~ I(year - 1950), data = df)
}

gap_coefs <- gap_nested %>% 
  mutate(fit = map(data, le_vs_yr),
         tidy = map(fit, tidy)) %>% 
  select(continent, country, tidy) %>% 
  unnest(tidy)

# finishing up
(gap_coefs <- gap_coefs %>%
    mutate(term = recode(term,
                         `(Intercept)` = "intercept",
                         `I(year - 1950)` = "slope")))
(gap_ests <- gap_coefs %>% 
    select(continent:estimate) %>% 
    spread(key = term, value = estimate))
gap_ests %>% 
  select(intercept, slope) %>% 
  summary()
ggplot(gap_coefs, aes(x = estimate)) +
  geom_density() + geom_rug() + facet_wrap(~ term, scales = "free")
ggplot(gap_ests, aes(x = intercept, y = slope)) +
  geom_point() +
  geom_smooth(se = FALSE, lwd = 2)
