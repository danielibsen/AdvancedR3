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

# Col values to snakecase-------------------------------------------------------
#' Making a plot of the metabolites
#'
#' @param data cleaned Lipidomics dataset.
#' @param cols columns
#'
#' @return metabolite names to snakecase
#'
column_values_to_snake_case <- function(data, cols) {
    data %>%
        dplyr::mutate(dplyr::across({{ cols }}, snakecase::to_snake_case))
}

# get dataset with metabolites in wide format-----------------------------------
#' Metabolites in wide dataset format
#'
#' @param data cleaned Lipidomics dataset.
#' @param cols columns
#'
#' @return A wide data frame
#'
metabolites_to_wider <- function(data) {
    data %>%
        tidyr::pivot_wider(
            names_from = metabolite,
            values_from = value,
            values_fn = mean,
            names_prefix = "metabolite_"
        )
}

# Using recipe and normalize metabolites----------------------------------------
#' Metabolites in wide dataset format
#'
#' @param data cleaned Lipidomics dataset.
#' @param metabolite_variable metabolite variable column
#'
#' @return recipe and normalized metabolite values
#'
create_recipe_spec <- function(data, metabolite_variable) {
    recipes::recipe(lipidomics_wide) %>%
        recipes::update_role({{ metabolite_variable }}, age, gender, new_role = "predictor") %>%
        recipes::update_role(class, new_role = "outcome") %>%
        recipes::step_normalize(tidyselect::starts_with("metabolite_"))
}

#' Create a workflow object of the model and transformations--------------------
#'
#' @param model_specs The model specs
#' @param recipe_specs The recipe specs
#'
#' @return A workflow object
#'
create_model_workflow <- function(model_specs, recipe_specs) {
    workflows::workflow() %>%
        workflows::add_model(model_specs) %>%
        workflows::add_recipe(recipe_specs)
}

#' Create a tidy output of the model results------------------------------------
#'
#' @param workflow_fitted_model The model workflow object that has been fitted.
#'
#' @return A data frame.
#'
tidy_model_output <- function(workflow_fitted_model) {
    workflow_fitted_model %>%
        workflows::extract_fit_parsnip() %>%
        broom::tidy(exponentiate = TRUE)
}
