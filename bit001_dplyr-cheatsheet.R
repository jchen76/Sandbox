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
# inner_join(x, y): Return all rows from x where there are matching values in y,
# and all columns from x and y.
(ijsp <- inner_join(superheroes, publishers))
(ijps <- inner_join(publishers, superheroes))

## semi_join(superheroes, publishers)
# semi_join(x, y): Return all rows from x where there are matching values in y,
# keeping just columns from x.
(sjsp <- semi_join(superheroes, publishers))
(sjps <- semi_join(x = publishers, y = superheroes))

## left_join(superheroes, publishers)
# left_join(x, y): Return all rows from x, and all columns from x and y.
(ljsp <- left_join(superheroes, publishers))
(ljps <- left_join(publishers, superheroes))

## anti_join(superheroes, publishers)
# anti_join(x, y): Return all rows from x where there are not matching values in y,
# keeping just columns from x.
(ajsp <- anti_join(superheroes, publishers))
(ajps <- anti_join(publishers, superheroes))

## full_join(superheroes, publishers)
# full_join(x, y): Return all rows and all columns from both x and y.
(fjsp <- full_join(superheroes, publishers))

library(devtools)
devtools::session_info()
#> Session info -------------------------