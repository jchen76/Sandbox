## https://github.com/jennybc/lotr-tidy#readme

library(tidyverse)
library(gapminder)

lotr_tidy <- as.tibble(read.csv("lotr-tidy-data/lotr-tidy.csv", header=TRUE))
lotr_tidy

# What's the total number of words spoken by male hobbits?
lotr_tidy %>% 
  count(Race, wt=Words)

# Does a certain race dominate a movie? Does the dominant race differ across the movies?
(by_race_film <- lotr_tidy %>% 
  group_by(Film, Race) %>% 
  summarise(Words = sum(Words)) %>% 
  arrange(Film,desc(Words)))
p <- ggplot(by_race_film %>% top_n(3), aes(x = Film, y = Words, fill = Race))
p + geom_bar(stat = "identity", position = "dodge") +
  coord_flip() + guides(fill = guide_legend(reverse = TRUE))
