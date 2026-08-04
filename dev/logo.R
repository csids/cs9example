# Generates man/figures/logo.png. Run from the package root:
#   Rscript dev/logo.R
#
# R packages, none of which is a cs9example dependency (this script is in dev/
# and is .Rbuildignore'd, so it never ships):
#   pak::pak(c("hexSticker", "ggplot2", "data.table"))
#
# hexSticker pulls in ggimage -> magick, which links against the system
# ImageMagick C++ library. Install that first or `library(hexSticker)` fails at
# dyn.load:
#   sudo apt install -y libmagick++-dev      # Debian/Ubuntu
#   brew install imagemagick@6               # macOS
# The exact missing-object message names whichever libMagick++ SONAME your
# `magick` binary was built against; it is not a fixed string.
#
# The motif is the figure the package actually produces. weather_export_plots_action()
# draws geom_ribbon(aes(ymin = temp_min, ymax = temp_max)) over date, so the
# subject is a daily temperature range: a wide band with a mean line through it.
#
# The palette is the cs* family palette, taken from cstemplate's extra.scss:
# navy #1E2C3A ink/background, coral #E0533C accent. That is the same pairing
# the cs9 and csdata hex logos use.
#
# The shapes are POLYGONS IN DATA SPACE, not thick lines. A geom_line linewidth
# and a geom_point size are both absolute (mm), so they do not scale with the
# panel: inside hexSticker's small subplot a band drawn that way overflows the
# coordinate limits and gets clipped flat. Polygons scale with the panel and
# stay the shape you specified.
#
# Use coord_cartesian(), not coord_fixed(). coord_fixed() pins the data aspect
# ratio, so the subplot letterboxes inside hexSticker's viewport and s_width has
# no visible effect -- the band stays narrow with navy either side of it. With
# coord_cartesian(expand = FALSE) the band fills the panel, and s_width/s_height
# then control how wide and how deep it renders.

library(hexSticker)
library(ggplot2)
library(data.table)

# sticker() prints the ggplot, which opens the default device. Under Rscript
# that device is pdf(), so the run drops an Rplots.pdf in the package root, and
# R CMD build ships it -- "Non-standard file/directory found at top level". Open
# a null device first so there is nothing to leave behind.
grDevices::pdf(NULL)

# ggsave() (which sticker() calls) refuses to create a missing directory. The
# package has no other man/figures content, so on a fresh checkout it is absent.
dir.create("man/figures", recursive = TRUE, showWarnings = FALSE)

CFG <- list(
  bg = "#1E2C3A", # cs navy
  border = "#E0533C", # cs coral
  band = "#8E4A3E", # min-max range, coral muted down onto the navy
  core = "#E0533C", # the warmer inner band
  mean = "#F7F3EE", # the mean line through the range
  text = "#F7F3EE",
  out = "man/figures/logo.png"
)

# One row per day. `mid` is the mean temperature, `hi`/`lo` the daily range.
# Deliberately smooth and shallow: at 64 px a jagged series turns into noise,
# and the shape has to read as a temperature band, not as a mountain.
x <- seq(0, 10, length.out = 400)
mid <- 0.34 * sin(x * 0.72 - 0.6) + 0.14 * sin(x * 1.9 + 1.1)
half_outer <- 0.40 + 0.10 * sin(x * 1.15 + 0.4)
half_inner <- 0.17 + 0.04 * sin(x * 1.15 + 0.4)

# A ribbon as ONE closed polygon: upper edge left-to-right, lower edge back
# right-to-left. Built by hand rather than with geom_ribbon so the mean line can
# use the same construction and stay a polygon too.
ribbon <- function(x, lower, upper) {
  data.table(
    x = c(x, rev(x)),
    y = c(upper, rev(lower))
  )
}

d_outer <- ribbon(x, mid - half_outer, mid + half_outer)
d_inner <- ribbon(x, mid - half_inner, mid + half_inner)
d_mean <- ribbon(x, mid - 0.030, mid + 0.030)

q <- ggplot()
q <- q + geom_polygon(data = d_outer, aes(x, y), fill = CFG$band)
q <- q + geom_polygon(data = d_inner, aes(x, y), fill = CFG$core)
q <- q + geom_polygon(data = d_mean, aes(x, y), fill = CFG$mean)
q <- q +
  coord_cartesian(xlim = c(0.15, 9.85), ylim = c(-0.92, 0.92), expand = FALSE)
q <- q + theme_void()
q <- q + theme(legend.position = "none")

sticker(
  q,
  package = "cs9example",
  p_size = 17,
  p_y = 1.44,
  p_color = CFG$text,
  p_family = "sans",
  s_x = 1.0,
  s_y = 0.94,
  s_width = 1.62,
  s_height = 0.66,
  h_fill = CFG$bg,
  h_color = CFG$border,
  h_size = 1.5,
  dpi = 600,
  filename = CFG$out
)
