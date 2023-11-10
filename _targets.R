# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load other packages as needed.

# Set target options:
tar_option_set(
  packages = unique(renv::dependencies(quiet = TRUE)$Package) # packages that your targets need to run
)

options(clustermq.scheduler = "multiprocess")

# Run the R scripts in the R/ folder with your custom functions:
tar_source()

# Replace the target list below with your own:
list(
  tar_target(
      name = file,
      command = "data/lipidomics.csv",
      format = "file"
    ),
  tar_target(
    name = lipidomics,
    command = readr::read_csv(file, show_col_types = FALSE)
  ),
  tar_target(
    name = basic_stats_metabolites_mean_sd,
    command = descriptive_stats(lipidomics)
  ),
  tar_target(
      name = fig_metabolite_distributions,
      command = plot_metabolite_distribution(lipidomics)
  ),
  tar_target(
      name = df_model_estimates,
      command = calculate_estimates(lipidomics)
  ),
  tar_target(
      name = fig_model_estimates,
      command = plot_estimates(df_model_estimates)
  ),
  tar_quarto(
      name = quarto_website,
      path = "."
  )
)
