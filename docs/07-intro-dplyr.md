

# Intro to dplyr

[dplyr](https://dplyr.tidyverse.org) is the core Tidyverse package for transforming and your raw datasets into a clean and usable format ([link to cheat sheet](https://rstudio.github.io/cheatsheets/data-transformation.pdf)). Its functions are versatile, performant, and have a consistent and user friendly syntax. These traits make it highly suitable for data science at all levels.



``` r
# import all core tidyverse packages
library(tidyverse)
# optional: change default print to 5 rows to save vertical space
options(pillar.print_min = 5)
```


## Syntax design

First, I think it's important to briefly comment on the syntax design of dplyr to avoid confusion later on. All functions covered in this chapter satisfy the following design principles:

 1. Functions in dplyr are designed to **only work on data frames**, not other objects (e.g. vectors).
    - To run on a vector, it must first be wrapped inside a data frame (see section \@ref(creating-dfs)).
 2. Functions in dplyr are all **able to be run with pipes** like `%>%` or `|>` (more on this soon).
 3. Functions in dplyr, **do NOT modify the input**, so you must always manually save the output.



## Pipes

All dplyr functions are setup so that **the first argument is the input data frame**. In other words, they're always run like `f(df, ...)` where `f` is some dplyr function, `df` is the data frame you wish to operate on, and `...` can be further arguments. This also applies to most other Tidyverse functions, e.g. recall the first argument to `ggplot()` must also be a data frame.

This design makes it easy to **chain many functions together with pipes** `%>%` and `|>`, which are [basically the same](https://www.tidyverse.org/blog/2023/04/base-vs-magrittr-pipe) and both used to **pass the left-side expression as the first argument to a function**. In this class, we will stick to `%>%` for consistency, but you can use `|>` if you prefer. For example,

 - `x %>% f` is equivalent to `f(x)`
 - `x %>% f(y)` is equivalent to `f(x, y)` ^[These examples come from the [magrittr help page](https://magrittr.tidyverse.org/index.html#usage){target="_blank"}.]

Why is this useful? Suppose you start with a data frame `df` and want to run the functions `f`, `g`, and `h` on it in order. You can of course do the following:

```
h(g(f(df)))
```

but this quickly becomes awkward, due to the many nested parentheticals. A much cleaner syntax is to use `%>%` to pipe `df` from one function to the next, resulting in this much cleaner equivalent syntax:

```
df %>% f %>% g %>% h
```

This is not only much neater but also significantly easier to modify and debug. You can also easily specify additional arguments. For example, suppose `f`, `g`, and `h` need the additional arguments `a = 1`, `b = 2`, and `c = 3` in order. Compare these two equivalent syntax options:

```
h(g(f(df, a = 1), b = 2), c = 3)
```

```
df %>% f(a = 1) %>% g(b = 2) %>% g(c = 3)
```

As long as each function in the chain accepts a data frame as the first argument AND outputs a data frame as the result, you can string together as many functions as you need to perform several data operations in a single step.


:::{.tip}
The [magrittr help page](https://magrittr.tidyverse.org/index.html#usage) has some additional usage tips for `%>%`, such as how to pass the left side to a different argument position, using `%>%` to create simple functions, and other [advanced pipes](https://magrittr.tidyverse.org/articles/magrittr.html#additional-pipe-operators). These are outside the scope of this course, so read at your own discretion!
:::


## Data example

For now, we're going to continue using the Palmer penguins dataset as an example data frame, but this time using the original dataset [`penguins.csv`](https://bwu62.github.io/stat240-revamp/data/penguins.csv) without removing the couple of rows with NAs. Let's load the data in:


``` r
# load in the original penguins dataset
penguins <- read_csv(
  "https://bwu62.github.io/stat240-revamp/data/penguins.csv",
  show_col_types = FALSE
)
# print the first few rows of the data frame to check
# again this data frame is too wide, and some columns are cut off
print(penguins, n = 5)
```

```
## # A tibble: 344 × 8
##   species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
##   <chr>   <chr>              <dbl>         <dbl>             <dbl>       <dbl>
## 1 Adelie  Torgersen           39.1          18.7               181        3750
## 2 Adelie  Torgersen           39.5          17.4               186        3800
## 3 Adelie  Torgersen           40.3          18                 195        3250
## 4 Adelie  Torgersen           NA            NA                  NA          NA
## 5 Adelie  Torgersen           36.7          19.3               193        3450
## # ℹ 339 more rows
## # ℹ 2 more variables: sex <chr>, year <dbl>
```



## Column-wise functions

We begin with the column-wise dplyr functions, i.e. the functions that primarily focus on manipulating columns in certain ways. Again, there are many of these, but 4 of the most important are the following:

 - `select()` for selecting a subset of columns to work with,
 - `rename()` for renaming columns,
 - `mutate()` for both editing and adding columns, **without reducing the number of rows**,
 - `summarize()` for computing data summaries, often using **statistical summary functions** like mean, median, sd, etc. and usually results in **reducing the number of rows**.


### `select()`

`select()` is used to subset columns in a data frame and is often one of the first operations used after loading in a dataset (to remove columns unnecessary for your analysis).

It has a very flexible syntax: you can use subset either by numeric position, by name, by ranges, by exlusion, or even using special [selector functions](https://tidyselect.r-lib.org/reference/starts_with.html). It can also be used to reorder columns. Here are a few examples:


``` r
# select just species, sex, flipper length, and body mass
penguins %>%
  select(species, sex, flipper_length_mm, body_mass_g)
```

```
## # A tibble: 344 × 4
##   species sex    flipper_length_mm body_mass_g
##   <chr>   <chr>              <dbl>       <dbl>
## 1 Adelie  male                 181        3750
## 2 Adelie  female               186        3800
## 3 Adelie  female               195        3250
## 4 Adelie  <NA>                  NA          NA
## 5 Adelie  female               193        3450
## # ℹ 339 more rows
```

``` r
# note this is syntactically equivalent to the following:
select(penguins, species, sex, flipper_length_mm, body_mass_g)
```

```
## # A tibble: 344 × 4
##   species sex    flipper_length_mm body_mass_g
##   <chr>   <chr>              <dbl>       <dbl>
## 1 Adelie  male                 181        3750
## 2 Adelie  female               186        3800
## 3 Adelie  female               195        3250
## 4 Adelie  <NA>                  NA          NA
## 5 Adelie  female               193        3450
## # ℹ 339 more rows
```

``` r
# you can also select by position, or with a range, or both
# e.g. we can select the 1st, 3rd to 5th, and year columns:
penguins %>%
  select(1, 3:5, year)
```

```
## # A tibble: 344 × 5
##   species bill_length_mm bill_depth_mm flipper_length_mm  year
##   <chr>            <dbl>         <dbl>             <dbl> <dbl>
## 1 Adelie            39.1          18.7               181  2007
## 2 Adelie            39.5          17.4               186  2007
## 3 Adelie            40.3          18                 195  2007
## 4 Adelie            NA            NA                  NA  2007
## 5 Adelie            36.7          19.3               193  2007
## # ℹ 339 more rows
```

``` r
# you can also use ranges with names
# e.g. select from 1st to island, then body mass to last col
penguins %>%
  select(1:island, body_mass_g:last_col())
```

```
## # A tibble: 344 × 5
##   species island    body_mass_g sex     year
##   <chr>   <chr>           <dbl> <chr>  <dbl>
## 1 Adelie  Torgersen        3750 male    2007
## 2 Adelie  Torgersen        3800 female  2007
## 3 Adelie  Torgersen        3250 female  2007
## 4 Adelie  Torgersen          NA <NA>    2007
## 5 Adelie  Torgersen        3450 female  2007
## # ℹ 339 more rows
```

``` r
# you can also select by excluding specific columns with !
# e.g. select everything except island and everything after body mass
penguins %>%
  select(-island, -(body_mass_g:last_col()), body_mass_g)
```

```
## # A tibble: 344 × 5
##   species bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
##   <chr>            <dbl>         <dbl>             <dbl>       <dbl>
## 1 Adelie            39.1          18.7               181        3750
## 2 Adelie            39.5          17.4               186        3800
## 3 Adelie            40.3          18                 195        3250
## 4 Adelie            NA            NA                  NA          NA
## 5 Adelie            36.7          19.3               193        3450
## # ℹ 339 more rows
```

``` r
# select with selector functions, see ?starts_with help page for details,
# you can also use & as AND, | as OR, ! as NOT during selection
# e.g. get cols that start with "s", or end with "mm" or "g",
#      but do NOT contain "length" anywhere in the name
penguins %>%
  select(
    (starts_with("s") | ends_with(c("mm", "g"))) & !contains("length")
  )
```

```
## # A tibble: 344 × 4
##   species sex    bill_depth_mm body_mass_g
##   <chr>   <chr>          <dbl>       <dbl>
## 1 Adelie  male            18.7        3750
## 2 Adelie  female          17.4        3800
## 3 Adelie  female          18          3250
## 4 Adelie  <NA>            NA            NA
## 5 Adelie  female          19.3        3450
## # ℹ 339 more rows
```

``` r
# notice in all examples above, columns are always returned in order
# select() can therefore also be used to reorder columns
# e.g. move year, island, species, sex cols in front of everything else
#      (here, everything() selects all the other cols in original order)
penguins %>%
  select(year, island, species, sex, everything())
```

```
## # A tibble: 344 × 8
##    year island    species sex    bill_length_mm bill_depth_mm flipper_length_mm
##   <dbl> <chr>     <chr>   <chr>           <dbl>         <dbl>             <dbl>
## 1  2007 Torgersen Adelie  male             39.1          18.7               181
## 2  2007 Torgersen Adelie  female           39.5          17.4               186
## 3  2007 Torgersen Adelie  female           40.3          18                 195
## 4  2007 Torgersen Adelie  <NA>             NA            NA                  NA
## 5  2007 Torgersen Adelie  female           36.7          19.3               193
## # ℹ 339 more rows
## # ℹ 1 more variable: body_mass_g <dbl>
```

:::{.note}
Here it's worth reminding that `df %>% select(...)` **does NOT modify the original input `df`**, instead it effectively makes a copy of `df` and runs on that instead. Example:

``` r
# show starting data frame
print(penguins)
```

```
## # A tibble: 344 × 8
##   species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
##   <chr>   <chr>              <dbl>         <dbl>             <dbl>       <dbl>
## 1 Adelie  Torgersen           39.1          18.7               181        3750
## 2 Adelie  Torgersen           39.5          17.4               186        3800
## 3 Adelie  Torgersen           40.3          18                 195        3250
## 4 Adelie  Torgersen           NA            NA                  NA          NA
## 5 Adelie  Torgersen           36.7          19.3               193        3450
## # ℹ 339 more rows
## # ℹ 2 more variables: sex <chr>, year <dbl>
```

``` r
# select a subset of columns
penguins %>% select(species, flipper_length_mm)
```

```
## # A tibble: 344 × 2
##   species flipper_length_mm
##   <chr>               <dbl>
## 1 Adelie                181
## 2 Adelie                186
## 3 Adelie                195
## 4 Adelie                 NA
## 5 Adelie                193
## # ℹ 339 more rows
```

``` r
# check original input is unchanged
print(penguins)
```

```
## # A tibble: 344 × 8
##   species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
##   <chr>   <chr>              <dbl>         <dbl>             <dbl>       <dbl>
## 1 Adelie  Torgersen           39.1          18.7               181        3750
## 2 Adelie  Torgersen           39.5          17.4               186        3800
## 3 Adelie  Torgersen           40.3          18                 195        3250
## 4 Adelie  Torgersen           NA            NA                  NA          NA
## 5 Adelie  Torgersen           36.7          19.3               193        3450
## # ℹ 339 more rows
## # ℹ 2 more variables: sex <chr>, year <dbl>
```
If you want to save the result of `df %>% select(...)` you must **manually save the output with `<-`**. In general, we always recommend saving to a NEW object instead of overwriting the original object because this is non-destructive (i.e. does not lose any data) and less likely to create code errors later on. It's also easier to debug.

``` r
# saving to a new object with a descriptive name is ALWAYS recommended!
penguins_fewcols <- penguins %>% select(species, flipper_length_mm)
print(penguins_fewcols)
```

```
## # A tibble: 344 × 2
##   species flipper_length_mm
##   <chr>               <dbl>
## 1 Adelie                181
## 2 Adelie                186
## 3 Adelie                195
## 4 Adelie                 NA
## 5 Adelie                193
## # ℹ 339 more rows
```

``` r
# overwriting the original input is STRONGLY discouraged
# because it's destructive and often causes problems later
penguins <- penguins %>% select(species, flipper_length_mm)
print(penguins)
```

```
## # A tibble: 344 × 2
##   species flipper_length_mm
##   <chr>               <dbl>
## 1 Adelie                181
## 2 Adelie                186
## 3 Adelie                195
## 4 Adelie                 NA
## 5 Adelie                193
## # ℹ 339 more rows
```

``` r
# reload data frame since we need it for other examples
penguins <- read_csv("data/penguins.csv", show_col_types = FALSE)
```

**This note applies to all functions on this page**, i.e. all of them do NOT modify the input, so desired changes must always be manually saved!
:::


### `rename()`

`rename()` is used to rename columns


### `mutate()`

### `summarize()`

## Row-wise functions

### `slice()`

### `drop_na()`

### `filter()`

### `arrange()`
