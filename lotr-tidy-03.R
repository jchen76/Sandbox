## https://github.com/jennybc/lotr-tidy/blob/master/03-spread.md

library(tidyverse)
library(gapminder)

# read data
lotr_tidy <- read_csv(file.path("lotr-tidy-data", "lotr_tidy.csv"))
lotr_tidy

## practicing with spread: let's get one variable per Race
lotr_tidy %>% 
  spread(key = Race, value = Words)
## practicing with spread: let's get one variable per Gender
lotr_tidy %>% 
  spread(key = Gender, value = Words)
## practicing with spread ... and unite: let's get one variable per combo of Race and Gender
lotr_tidy %>% 
  unite(Race_Gender, Race, Gender) %>% 
  spread(key = Race_Gender, value = Words)
