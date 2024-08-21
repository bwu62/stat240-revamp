

# Advanced operations

In this chapter, we will cover a few more advanced, yet incredibly useful data tidying operations like grouping, joining, and pivoting. Along the way, we will also make extensive use of dplyr functions learned in the previous chapter.


## Grouping

Often, you will need to apply dplyr's various operations like `mutate()`, `summarize()`, `slice_min()`/`slice_max()`, and `arrange()` not across the entire dataset but in groups. This is an important technique across data science, whether it's data cleaning to exploration to visualization to modeling.

By default, data frames are not grouped when created or imported. You can create a grouping structure with the `group_by()` function. The basic syntax is `df %>% group_by(col1, col2, ...)` where `col1`, `col2`, ... are variables whose values are used to determined groups. You can group by just 1 variable, 2 variables, or as many variables as you want. **Rows with the same values in the chosen columns will be grouped together.


