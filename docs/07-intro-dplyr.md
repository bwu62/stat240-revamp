

# Intro to dplyr

[dplyr](https://dplyr.tidyverse.org) is the core Tidyverse package for transforming and your raw datasets into a clean and usable format ([link to cheat sheet](https://rstudio.github.io/cheatsheets/data-transformation.pdf)). Its functions are versatile, performant, and have a consistent and user friendly syntax. These traits make it highly suitable for data science at all levels.



## Syntax design

First, I think it's important to briefly comment on the syntax design of dplyr to avoid confusion later on. **All functions covered in this chapter satisfy the following design principles:**

 1. Functions in dplyr are designed to **only work on data frames**. They can NOT be used with any other type of structure (e.g. vectors).
    - If you wish to use any operations on a vector, you must first wrap the vector inside a data frame (see section \@ref(creating-dfs)).
 2. Functions in dplyr are all **able to be run with pipes** like `%>%` or `|>`, which will be discussed in the next subsection.
 3. Functions in dplyr, similar to other R operations, **do NOT modify the input**, so you must always remember to manually save the output.



##

