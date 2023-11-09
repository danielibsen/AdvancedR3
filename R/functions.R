# Functions for the project

# Descriptive data analysis------------------------------------------------------
#' Calculate descriptive statistics of each metabolite.
#'
#' @param data cleaned Lipidomics dataset.
#'
#' @return A data.frame/tibble with mean and sd of metabolites
#'
descriptive_stats <- function(cleaned_dataset) {
    descriptive_stats_mean_sd <- cleaned_dataset %>%
        dplyr::group_by(metabolite) %>%
        dplyr::summarise(across(value, list(mean = mean, sd = sd))) %>%
        dplyr::mutate(dplyr::across(tidyselect::where(is.numeric), ~ round(.x, digits = 1)))


    return(descriptive_stats_mean_sd)
}

# Distribution plot of metabolites-----------------------------------------------
#' Making a plot of the metabolites
#'
#' @param data cleaned Lipidomics dataset.
#'
#' @return A plot of the distribution of metabolites
#'
plot_metabolite_distribution <- function(cleaned_dataset) {
    plot <- ggplot2::ggplot(cleaned_dataset, aes(x = value)) +
        ggplot2::geom_histogram() +
        ggplot2::facet_wrap(vars(metabolite), scales = "free")

    return(plot)
}
