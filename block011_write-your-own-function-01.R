# http://stat545.com/block011_write-your-own-function-01.html

library(gapminder)
str(gapminder)

# Max - min
min(gapminder$lifeExp)
max(gapminder$lifeExp)
range(gapminder$lifeExp)

## some natural solutions
max(gapminder$lifeExp) - min(gapminder$lifeExp)
with(gapminder, max(lifeExp) - min(lifeExp))
range(gapminder$lifeExp)[2] - range(gapminder$lifeExp)[1]
with(gapminder, range(lifeExp)[2] - range(lifeExp)[1])
diff(range(gapminder$lifeExp))

# Turn the working interactive code into a function
max_minus_min <- function(x) max(x) - min(x)
max_minus_min(gapminder$lifeExp)
max_minus_min(1:10)
max_minus_min(runif(1000))
max_minus_min(gapminder$gdpPercap)
max_minus_min(gapminder$pop)

# Test on weird stuff
max_minus_min(gapminder) ## hey sometimes things "just work" on data.frames!
max_minus_min(gapminder$country) ## factors are kind of like integer vectors, no?
max_minus_min("eggplants are purple") ## i have no excuse for this one

# I will scare you now
max_minus_min(gapminder[c('lifeExp', 'gdpPercap', 'pop')])
max_minus_min(c(TRUE, TRUE, FALSE, TRUE, TRUE))

# Check the validity of arguments, stopifnot
mmm <- function(x) {
  stopifnot(is.numeric(x))
  max(x) - min(x)
}
mmm(gapminder)
## Error in mmm(gapminder): is.numeric(x) is not TRUE
mmm(gapminder$country)
## Error in mmm(gapminder$country): is.numeric(x) is not TRUE
mmm("eggplants are purple")
## Error in mmm("eggplants are purple"): is.numeric(x) is not TRUE
mmm(gapminder[c('lifeExp', 'gdpPercap', 'pop')])
## Error in mmm(gapminder[c("lifeExp", "gdpPercap", "pop")]): is.numeric(x) is not TRUE
mmm(c(TRUE, TRUE, FALSE, TRUE, TRUE))
## Error in mmm(c(TRUE, TRUE, FALSE, TRUE, TRUE)): is.numeric(x) is not TRUE

# if, stop
mmm2 <- function(x) {
  if(!is.numeric(x)) {
    stop('I am so sorry, but this function only works for numeric input!\n',
         'You have provided an object of class: ', class(x)[1])
  }
  max(x) - min(x)
}
mmm2(gapminder)
