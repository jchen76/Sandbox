# http://stat545.com/block018_colors.html

suppressPackageStartupMessages(library(dplyr))
library(gapminder)

# Change the default plotting symbol to a solid circle
## how to change the plot symbol in a simple, non-knitr setting
opar <- par(pch = 19)

## take a random sample of countries
n_c <- 8
j_year <- 2007
set.seed(1903)
countries_to_keep <-
  levels(gapminder$country) %>% 
  sample(size = n_c)
jdat <-
  gapminder %>% 
  filter(country %in% countries_to_keep, year == j_year) %>% 
  droplevels() %>% 
  arrange(gdpPercap)
jdat

# initial plot
j_xlim <- c(460, 60000)
j_ylim <- c(47, 82)
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     main = "Start your engines ...")

# use a few colors
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = "red", main = 'col = "red"')
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = c("blue", "orange"), main = 'col = c("blue", "orange")')

# use palette color
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = 1:n_c, main = paste0('col = 1:', n_c))
with(jdat, text(x = gdpPercap, y = lifeExp, pos = 1))
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = 1:n_c, main = 'the default palette()')
with(jdat, text(x = gdpPercap, y = lifeExp, labels = palette(),
                pos = rep(c(1, 3, 1), c(5, 1, 2))))   

# use custom color
j_colors <- c('chartreuse3', 'cornflowerblue', 'darkgoldenrod1', 'peachpuff3',
              'mediumorchid2', 'turquoise3', 'wheat4', 'slategray2')
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = j_colors, main = 'custom colors!')
with(jdat, text(x = gdpPercap, y = lifeExp, labels = j_colors,
                pos = rep(c(1, 3, 1), c(5, 1, 2)))) 

# What colors are available? Ditto for symbols and line types
# To see the names of all 657 the built-in colors, use colors().
head(colors())
#> [1] "white"         "aliceblue"     "antiquewhite"  "antiquewhite1"
#> [5] "antiquewhite2" "antiquewhite3"
tail(colors())
#> [1] "yellow"      "yellow1"     "yellow2"     "yellow3"     "yellow4"    
#> [6] "yellowgreen"

# Cynthia Brewer, a geographer and color specialist, has created sets of colors for print and the web and 
# they are available in the add-on package RColorBrewer. 
#install.packages("RColorBrewer")
library(RColorBrewer)
display.brewer.all()
display.brewer.pal(n = 8, name = 'Dark2')

j_brew_colors <- brewer.pal(n = 8, name = "Dark2")
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = j_brew_colors, main = 'Dark2 qualitative palette from RColorBrewer')
with(jdat, text(x = gdpPercap, y = lifeExp, labels = j_brew_colors,
                pos = rep(c(1, 3, 1), c(5, 1, 2)))) 

# viridis, In 2015 Stéfan van der Walt and Nathaniel Smith designed new color maps for matplotlib and 
# presented them in a talk at SciPy 2015.
library(ggplot2)
library(viridis)
library(hexbin)
ggplot(data.frame(x = rnorm(10000), y = rnorm(10000)), aes(x = x, y = y)) +
  geom_hex() + coord_fixed() +
  scale_fill_viridis() + theme_bw()

# Hexadecimal RGB color specification
brewer.pal(n = 8, name = "Dark2")
#> [1] "#1B9E77" "#D95F02" "#7570B3" "#E7298A" "#66A61E" "#E6AB02" "#A6761D"
#> [8] "#666666"
# #rrggbb, where rr, gg, and  bb refer to color intensity in the red, green, and blue channels, respectively.
# the lowest possible channel intensity is 00 = 0 and the highest is FF = 255.

# here are the ways to specify colors in R:
# + positive integer, used to index into the current color palette (queried or manipulated via palette())
# + color name among those found in colors()
# + hexadecimal string; in addition to a hexadecimal triple, in some contexts this can be extended to a hexadecimal quadruple with the fourth channel referring to alpha transparency

# functions to read up on: rgb(), col2rgb(), convertColor().

# Alternatives to the RGB color model, especially Hue-Saturation-Value (HCL).

# What are the good perceptually-based color models? CIELUV and CIELAB are two well-known examples.
# We will focus on a variant of CIELUV, namely the Hue-Chroma-Luminance (HCL) model. It is written
# up nicely for an R audience in Zeileis, et al (see References for citation and link). There is a
# companion R package colorspace, which will help you to explore and exploit the HCL color model.
# Finally, this color model is fully embraced in ggplot2 (as are the RColorBrewer palettes).

# Here’s what I can tell you about the HCL model’s three dimensions:
# + Hue is what you usually think of when you think “what color is that?” It’s the easy one! 
#   It is given as an angle, going from 0 to 360, so imagine a rainbow donut.
# + Chroma refers to colorfullness, i.e. how pure or vivid a color is. The more something seems 
#   mixed with gray, the lower its chromaticity. The lowest possible value is 0, which corresponds
#   to actual gray. The maximum value varies with luminance.
# + Luminance is related to brightness, lightness, intensity, and value. Low luminance means dark 
#   and indeed black has luminance 0. High luminance means light and white has luminance 1.

# Accomodating color blindness
# install.packages("dichromat")
library(dichromat)

par(opar)