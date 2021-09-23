#functions


recipe_PCA<-function(data){
  penguin_recipe <-
    recipe(~., data = data) %>%
    update_role(species, island, sex, year, new_role = "id") %>%
    step_naomit(all_predictors()) %>%
    step_normalize(all_predictors()) %>%
    step_pca(all_predictors(), id = "pca") %>%
    prep()
}

create_PCA<-function(recipe){
penguin_pca <-
  recipe %>%
  tidy(id = "pca")

penguin_pca
}

plot_PCA<-function(PCA, recipe){ 
  pca_wider <- PCA %>%
  tidyr::pivot_wider(names_from = component, id_cols = terms)

# define arrow style
arrow_style <- arrow(length = unit(.05, "inches"),
                     type = "closed")


pca_plot <-
  juice(recipe) %>%
  ggplot(aes(PC1, PC2)) +
  geom_point(aes(color = species, shape = species),
             alpha = 0.8,
             size = 2) +
  scale_colour_manual(values = c("darkorange","purple","cyan4"))

pca_plot +
  geom_segment(data = pca_wider,
               aes(xend = PC1, yend = PC2),
               x = 0,
               y = 0,
               arrow = arrow_style) +
  geom_text(data = pca_wider,
            aes(x = PC1, y = PC2, label = terms),
            hjust = 0,
            vjust = 1,
            size = 5,
            color = '#0A537D')
}