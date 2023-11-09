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
    command = readr::read_csv(here::here("data/lipidomics.csv"))
  ),
  tar_target(
    name = basic_stats_metabolites_mean_sd,
    command = descriptive_stats(lipidomics)
  ),
  tar_target(
      name = fig_metabolite_distributions,
      command = plot_metabolite_distribution(lipidomics)
  ),
  tar_quarto(
      name = quarto_doc,
      path = "doc/learning.qmd"
  )
)
