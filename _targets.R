# Manual is here: https://books.ropensci.org/targets/
# _targets.R file

library(targets)
source("R/functions.R")
options(tidyverse.quiet = TRUE)

tar_option_set(packages = c("palmerpenguins", "tidyverse", "corrplot", "GGally", "recipes"))
list(
  tar_target(
    raw_data_file,
    "data/penguins.csv",
    format = "file"
  ),
  tar_target(
    raw_data,
    read_csv(raw_data_file)
  ),
  tar_target(
    pairsplot,
    raw_data %>% 
     select(species, body_mass_g, ends_with("_mm")) %>%
      GGally::ggpairs(aes(color = species),
                      columns = c("fliper_length_mm", "body_mass_g",
                      #columns = c("flipper_length_mm", "body_mass_g",
                                  "bill_length_mm", "bill_depth_mm")) +
      scale_colour_manual(values = c("darkorange","purple","cyan4")) +
      scale_fill_manual(values = c("darkorange","purple","cyan4"))
    
  ),
  # tar_target(tidy_data,
  #            raw_data %>% 
  #              select(!X1)
  #            ),
  tar_target(PCA_recipe, 
             recipe_PCA(raw_data)
             #recipe_PCA(tidy_data)
             ),
  tar_target(PCA, 
             create_PCA(PCA_recipe)
             ),
  tar_target(PCAplot, plot_PCA(PCA,PCA_recipe)
)
)
