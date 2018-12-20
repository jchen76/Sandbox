# http://stat545.com/block011_write-your-own-function-03.html

library(gapminder)

qdiff3 <- function(x, probs = c(0, 1)) {
  stopifnot(is.numeric(x))
  the_quantiles <- quantile(x, probs)
  return(max(the_quantiles) - min(the_quantiles))
}

# Be proactive about NAs
z <- gapminder$lifeExp
z[3] <- NA
quantile(gapminder$lifeExp)
##      0%     25%     50%     75%    100% 
## 23.5990 48.1980 60.7125 70.8455 82.6030
quantile(z)
## Error in quantile.default(z): missing values and NaN's not allowed if 'na.rm' is FALSE
quantile(z, na.rm = TRUE)
##     0%    25%    50%    75%   100% 
## 23.599 48.228 60.765 70.846 82.603

qdiff4 <- function(x, probs = c(0, 1)) {
  stopifnot(is.numeric(x))
  the_quantiles <- quantile(x, probs, na.rm = TRUE)
  return(max(the_quantiles) - min(the_quantiles))
}
qdiff4(gapminder$lifeExp)
## [1] 59.004
qdiff4(z)
## [1] 59.004

qdiff5 <- function(x, probs = c(0, 1), na.rm = TRUE) {
  stopifnot(is.numeric(x))
  the_quantiles <- quantile(x, probs, na.rm = na.rm)
  return(max(the_quantiles) - min(the_quantiles))
}
qdiff5(gapminder$lifeExp)
## [1] 59.004
qdiff5(z)
## [1] 59.004
qdiff5(z, na.rm = FALSE)
## Error in quantile.default(x, probs, na.rm = na.rm): missing values and NaN's not allowed if 'na.rm' is FALSE

# The useful but mysterious ... argument
qdiff6 <- function(x, probs = c(0, 1), na.rm = TRUE, ...) {
  the_quantiles <- quantile(x = x, probs = probs, na.rm = na.rm, ...)
  return(max(the_quantiles) - min(the_quantiles))
}

set.seed(1234)
z <- rnorm(10)
quantile(z, type = 1)
##         0%        25%        50%        75%       100% 
## -2.3456977 -0.8900378 -0.5644520  0.4291247  1.0844412
quantile(z, type = 4)
##        0%       25%       50%       75%      100% 
## -2.345698 -1.048552 -0.564452  0.353277  1.084441
all.equal(quantile(z, type = 1), quantile(z, type = 4))
## [1] "Mean relative difference: 0.1776594"

qdiff6(z, probs = c(0.25, 0.75), type = 1)
## [1] 1.319163
qdiff6(z, probs = c(0.25, 0.75), type = 4)
## [1] 1.401829

# Use testthat for formal unit tests
library(testthat)

test_that('invalid args are detected', {
  expect_error(qdiff6("eggplants are purple"))
  expect_error(qdiff6(iris))
})

test_that('NA handling works', {
  expect_error(qdiff6(c(1:5, NA), na.rm = FALSE))
  expect_equal(qdiff6(c(1:5, NA)), 4)
})

qdiff_no_NA <- function(x, probs = c(0, 1)) {
  the_quantiles <- quantile(x = x, probs = probs)
  return(max(the_quantiles) - min(the_quantiles))
}

test_that('NA handling works', {
  expect_that(qdiff_no_NA(c(1:5, NA)), equals(4))
})
