## ---- include = FALSE---------------------------------------------------------
if (!requireNamespace("devtools", quietly = TRUE))
        install.packages("devtools")

if (!requireNamespace("sitsdata", quietly = TRUE))
        devtools::install_github("e-sensing/sitsdata")

library(sits)
library(sitsdata)

## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ----dendrogram, cache=TRUE, fig.align="center", fig.height=4.1, fig.width=5----
# take a set of patterns for 2 classes
# create a dendrogram, plot, and get the optimal cluster based on ARI index
clusters <- sits::sits_cluster_dendro(cerrado_2classes, 
                                         bands = c("ndvi", "evi"))

# show clusters samples frequency
sits::sits_cluster_frequency(clusters)

## -----------------------------------------------------------------------------
# remove cluster 3 from the samples
clusters_new <- dplyr::filter(clusters, cluster != 3)

# show new clusters samples frequency
sits::sits_cluster_frequency(clusters_new)

## -----------------------------------------------------------------------------
# clear clusters, leaving only the majority class in each cluster
clean <- sits::sits_cluster_clean(clusters)
# show clusters samples frequency
sits_cluster_frequency(clean)

## ---- out.width = "90%", out.height = "90%", echo = FALSE, fig.align="center", fig.cap="Using SOM for class noise reduction"----

knitr::include_graphics(system.file("extdata/markdown/figures", 
                                    "methodology_bayes_som.png", 
                                    package = "sits.docs"))

## ---- message = FALSE, warning = FALSE----------------------------------------
# take only 10% of the samples
samples_cerrado_mod13q1_reduced <- sits_sample(samples_cerrado_mod13q1, frac = 0.1)
# clustering time series using SOM
som_cluster <-
    sits_som_map(
        samples_cerrado_mod13q1_reduced,
        grid_xdim = 15,
        grid_ydim = 15,
        alpha = 1.0,
        distance = "euclidean",
        rlen = 100
    )

## -----------------------------------------------------------------------------
plot(som_cluster)

## ---- message = FALSE, warning = FALSE----------------------------------------
new_samples <- sits_som_clean_samples(som_cluster, 
                                      prior_threshold = 0.6,
                                      posterior_threshold = 0.6,
                                      keep = c("clean", "analyze"))
# find out how many samples are evaluated as "clean" or "analyze"
new_samples %>% 
  dplyr::group_by(eval) %>% 
  dplyr::summarise(count = dplyr::n())

## ---- message = FALSE, warning = FALSE----------------------------------------
assess_orig <- sits_kfold_validate(samples_cerrado_mod13q1_reduced, 
                                   ml_method = sits_svm())

## ---- message = FALSE, warning = FALSE----------------------------------------
assess_new <- sits_kfold_validate(new_samples, 
                                   ml_method = sits_svm())

