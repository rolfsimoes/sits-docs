## ---- include = FALSE---------------------------------------------------------
devtools::load_all(".")
library(sits)
library(sitsdata)

## -----------------------------------------------------------------------------
# Select a subset of the samples to be plotted
# Retrieve the set of samples for the Mato Grosso region 
samples_matogrosso_mod13q1 %>% 
    sits_select(bands = "NDVI") %>% 
    dplyr::filter(label == "Forest") %>% 
    plot()

## -----------------------------------------------------------------------------
# Select a subset of the samples to be plotted
samples_matogrosso_mod13q1 %>% 
    sits_patterns() %>% 
    plot()

## ---- eval--------------------------------------------------------------------
# Retrieve the set of samples (provided by EMBRAPA) from the 
# Mato Grosso region for train the Random Forest model.
rfor_model <- sits_train(samples_matogrosso_mod13q1, sits_rfor())
# Classify using Random Forest model and plot the result
point_mt_4bands <- sits_select(point_mt_6bands, bands = c("NDVI", "EVI", "NIR", "MIR"))
class.tb <- point_mt_4bands %>% 
    sits_whittaker(lambda = 0.2, bands_suffix = "") %>% 
    sits_classify(rfor_model) %>% 
    plot(bands = c("NDVI", "EVI"))

