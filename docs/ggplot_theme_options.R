# set bw theme (turn off gray background)
theme_set(theme_bw())

# set better default colors for colorblind friendliness / better b/w printing
options(ggplot2.discrete.fill = \(...) scale_fill_brewer(..., palette = "Set2"),
        ggplot2.discrete.colour = \(...) scale_color_brewer(..., palette = "Dark2"))

# make background transparent, looks better in alert boxes
theme_update(plot.background = element_rect(fill = "transparent", color = NA),
             panel.background = element_rect(fill = rgb(1, 1, 1, .75)),
             legend.background = element_rect(fill = "transparent", color = NA),
             legend.key = element_rect(fill = "transparent", color = NA))
