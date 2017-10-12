## http://stat545.com/bit001_dplyr-cheatsheet.html

#suppressPackageStartupMessages(library(dplyr))
library(readr)

superheroes <- "
    name, alignment, gender,         publisher
 Magneto,       bad,   male,            Marvel
   Storm,      good, female,            Marvel
Mystique,       bad, female,            Marvel
  Batman,      good,   male,                DC
   Joker,       bad,   male,                DC
Catwoman,       bad, female,                DC
 Hellboy,      good,   male, Dark Horse Comics
"
superheroes <- read_csv(superheroes, trim_ws = TRUE, skip = 1)

publishers <- "
  publisher, yr_founded
         DC,       1934
     Marvel,       1939
      Image,       1992
"
publishers <- read_csv(publishers, trim_ws = TRUE, skip = 1)

## inner_join(superheroes, publishers)
(ijsp <- inner_join(superheroes, publishers))
(ijps <- inner_join(publishers, superheroes))

## semi_join(superheroes, publishers)
(sjsp <- semi_join(superheroes, publishers))
(sjps <- semi_join(x = publishers, y = superheroes))

## left_join(superheroes, publishers)
(ljsp <- left_join(superheroes, publishers))
(ljps <- left_join(publishers, superheroes))

## anti_join(superheroes, publishers)
(ajsp <- anti_join(superheroes, publishers))
(ajps <- anti_join(publishers, superheroes))

## full_join(superheroes, publishers)
(fjsp <- full_join(superheroes, publishers))

library(devtools)
devtools::session_info()
#> Session info -------------------------