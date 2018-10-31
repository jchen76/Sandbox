# http://stat545.com/block004_basic-r-objects.html

x <- 3 * 4
x
#> [1] 12
is.vector(x)
#> [1] TRUE
length(x)
#> [1] 1
x[2] <- 100
x
#> [1]  12 100
x[5] <- 3
x
#> [1]  12 100  NA  NA   3
x[11]
#> [1] NA
x[0]
#> numeric(0)

x <- 1:4
## which would you rather write and read?
## the vectorized version ...
(y <- x^2) 
#> [1]  1  4  9 16
## or the for loop version?
z <- vector(mode = mode(x), length = length(x))
for(i in seq_along(x)) {
  z[i] <- x[i]^2
}
identical(y, z)
#> [1] TRUE

set.seed(1999)
rnorm(5, mean = 10^(1:5))
#> [1]     10.73267     99.96217   1001.20301  10001.46980 100000.13369
round(rnorm(5, sd = 10^(0:4)), 2)
#> [1]     0.52    -5.49  -118.56 -1147.28 11607.42

# auto recycling
(y <- 1:3)
#> [1] 1 2 3
(z <- 3:7)
#> [1] 3 4 5 6 7
y + z
#> Warning in y + z: longer object length is not a multiple of shorter object
#> length
#> [1] 4 6 8 7 9
(y <- 1:10)
#>  [1]  1  2  3  4  5  6  7  8  9 10
(z <- 3:7)
#> [1] 3 4 5 6 7
y + z
#>  [1]  4  6  8 10 12  9 11 13 15 17

# catenate function c()
str(c("hello", "world"))
#>  chr [1:2] "hello" "world"
str(c(1:3, 100, 150))
#>  num [1:5] 1 2 3 100 150

# vector requires to be the same object type, with minimum coreceation.
(x <- c("cabbage", pi, TRUE, 4.3))
#> [1] "cabbage"          "3.14159265358979" "TRUE"            
#> [4] "4.3"
str(x)
#>  chr [1:4] "cabbage" "3.14159265358979" "TRUE" "4.3"
length(x)
#> [1] 4
mode(x)
#> [1] "character"
class(x)
#> [1] "character"

# atomic vector types
# logical: TRUE’s AND FALSE’s, easily coerced into 1’s and 0’s
# numeric: numbers and, yes, integers and double-precision floating point numbers are different but you can live happily for a long time without worrying about this
# character

n <- 8
set.seed(1)
(w <- round(rnorm(n), 2)) # numeric floating point
#> [1] -0.63  0.18 -0.84  1.60  0.33 -0.82  0.49  0.74
(x <- 1:n) # numeric integer
#> [1] 1 2 3 4 5 6 7 8
## another way to accomplish by hand is x <- c(1, 2, 3, 4, 5, 6, 7, 8)
(y <- LETTERS[1:n]) # character
#> [1] "A" "B" "C" "D" "E" "F" "G" "H"
(z <- runif(n) > 0.3) # logical
#> [1]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE FALSE

str(w)
#>  num [1:8] -0.63 0.18 -0.84 1.6 0.33 -0.82 0.49 0.74
length(x)
#> [1] 8
# is.xxx family of functions
is.logical(y)
#> [1] FALSE
# as.xxx family of functions
as.numeric(z)
#> [1] 1 1 1 1 1 0 1 0

# indexing a vector
w
#> [1] -0.63  0.18 -0.84  1.60  0.33 -0.82  0.49  0.74
names(w) <- letters[seq_along(w)]
w
#>     a     b     c     d     e     f     g     h 
#> -0.63  0.18 -0.84  1.60  0.33 -0.82  0.49  0.74
w < 0
#>     a     b     c     d     e     f     g     h 
#>  TRUE FALSE  TRUE FALSE FALSE  TRUE FALSE FALSE
which(w < 0)
#> a c f 
#> 1 3 6
w[w < 0]
#>     a     c     f 
#> -0.63 -0.84 -0.82
seq(from = 1, to = length(w), by = 2)
#> [1] 1 3 5 7
w[seq(from = 1, to = length(w), by = 2)]
#>     a     c     e     g 
#> -0.63 -0.84  0.33  0.49
w[-c(2, 5)]
#>     a     c     d     f     g     h 
#> -0.63 -0.84  1.60 -0.82  0.49  0.74
w[c('c', 'a', 'f')]
#>     c     a     f 
#> -0.84 -0.63 -0.82

# list
## earlier: a <- c("cabbage", pi, TRUE, 4.3)
(a <- list("cabbage", pi, TRUE, 4.3))
#> [[1]]
#> [1] "cabbage"
#> 
#> [[2]]
#> [1] 3.141593
#> 
#> [[3]]
#> [1] TRUE
#> 
#> [[4]]
#> [1] 4.3
str(a)
#> List of 4
#>  $ : chr "cabbage"
#>  $ : num 3.14
#>  $ : logi TRUE
#>  $ : num 4.3
length(a)
#> [1] 4
mode(a)
#> [1] "list"
class(a)
#> [1] "list"
names(a)
#> NULL
names(a) <- c("veg", "dessert", "myAim", "number")
a
#> $veg
#> [1] "cabbage"
#> 
#> $dessert
#> [1] 3.141593
#> 
#> $myAim
#> [1] TRUE
#> 
#> $number
#> [1] 4.3
a <- list(veg = "cabbage", dessert = pi, myAim = TRUE, number = 4.3)
names(a)
#> [1] "veg"     "dessert" "myAim"   "number"

# Indexing a list is similar to indexing a vector but it is necessarily more complex.
# The fundamental issue is this: if you request a single element from the list,
# do you want a list of length 1 containing only that element or do you want the element itself?
# For the former (desired return value is a list), we use single square brackets, [ and ],
# just like indexing a vector. For the latter (desired return value is a single element),
# we use a dollar sign $, which you’ve already used to get one variable from a data.frame,
# or double square brackets,  [[ and ]].
(a <- list(veg = c("cabbage", "eggplant"),
           tNum = c(pi, exp(1), sqrt(2)),
           myAim = TRUE,
           joeNum = 2:6))
str(a)
length(a)
class(a)
mode(a)

# get single list element
a[[2]] # index with a positive integer
#> [1] 3.141593 2.718282 1.414214
a$myAim # use dollar sign and element name
#> [1] TRUE
str(a$myAim) # we get myAim itself, a length 1 logical vector
#>  logi TRUE
a[["tNum"]] # index with length 1 character vector 
#> [1] 3.141593 2.718282 1.414214
str(a[["tNum"]]) # we get tNum itself, a length 3 numeric vector
#>  num [1:3] 3.14 2.72 1.41
iWantThis <- "joeNum" # indexing with length 1 character object
a[[iWantThis]] # we get joeNum itself, a length 5 integer vector
#> [1] 2 3 4 5 6
a[[c("joeNum", "veg")]] # does not work! can't get > 1 elements! see below
#> Error in a[[c("joeNum", "veg")]]: subscript out of bounds

# What if you want more than one element? You must index vector-style with single square brackets.
names(a)
#> [1] "veg"    "tNum"   "myAim"  "joeNum"
a[c("tNum", "veg")] # indexing by length 2 character vector
#> $tNum
#> [1] 3.141593 2.718282 1.414214
#> 
#> $veg
#> [1] "cabbage"  "eggplant"
str(a[c("tNum", "veg")]) # returns list of length 2
#> List of 2
#>  $ tNum: num [1:3] 3.14 2.72 1.41
#>  $ veg : chr [1:2] "cabbage" "eggplant"
a["veg"] # indexing by length 1 character vector
#> $veg
#> [1] "cabbage"  "eggplant"
str(a["veg"])# returns list of length 1
#> List of 1
#>  $ veg: chr [1:2] "cabbage" "eggplant"
length(a["veg"]) # really, it does!
#> [1] 1
length(a["veg"][[1]]) # contrast with length of the veg vector itself
#> [1] 2

# data frame
n <- 8
set.seed(1)
(jDat <- data.frame(w = round(rnorm(n), 2),
                    x = 1:n,
                    y = I(LETTERS[1:n]),
                    z = runif(n) > 0.3,
                    v = rep(LETTERS[9:12], each = 2)))
str(jDat)
mode(jDat)
class(jDat)
is.list(jDat) # data.frames are lists
jDat[[5]] # this works but I prefer ...
jDat$v # using dollar sign and name, when possible
jDat[c("x", "z")] # get multiple variables
str(jDat[c("x", "z")]) # returns a data.frame
identical(subset(jDat, select = c(x, z)), jDat[c("x", "z")])

# Question: How do I make a data.frame from a list? It is an absolute requirement
# that the constituent vectors have the same length, although they can be of different flavors.
## note difference in the printing of a list vs. a data.frame
(qDat <- list(w = round(rnorm(n), 2),
              x = 1:(n-1), ## <-- LOOK HERE! I MADE THIS VECTOR SHORTER!
              y = I(LETTERS[1:n])))
as.data.frame(qDat) ## does not work! elements don't have same length!
qDat$x <- 1:n ## fix the short variable x
(qDat <- as.data.frame(qDat)) ## we're back in business

# Indexing arrays, e.g. matrices
## don't worry if the construction of this matrix confuses you; just focus on
## the product
jMat <- outer(as.character(1:4), as.character(1:4),
              function(x, y) {
                paste0('x', x, y)
              })
jMat
str(jMat)
#>  chr [1:4, 1:4] "x11" "x21" "x31" "x41" "x12" "x22" ...
class(jMat)
#> [1] "matrix"
mode(jMat)
#> [1] "character"
dim(jMat)
nrow(jMat)
ncol(jMat)
rownames(jMat)
#> NULL
rownames(jMat) <- paste0("row", seq_len(nrow(jMat)))
colnames(jMat) <- paste0("col", seq_len(ncol(jMat)))
dimnames(jMat) # also useful for assignment
jMat
jMat[2, 3]
jMat[2, ] # getting row 2
is.vector(jMat[2, ]) # we get row 2 as an atomic vector
jMat[ , 3, drop = FALSE] # getting column 3
dim(jMat[ , 3, drop = FALSE]) # we get column 3 as a 4 x 1 matrix
jMat[c("row1", "row4"), c("col2", "col3")]
jMat[-c(2, 3), c(TRUE, TRUE, FALSE, FALSE)] # wacky but possible

# R is a column-major order language, in contrast to C and Python which use row-major order.
jMat[7]
#> [1] "x32"
jMat[1, grepl("[24]", colnames(jMat))]
#>  col2  col4 
#> "x12" "x14"
jMat["row1", 2:3] <- c("HEY!", "THIS IS NUTS!")
jMat

# Creating arrays, e.g. matrices
# 1. Filling a matrix with a vector
matrix(1:15, nrow = 5)
matrix("yo!", nrow = 3, ncol = 6)
matrix(c("yo!", "foo?"), nrow = 3, ncol = 6)
matrix(1:15, nrow = 5, byrow = TRUE)
matrix(1:15, nrow = 5,
       dimnames = list(paste0("row", 1:5),
                       paste0("col", 1:3)))
# 2. Glueing vectors together as rows or columns
vec1 <- 5:1
vec2 <- 2^(1:5)
cbind(vec1, vec2)
rbind(vec1, vec2)
# 3. Conversion of a data.frame
vecDat <- data.frame(vec1 = 5:1,
                     vec2 = 2^(1:5))
str(vecDat)
vecMat <- as.matrix(vecDat)
str(vecMat)
# convert to character, if different data type
multiDat <- data.frame(vec1 = 5:1,
                       vec2 = paste0("hi", 1:5))
str(multiDat)
(multiMat <- as.matrix(multiDat))
str(multiMat)

# Putting it all together … implications for data.frames
# A data.frame is a list that quacks like a matrix.
# Reviewing list-style indexing of a data.frame:
jDat
jDat$z
iWantThis <- "z"
jDat[[iWantThis]]
str(jDat[[iWantThis]])
# Reviewing vector-style indexing of a data.frame:
jDat["y"]
str(jDat["y"]) # we get a data.frame with one variable, y
iWantThis <- c("w", "v")
jDat[iWantThis] # index with a vector of variable names
str(jDat[c("w", "v")])
str(subset(jDat, select = c(w, v))) # using subset() function
# Demonstrating matrix-style indexing of a data.frame:
jDat[ , "v"]
str(jDat[ , "v"])
jDat[ , "v", drop = FALSE]
str(jDat[ , "v", drop = FALSE])
jDat[c(2, 4, 7), c(1, 4)] # awful and arbitrary but syntax works
jDat[jDat$z, ]
subset(jDat, subset = z)


  # +-----------+---------------+-----------+-----------+
  # | "flavor"  | type reported | mode()    | class()   |
  # |           | by typeof()   |           |           |
  # +===========+===============+===========+===========+
  # | character | character     | character | character |
  # +-----------+---------------+-----------+-----------+
  # | logical   | logical       | logical   | logical   |
  # +-----------+---------------+-----------+-----------+
  # | numeric   | integer       | numeric   | integer   |
  # |           | or double     |           | or double |
  # +-----------+---------------+-----------+-----------+
  # | factor    | integer       | numeric   | factor    |
  # +-----------+---------------+-----------+-----------+