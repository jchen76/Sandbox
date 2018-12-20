# http://stat545.com/block011_write-your-own-function-02.html

library(gapminder)

mmm <- function(x) {
  stopifnot(is.numeric(x))
  max(x) - min(x)
}

# quantile function
quantile(gapminder$lifeExp)
##      0%     25%     50%     75%    100% 
## 23.5990 48.1980 60.7125 70.8455 82.6030
quantile(gapminder$lifeExp, probs = 0.5)
##     50% 
## 60.7125
median(gapminder$lifeExp)
## [1] 60.7125
quantile(gapminder$lifeExp, probs = c(0.25, 0.75))
##     25%     75% 
## 48.1980 70.8455
boxplot(gapminder$lifeExp, plot = FALSE)$stats

the_probs <- c(0.25, 0.75)
the_quantiles <- quantile(gapminder$lifeExp, probs = the_probs)
max(the_quantiles) - min(the_quantiles)
## [1] 22.6475

qdiff1 <- function(x, probs) {
  stopifnot(is.numeric(x))
  the_quantiles <- quantile(x = x, probs = probs)
  max(the_quantiles) - min(the_quantiles)
}
qdiff1(gapminder$lifeExp, probs = c(0.25, 0.75))
## [1] 22.6475
IQR(gapminder$lifeExp) # hey, we've reinvented IQR
## [1] 22.6475
qdiff1(gapminder$lifeExp, probs = c(0, 1))
## [1] 59.004
mmm(gapminder$lifeExp)
## [1] 59.004

qdiff2 <- function(zeus, hera) {
  stopifnot(is.numeric(zeus))
  the_quantiles <- quantile(x = zeus, probs = hera)
  return(max(the_quantiles) - min(the_quantiles))
}
qdiff2(zeus = gapminder$lifeExp, hera = 0:1)
## [1] 59.004

qdiff1
## function(x, probs) {
##   stopifnot(is.numeric(x))
##   the_quantiles <- quantile(x = x, probs = probs)
##   max(the_quantiles) - min(the_quantiles)
## }
## <bytecode: 0x7fdb289c3d38>

# Default values: freedom to NOT specify the arguments
qdiff1(gapminder$lifeExp)
## Error in quantile(x = x, probs = probs): argument "probs" is missing, with no default
qdiff3 <- function(x, probs = c(0, 1)) {
  stopifnot(is.numeric(x))
  the_quantiles <- quantile(x, probs)
  return(max(the_quantiles) - min(the_quantiles))
}
qdiff3(gapminder$lifeExp)
## [1] 59.004
mmm(gapminder$lifeExp)
## [1] 59.004
qdiff3(gapminder$lifeExp, c(0.1, 0.9))
## [1] 33.5862
qdiff3

qdiff4 <- function(x, probs = c(0, 1)) {
  if (!is.numeric(x)) {
    stop('I am so sorry, but this function only works for numeric input!\n',
         'You have provided an object of class: ', class(x)[1])
  } else if (!is.numeric(probs)) {
    stop('I am so sorry, but this function only works for numeric quantile!\n',
         'You have provided a quantile of class: ', class(probs)[1])
  } else if (any(probs > 1) || any(probs < 0)) {
    stop('probs has to be between 0 and 1!\n',
         'You have ', probs)
  }
  the_quantiles <- quantile(x, probs)
  return(max(the_quantiles) - min(the_quantiles))
}
# probs are numeric
qdiff4(gapminder$lifeExp, 'not numeric')
# probs are in [0,1]
qdiff4(gapminder$lifeExp, c(-1))
qdiff4(gapminder$lifeExp, c(2))
# probs length is not limited to 2
qdiff4(gapminder$lifeExp, c(0, 0.75))
qdiff4(gapminder$lifeExp, c(0, 0.25, 0.75))
