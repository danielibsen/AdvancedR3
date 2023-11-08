#Functions for the project

#Descriptive data analysis------------------------------------------------------
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
        dplyr::mutate(dplyr::across(tidyselect::where(is.numeric), ~round(.x, digits = 1)))


    return(descriptive_stats_mean_sd)
}
