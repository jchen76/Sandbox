# http://stat545.com/block026_file-out-in.html
# My main import advice: use the arguments of your import function to get as far as you can,
# as fast as possible. 

library(gapminder)
library(tidyverse)
library(forcats)

# import
(gap_tsv <- system.file("gapminder.tsv", package = "gapminder"))
gapminder <- read_tsv(gap_tsv)
str(gapminder, give.attr = FALSE)
# convert into factor
gapminder <- gapminder %>%
  mutate(country = factor(country),
         continent = factor(continent))
str(gapminder)

# export
gap_life_exp <- gapminder %>%
  group_by(country, continent) %>% 
  summarise(life_exp = max(lifeExp)) %>% 
  ungroup()
gap_life_exp
write_csv(gap_life_exp, "gap_life_exp.csv")

# reorder factors does not reorder data
head(gap_life_exp)
head(levels(gap_life_exp$country)) # alphabetical order
gap_life_exp <- gap_life_exp %>% 
  mutate(country = fct_reorder(country, life_exp))
head(levels(gap_life_exp$country)) # in increasing order of maximum life expectancy
head(gap_life_exp)

# saveRDS() and readRDS()
# related command but do not consider: save() + load() and even save.image()
saveRDS(gap_life_exp, "gap_life_exp.rds")
rm(gap_life_exp)
gap_life_exp
gap_life_exp <- readRDS("gap_life_exp.rds")
gap_life_exp

# Retaining factor levels upon re-import
(country_levels <- tibble(original = head(levels(gap_life_exp$country))))
saveRDS(gap_life_exp, "gap_life_exp.rds")
rm(gap_life_exp)
head(gap_life_exp) # will cause error! proving gfits is really gone 
gap_via_csv <- read_csv("gap_life_exp.csv") %>% 
  mutate(country = factor(country))
gap_via_rds <- readRDS("gap_life_exp.rds")
country_levels <- country_levels %>% 
  mutate(via_csv = head(levels(gap_via_csv$country)),
         via_rds = head(levels(gap_via_rds$country)))
country_levels

# dput() and dget()
gap_life_exp <- readRDS("gap_life_exp.rds")
dput(gap_life_exp, "gap_life_exp-dput.txt")
gap_life_exp_dget <- dget("gap_life_exp-dput.txt")
country_levels <- country_levels %>% 
  mutate(via_dput = head(levels(gap_life_exp_dget$country)))
country_levels
# dput() can be helpful for producing the piece of code that defines the object.
# If you dput() without specifying a file, you can copy the return value from Console and
# paste into a script. Or you can write to file and copy from there or add R commands below.

# clean up
file.remove(list.files(pattern = "^gap_life_exp"))
