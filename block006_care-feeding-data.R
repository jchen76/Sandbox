# http://stat545.com/block006_care-feeding-data.html

install.packages("gapminder")
install.packages("tidyverse")

library(gapminder)
str(gapminder)
library(tidyverse)
class(gapminder)
gapminder
head(gapminder)
tail(gapminder)
as_tibble(iris)
names(gapminder)
ncol(gapminder)
nrow(gapminder)
dim(gapminder)
length(gapminder)

summary(gapminder)
plot(lifeExp ~ year, gapminder)
plot(lifeExp ~ gdpPercap, gapminder)
plot(lifeExp ~ log(gdpPercap), gapminder)

# Look at the variables inside a data frame
head(gapminder$lifeExp)
summary(gapminder$lifeExp)
hist(gapminder$lifeExp)

summary(gapminder$year)
table(gapminder$year)

class(gapminder$continent)
summary(gapminder$continent)
levels(gapminder$continent)
nlevels(gapminder$continent)
str(gapminder$continent)
barplot(table(gapminder$continent))

p <- ggplot(filter(gapminder, continent != "Oceania"),
            aes(x = gdpPercap, y = lifeExp)) # just initializes
p <- p + scale_x_log10() # log the x axis the right way
p + geom_point() # scatterplot
p + geom_point(aes(color = continent)) # map continent to color
p + geom_point(alpha = (1/3), size = 3) + geom_smooth(lwd = 3, se = FALSE)
p + geom_point(alpha = (1/3), size = 3) + facet_wrap(~ continent) +
  geom_smooth(lwd = 1.5, se = FALSE)
