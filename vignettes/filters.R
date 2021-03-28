## ---- include = FALSE---------------------------------------------------------
devtools::load_all(".")
library(sits)

## ---- fig.align="center", fig.height=3.1, fig.width=5, fig.cap="Savitzky-Golay filter applied on a one-year NDVI time series."----
# Take NDVI band of the first sample data set
point.tb <- sits_select(prodes_226_064[1,], "ndvi")
# apply Savitzky–Golay filter
point_sg.tb <- sits_filter(point.tb, filter = sits_sgolay())
# plot the series
sits_merge(point_sg.tb, point.tb) %>% plot()

