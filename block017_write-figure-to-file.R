# http://stat545.com/block017_write-figure-to-file.html

# Write figures to file with ggsave()
ggsave("my-awesome-graph.png")

# Passing a plot object to ggsave()
p <- ggplot(gapminder, aes(x = year, y = lifeExp)) + geom_jitter()
# during development, you will uncomment next line to print p to screen
# p
ggsave("fig-io-practice.png", p)

# Scaling. There are at least two ways to do this, with slightly different effects and workflows.
# Via the scale = argument to ggsave(). scale = 0.8 often works well for posters and slides.

# Via the base_size of the active theme. By setting base size < 12, the default value, 
# you shrink text elements and by setting base_size > 12, you make them larger.

suppressPackageStartupMessages(library(ggplot2))
library(gapminder)
p <- ggplot(gapminder, aes(x = year, y = lifeExp)) + geom_jitter()
p1 <- p + ggtitle("scale = 0.6")
p2 <- p + ggtitle("scale = 2")
p3 <- p + ggtitle("base_size = 20") + theme_grey(base_size = 20)
p4 <- p + ggtitle("base_size = 3") + theme_grey(base_size = 3)
ggsave("img/fig-io-practice-scale-0.3.png", p1, scale = 0.6)
#> Saving 4.2 x 3 in image
ggsave("img/fig-io-practice-scale-2.png", p2, scale = 2)
#> Saving 14 x 10 in image
ggsave("img/fig-io-practice-base-size-20.png", p3)
#> Saving 7 x 5 in image
ggsave("img/fig-io-practice-base-size-3.png", p4)
#> Saving 7 x 5 in image

# Write non-ggplot2 figures to file
pdf("test-fig-proper.pdf") # starts writing a PDF to file
plot(1:10)                    # makes the actual plot
dev.off()                     # closes the PDF file
list.files(pattern = "^test-fig*")

plot(1:10)            # makes the actual plot
dev.print(pdf,        # copies the plot to a the PDF file
          "test-fig-quick-dirty.pdf")             
#> quartz_off_screen 
#>                 2
list.files(pattern = "^test-fig*")
#> [1] "test-fig-proper.pdf"      "test-fig-quick-dirty.pdf"

# Pre-emptive answers to some FAQs

# 1. Despair over non-existent or empty figures
# To get the same result from code run non-interactively, you will need to call print() explicitly yourself.
# It is worth noting here that the ggsave() workflow is not vulnerable to this gotcha, which is yet another
# reason to prefer it when using ggplot2.

# 2. Mysterious empty Rplots.pdf file
# When creating and writing figures from R running non-interactively, you can inadvertently trigger a request
# to query the active graphics device. For example, ggsave() might try to ascertain the physical size of the
# current device. But when running non-interactively there is often no such device available, which can lead
# to the unexpected creation of Rplots.pdf so this request can be fulfilled.

# 3. Chunk name determines figure file name
# For R markdown, if you name an R chunk, this name will be baked into the figure file name.
# ```{r scatterplot-lifeExp-vs-year}
# p <- ggplot(gapminder, aes(x = year, y = lifeExp)) + geom_jitter()
# p
# ```
list.files("block017_write-figure-to-file_files/", recursive = TRUE)
#> [1] "figure-html/dev-print-demo-1.png"             
#> [2] "figure-html/scatterplot-lifeExp-vs-year-1.png"

file.remove(list.files(pattern = "^test-fig*"))
#> [1] TRUE TRUE
