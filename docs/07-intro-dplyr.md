

# Intro to dplyr

[dplyr](https://dplyr.tidyverse.org) is the core Tidyverse package for transforming and your raw datasets into a clean and usable format ([link to cheat sheet](https://rstudio.github.io/cheatsheets/data-transformation.pdf)). Its functions are versatile, performant, and have a consistent and user friendly syntax. These traits make it highly suitable for data science at all levels.



``` r
# import all core tidyverse packages
library(tidyverse)
# optional: change default print to 5 rows to save vertical space, and
#           disable showing col_types by default in readr import functions
options(pillar.print_min = 5, readr.show_col_types = FALSE)
# optional: change default ggplot theme options (personal preference)
source("https://bwu62.github.io/stat240-revamp/ggplot_theme_options.R")
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
 - `x %>% f(y)` is equivalent to `f(x, y)` ^[These examples come from the [magrittr help page](https://magrittr.tidyverse.org/index.html#usage).]

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

For now, we're going to continue using the Palmer penguins dataset [`penguins.csv`](https://bwu62.github.io/stat240-revamp/data/penguins.csv) as an example data frame. Let's load the data in:


``` r
# load in the familiar penguins dataset
penguins <- read_csv("https://bwu62.github.io/stat240-revamp/data/penguins.csv")
# print the first few rows of the data frame to check
# again this data frame is too wide, and some columns are cut off
print(penguins, n = 5)
```

```
# A tibble: 333 × 8
  species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g sex   
  <chr>   <chr>              <dbl>         <dbl>             <dbl>       <dbl> <chr> 
1 Adelie  Torgersen           39.1          18.7               181        3750 male  
2 Adelie  Torgersen           39.5          17.4               186        3800 female
3 Adelie  Torgersen           40.3          18                 195        3250 female
4 Adelie  Torgersen           36.7          19.3               193        3450 female
5 Adelie  Torgersen           39.3          20.6               190        3650 male  
# ℹ 328 more rows
# ℹ 1 more variable: year <dbl>
```



## Column-wise functions

We begin with the column-wise dplyr functions, i.e. the functions that primarily focus on manipulating columns in certain ways. There are many of these, but 4 of the most important are the following:

 - `select()` for selecting a subset of columns to work with,
 - `rename()` for renaming columns,
 - `mutate()` for both editing and adding columns, **without reducing the number of rows**,
 - `summarize()` for computing data summaries, often using **statistical functions** like mean, median, sd, etc. and results in **reducing the number of rows**.


### `select()`

`select()` is used to subset columns in a data frame and is often one of the first operations used after loading in a dataset (to remove columns unnecessary for your analysis).

It has a very flexible syntax: you can use subset either by numeric position, by name, by ranges, by exclusion, or even using special [selector functions](https://tidyselect.r-lib.org/reference/starts_with.html). It can also be used to reorder columns. Here are a few examples:


``` r
# select just species, sex, flipper length, and body mass
penguins %>%
  select(species, sex, flipper_length_mm, body_mass_g)
```

```
# A tibble: 333 × 4
  species sex    flipper_length_mm body_mass_g
  <chr>   <chr>              <dbl>       <dbl>
1 Adelie  male                 181        3750
2 Adelie  female               186        3800
3 Adelie  female               195        3250
4 Adelie  female               193        3450
5 Adelie  male                 190        3650
# ℹ 328 more rows
```

``` r
# note this is syntactically equivalent to the following:
select(penguins, species, sex, flipper_length_mm, body_mass_g)
```

```
# A tibble: 333 × 4
  species sex    flipper_length_mm body_mass_g
  <chr>   <chr>              <dbl>       <dbl>
1 Adelie  male                 181        3750
2 Adelie  female               186        3800
3 Adelie  female               195        3250
4 Adelie  female               193        3450
5 Adelie  male                 190        3650
# ℹ 328 more rows
```

``` r
# you can also select by position, or with a range, or both
# e.g. we can select the 1st, 3rd to 5th, and year columns:
penguins %>%
  select(1, 3:5, year)
```

```
# A tibble: 333 × 5
  species bill_length_mm bill_depth_mm flipper_length_mm  year
  <chr>            <dbl>         <dbl>             <dbl> <dbl>
1 Adelie            39.1          18.7               181  2007
2 Adelie            39.5          17.4               186  2007
3 Adelie            40.3          18                 195  2007
4 Adelie            36.7          19.3               193  2007
5 Adelie            39.3          20.6               190  2007
# ℹ 328 more rows
```

``` r
# you can also use ranges with names
# e.g. select from 1st to island, then body mass to last col
penguins %>%
  select(1:island, body_mass_g:last_col())
```

```
# A tibble: 333 × 5
  species island    body_mass_g sex     year
  <chr>   <chr>           <dbl> <chr>  <dbl>
1 Adelie  Torgersen        3750 male    2007
2 Adelie  Torgersen        3800 female  2007
3 Adelie  Torgersen        3250 female  2007
4 Adelie  Torgersen        3450 female  2007
5 Adelie  Torgersen        3650 male    2007
# ℹ 328 more rows
```

``` r
# you can also select by excluding specific columns with !
# e.g. select everything except island and everything after body mass
penguins %>%
  select(-island, -(body_mass_g:last_col()), body_mass_g)
```

```
# A tibble: 333 × 5
  species bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
  <chr>            <dbl>         <dbl>             <dbl>       <dbl>
1 Adelie            39.1          18.7               181        3750
2 Adelie            39.5          17.4               186        3800
3 Adelie            40.3          18                 195        3250
4 Adelie            36.7          19.3               193        3450
5 Adelie            39.3          20.6               190        3650
# ℹ 328 more rows
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
# A tibble: 333 × 4
  species sex    bill_depth_mm body_mass_g
  <chr>   <chr>          <dbl>       <dbl>
1 Adelie  male            18.7        3750
2 Adelie  female          17.4        3800
3 Adelie  female          18          3250
4 Adelie  female          19.3        3450
5 Adelie  male            20.6        3650
# ℹ 328 more rows
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
# A tibble: 333 × 8
   year island    species sex    bill_length_mm bill_depth_mm flipper_length_mm
  <dbl> <chr>     <chr>   <chr>           <dbl>         <dbl>             <dbl>
1  2007 Torgersen Adelie  male             39.1          18.7               181
2  2007 Torgersen Adelie  female           39.5          17.4               186
3  2007 Torgersen Adelie  female           40.3          18                 195
4  2007 Torgersen Adelie  female           36.7          19.3               193
5  2007 Torgersen Adelie  male             39.3          20.6               190
# ℹ 328 more rows
# ℹ 1 more variable: body_mass_g <dbl>
```

:::{.note}
Here it's worth reminding that `df %>% select(...)` **does NOT modify the original input `df`**, instead it effectively makes a copy of `df` and runs on that instead. Example:

``` r
# show starting data frame
print(penguins)
```

```
# A tibble: 333 × 8
  species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g sex   
  <chr>   <chr>              <dbl>         <dbl>             <dbl>       <dbl> <chr> 
1 Adelie  Torgersen           39.1          18.7               181        3750 male  
2 Adelie  Torgersen           39.5          17.4               186        3800 female
3 Adelie  Torgersen           40.3          18                 195        3250 female
4 Adelie  Torgersen           36.7          19.3               193        3450 female
5 Adelie  Torgersen           39.3          20.6               190        3650 male  
# ℹ 328 more rows
# ℹ 1 more variable: year <dbl>
```

``` r
# select a subset of columns
penguins %>% select(species, flipper_length_mm)
```

```
# A tibble: 333 × 2
  species flipper_length_mm
  <chr>               <dbl>
1 Adelie                181
2 Adelie                186
3 Adelie                195
4 Adelie                193
5 Adelie                190
# ℹ 328 more rows
```

``` r
# check original input is unchanged
print(penguins)
```

```
# A tibble: 333 × 8
  species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g sex   
  <chr>   <chr>              <dbl>         <dbl>             <dbl>       <dbl> <chr> 
1 Adelie  Torgersen           39.1          18.7               181        3750 male  
2 Adelie  Torgersen           39.5          17.4               186        3800 female
3 Adelie  Torgersen           40.3          18                 195        3250 female
4 Adelie  Torgersen           36.7          19.3               193        3450 female
5 Adelie  Torgersen           39.3          20.6               190        3650 male  
# ℹ 328 more rows
# ℹ 1 more variable: year <dbl>
```
If you want to save the result of `df %>% select(...)` you must **manually save the output with `<-`**. In general, we always recommend saving to a NEW object instead of overwriting the original object because this is non-destructive (i.e. does not lose any data) and less likely to create code errors later on. It's also easier to debug.

``` r
# saving to a new object with a descriptive name is ALWAYS recommended!
penguins_fewcols <- penguins %>% select(species, flipper_length_mm)
print(penguins_fewcols)
```

```
# A tibble: 333 × 2
  species flipper_length_mm
  <chr>               <dbl>
1 Adelie                181
2 Adelie                186
3 Adelie                195
4 Adelie                193
5 Adelie                190
# ℹ 328 more rows
```

``` r
# overwriting the original input is STRONGLY discouraged
# because it's destructive and often causes problems later
penguins <- penguins %>% select(species, flipper_length_mm)
print(penguins)
```

```
# A tibble: 333 × 2
  species flipper_length_mm
  <chr>               <dbl>
1 Adelie                181
2 Adelie                186
3 Adelie                195
4 Adelie                193
5 Adelie                190
# ℹ 328 more rows
```

``` r
# reload data frame since we need it for other examples
penguins <- read_csv("https://bwu62.github.io/stat240-revamp/data/penguins.csv")
```


**This note applies to all functions on this page**, i.e. all of them do NOT modify the input, so desired **changes must always be manually saved**!
:::


### `rename()`

`rename()` is used to rename columns. This is another common operation right after loading a dataset. Examples:


``` r
# rename species as species_name, and island as island_name
penguins %>%
  rename(species_name = species, island_name = island)
```

```
# A tibble: 333 × 8
  species_name island_name bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
  <chr>        <chr>                <dbl>         <dbl>             <dbl>       <dbl>
1 Adelie       Torgersen             39.1          18.7               181        3750
2 Adelie       Torgersen             39.5          17.4               186        3800
3 Adelie       Torgersen             40.3          18                 195        3250
4 Adelie       Torgersen             36.7          19.3               193        3450
5 Adelie       Torgersen             39.3          20.6               190        3650
# ℹ 328 more rows
# ℹ 2 more variables: sex <chr>, year <dbl>
```

``` r
# if you want to use irregular names, i.e. names with spaces or symbols,
# you must surround them with " " quotes
penguins %>%
  rename("Bill Length (mm)" = bill_length_mm)
```

```
# A tibble: 333 × 8
  species island `Bill Length (mm)` bill_depth_mm flipper_length_mm body_mass_g sex  
  <chr>   <chr>               <dbl>         <dbl>             <dbl>       <dbl> <chr>
1 Adelie  Torge…               39.1          18.7               181        3750 male 
2 Adelie  Torge…               39.5          17.4               186        3800 fema…
3 Adelie  Torge…               40.3          18                 195        3250 fema…
4 Adelie  Torge…               36.7          19.3               193        3450 fema…
5 Adelie  Torge…               39.3          20.6               190        3650 male 
# ℹ 328 more rows
# ℹ 1 more variable: year <dbl>
```

``` r
# if you have a data frame with an extremely long and awkward name,
# you can also use selector functions to help you rename it
# (see ?starts_with help page for more details/examples)
df_badname <- tibble(
  x = 1:3,
  "Really long (and awkward) name with !@#$% symbols" = 4:6
)
df_badname
```

```
# A tibble: 3 × 2
      x `Really long (and awkward) name with !@#$% symbols`
  <int>                                               <int>
1     1                                                   4
2     2                                                   5
3     3                                                   6
```

``` r
df_badname %>%
  rename(y = starts_with("Really") & ends_with("symbols"))
```

```
# A tibble: 3 × 2
      x     y
  <int> <int>
1     1     4
2     2     5
3     3     6
```

This is outside our scope, but you can also apply a function to many/all columns using `rename_with()`. For example:


``` r
penguins %>%
  rename_with(toupper)
```

```
# A tibble: 333 × 8
  SPECIES ISLAND    BILL_LENGTH_MM BILL_DEPTH_MM FLIPPER_LENGTH_MM BODY_MASS_G SEX   
  <chr>   <chr>              <dbl>         <dbl>             <dbl>       <dbl> <chr> 
1 Adelie  Torgersen           39.1          18.7               181        3750 male  
2 Adelie  Torgersen           39.5          17.4               186        3800 female
3 Adelie  Torgersen           40.3          18                 195        3250 female
4 Adelie  Torgersen           36.7          19.3               193        3450 female
5 Adelie  Torgersen           39.3          20.6               190        3650 male  
# ℹ 328 more rows
# ℹ 1 more variable: YEAR <dbl>
```


### `mutate()`

`mutate()` is used to either change an existing column, or add new columns. It's an easy function to introduce but a tough one to master. The basic syntax is `df %>% mutate(col1 = expr1, col2 = expr2, ...)` where `col1`, `col2`, ... are the columns being changed/added (depending on if it already exists) and `expr1`, `expr2`, ... are some R expressions.

The key thing to remember is the expressions can be **any vector computation using one or more columns in the data frame that produces a vector of the same length OR a single value** (which gets recycled).

For convenience, let's select just a few columns to continue with the demonstration:


``` r
penguins2 <- penguins %>%
  select(species, sex, bill_length_mm, bill_depth_mm)
print(penguins2)
```

```
# A tibble: 333 × 4
  species sex    bill_length_mm bill_depth_mm
  <chr>   <chr>           <dbl>         <dbl>
1 Adelie  male             39.1          18.7
2 Adelie  female           39.5          17.4
3 Adelie  female           40.3          18  
4 Adelie  female           36.7          19.3
5 Adelie  male             39.3          20.6
# ℹ 328 more rows
```

Now, here's a few example applications of `mutate()` using `penguins2`


``` r
# we can easily add columns of constants
penguins2 %>%
  mutate(study = "Palmer", century = 21, true = TRUE)
```

```
# A tibble: 333 × 7
  species sex    bill_length_mm bill_depth_mm study  century true 
  <chr>   <chr>           <dbl>         <dbl> <chr>    <dbl> <lgl>
1 Adelie  male             39.1          18.7 Palmer      21 TRUE 
2 Adelie  female           39.5          17.4 Palmer      21 TRUE 
3 Adelie  female           40.3          18   Palmer      21 TRUE 
4 Adelie  female           36.7          19.3 Palmer      21 TRUE 
5 Adelie  male             39.3          20.6 Palmer      21 TRUE 
# ℹ 328 more rows
```

``` r
# we can also change existing columns using the same syntax,
# e.g. we can capitalize and abbreviate sex to M and F
penguins2 %>%
  mutate(sex = substr(toupper(sex), 1, 1))
```

```
# A tibble: 333 × 4
  species sex   bill_length_mm bill_depth_mm
  <chr>   <chr>          <dbl>         <dbl>
1 Adelie  M               39.1          18.7
2 Adelie  F               39.5          17.4
3 Adelie  F               40.3          18  
4 Adelie  F               36.7          19.3
5 Adelie  M               39.3          20.6
# ℹ 328 more rows
```

``` r
# we can also use multiple columns in expressions
# e.g. we can roughly estimate the volume of each bill,
# see: https://allisonhorst.github.io/palmerpenguins/#bill-dimensions
penguins2 %>%
  mutate(bill_vol_mm3 = pi * (bill_depth_mm / 2)^2 * bill_length_mm)
```

```
# A tibble: 333 × 5
  species sex    bill_length_mm bill_depth_mm bill_vol_mm3
  <chr>   <chr>           <dbl>         <dbl>        <dbl>
1 Adelie  male             39.1          18.7       10739.
2 Adelie  female           39.5          17.4        9393.
3 Adelie  female           40.3          18         10255.
4 Adelie  female           36.7          19.3       10737.
5 Adelie  male             39.3          20.6       13098.
# ℹ 328 more rows
```

``` r
# you can also break this into steps, using intermediate variables
# note intermediate variables can be used immediately in the same mutate() call
penguins2 %>% mutate(
  bill_cross_section_mm2 = pi * (bill_depth_mm / 2)^2,
  bill_vol_mm3           = bill_cross_section_mm2 * bill_length_mm
)
```

```
# A tibble: 333 × 6
  species sex    bill_length_mm bill_depth_mm bill_cross_section_mm2 bill_vol_mm3
  <chr>   <chr>           <dbl>         <dbl>                  <dbl>        <dbl>
1 Adelie  male             39.1          18.7                   275.       10739.
2 Adelie  female           39.5          17.4                   238.        9393.
3 Adelie  female           40.3          18                     254.       10255.
4 Adelie  female           36.7          19.3                   293.       10737.
5 Adelie  male             39.3          20.6                   333.       13098.
# ℹ 328 more rows
```

``` r
# you can even mix summary functions into your expression
# e.g. standardize bill length and depth by subtracting mean and dividing by sd
penguins2 %>% mutate(
  bill_length_std = (bill_length_mm - mean(bill_length_mm)) / sd(bill_length_mm),
  bill_depth_std  = (bill_depth_mm - mean(bill_depth_mm)) / sd(bill_depth_mm)
)
```

```
# A tibble: 333 × 6
  species sex    bill_length_mm bill_depth_mm bill_length_std bill_depth_std
  <chr>   <chr>           <dbl>         <dbl>           <dbl>          <dbl>
1 Adelie  male             39.1          18.7          -0.895          0.780
2 Adelie  female           39.5          17.4          -0.822          0.119
3 Adelie  female           40.3          18            -0.675          0.424
4 Adelie  female           36.7          19.3          -1.33           1.08 
5 Adelie  male             39.3          20.6          -0.858          1.74 
# ℹ 328 more rows
```

``` r
# you can of course create columns of other data types
penguins2 %>% mutate(
  small_bill = bill_length_mm < 39 | bill_depth_mm < 18,
  fake_dates = seq(today(), today() + nrow(penguins) - 1, by = 1)
)
```

```
# A tibble: 333 × 6
  species sex    bill_length_mm bill_depth_mm small_bill fake_dates
  <chr>   <chr>           <dbl>         <dbl> <lgl>      <date>    
1 Adelie  male             39.1          18.7 FALSE      2024-08-29
2 Adelie  female           39.5          17.4 TRUE       2024-08-30
3 Adelie  female           40.3          18   FALSE      2024-08-31
4 Adelie  female           36.7          19.3 TRUE       2024-09-01
5 Adelie  male             39.3          20.6 FALSE      2024-09-02
# ℹ 328 more rows
```

A notable function that is extremely useful inside `mutate()` is `case_when()` which can calculate different values depending on certain conditions.^[It's similar to a switch function in other languages.] The basic syntax is `df %>% mutate(new_col = case_when(cond1 ~ expr1, cond2 ~ expr2, ...))` where `cond1`, `cond2`, ... are logical condition vectors checked one by one in the given order, and `expr1`, `expr2`, ... are R expressions that are activated when a condition matches.

For example, suppose we want to create some new column differently depending on sex and bill depth:


``` r
# use case_when() inside a mutate() depending on some conditions
# .default sets the "default" result, when no conditions match OR when we have NAs
penguins2 %>% mutate(
  new_col = case_when(
    sex == "male" & bill_depth_mm <= 19 ~ bill_length_mm * 100,
    sex == "male" & bill_depth_mm > 19 ~ bill_length_mm * -1,
    sex == "female" ~ round(log((bill_length_mm / bill_depth_mm)^2), 2),
    .default = 0
  )
)
```

```
# A tibble: 333 × 5
  species sex    bill_length_mm bill_depth_mm new_col
  <chr>   <chr>           <dbl>         <dbl>   <dbl>
1 Adelie  male             39.1          18.7 3910   
2 Adelie  female           39.5          17.4    1.64
3 Adelie  female           40.3          18      1.61
4 Adelie  female           36.7          19.3    1.29
5 Adelie  male             39.3          20.6  -39.3 
# ℹ 328 more rows
```

It's worth restating that **ANY vectorized operation of the columns can be used inside `mutate()`**, as long as the result is a same-length vector (or single value to be recycled). This includes essentially every function from chapter \@ref(data-vectors)!

The [dplyr cheat sheet](https://rstudio.github.io/cheatsheets/data-transformation.pdf) has on page 2 a small list of some other functions that may be useful inside `mutate()` for more advanced situations, such as `cumsum()` for finding cumulative sums of columns (i.e. "running" sum), `lag()` and `lead()` for creating a lagged or leading vector useful for computing changes in time series data, `na_if()` for selectively replacing specific values with NA, several ranking functions like `dense_rank()` or `min_rank()`, and many more.


### `summarize()`

`summarize()` is similar to `mutate()` except you **MUST use summary functions**, i.e. function that always **reduce a vector down to a single value**. Again, you can again use any arbitrary function or combination of functions of any columns in the data frame, and the result can be any type (e.g. numeric, character, logical, date, etc.), as long as the result is singular.

The basic syntax is `df %>% summarize(col1 = expr1, col2 = expr2, ...)` where again `col1`, `col2`, ... are names of new summary columns, and `expr1`, `expr2`, ... are R expressions that reduce to a single value. Example:


``` r
# let's compute several summary statistics of bill length
penguins2 %>% summarize(
  mean_length   = mean(bill_length_mm),
  median_length = median(bill_length_mm),
  sd_length     = sd(bill_length_mm),
  iqr_length    = IQR(bill_length_mm),
  max_length    = max(bill_length_mm),
  min_length    = min(bill_length_mm),
  n             = n()
)
```

```
# A tibble: 1 × 7
  mean_length median_length sd_length iqr_length max_length min_length     n
        <dbl>         <dbl>     <dbl>      <dbl>      <dbl>      <dbl> <int>
1        44.0          44.5      5.47        9.1       59.6       32.1   333
```

The last function in the chunk above `n()` is a special function that **takes NO arguments and returns the number of rows**.^[This is an example of what's called a [nullary function](https://en.wikipedia.org/wiki/Arity)]

A few other common applications of `summarize()` in data exploration:


``` r
# compute a few other summaries to explore the data
# note similar to mutate, we can immediately use a summarized column
penguins2 %>% summarize(
  n            = n(),
  n_male       = sum(sex == "male"),
  pct_male     = 100 * n_male / n,
  n_female     = sum(sex == "female"),
  pct_female   = 100 * n_female / n,
  pct_NA       = 100 * mean(
    is.na(species) | is.na(sex) | is.na(bill_length_mm) | is.na(bill_depth_mm)
  ), # get proportion of rows with NA (mean of logicals gives proportion of TRUEs)
  q90_len      = quantile(bill_length_mm, 0.90),
  pmed_len     = mean(bill_length_mm <= median(bill_length_mm)),
  correlation  = cor(bill_length_mm, bill_depth_mm)
)
```

```
# A tibble: 1 × 9
      n n_male pct_male n_female pct_female pct_NA q90_len pmed_len correlation
  <int>  <int>    <dbl>    <int>      <dbl>  <dbl>   <dbl>    <dbl>       <dbl>
1   333    168     50.5      165       49.5      0    50.8    0.502      -0.229
```

It's also common to use `summarize()` to compute statistical results. For example we can calculate the 95% confidence intervals for the mean bill length and depth (ignoring species/sex) which is something we will cover in more detail later in the course:


``` r
# we first compute some intermediate statistics,
# then use those to compute the intervals
penguins2 %>% summarize(
  n            = n(),
  mean_length  = mean(bill_length_mm),
  sd_length    = sd(bill_length_mm),
  mean_depth   = mean(bill_depth_mm),
  sd_depth     = sd(bill_depth_mm),
  length_95_ci = paste(
    round(mean_length + c(-1, 1) * 1.96 * sd_length / sqrt(n), 2),
    collapse = ","
  ),
  depth_95_ci  = paste(
    round(mean_depth  + c(-1, 1) * 1.96 * sd_depth  / sqrt(n), 2),
    collapse = ","
  )
)
```

```
# A tibble: 1 × 7
      n mean_length sd_length mean_depth sd_depth length_95_ci depth_95_ci
  <int>       <dbl>     <dbl>      <dbl>    <dbl> <chr>        <chr>      
1   333        44.0      5.47       17.2     1.97 43.41,44.58  16.95,17.38
```

Again, I think it's important to stress **ANY expression involving columns that results in a single value** can be used inside `summarize()`. The [dplyr cheat sheet](https://rstudio.github.io/cheatsheets/data-transformation.pdf) has on page 2 some more examples of useful summarizing functions such as `first()`, `last()`, and `nth()` for getting the first, last, and n-th observations in a group respectively. Feel free to read more on your own.


## Row-wise functions

Let's move on now to the row-wise functions, i.e. the functions that primarily focus on manipulating rows in certain ways. Again, there are many of these too, but here are 3 of the most important:

 - `filter()` for filtering which rows to keep,
 - `slice()` (plus some other sibling functions) for slicing out specific rows,
 - `arrange()` for sorting rows.


### `filter()`

`filter()` is used to filter which rows to keep. Note the wording here; **rows that meet the conditions are KEPT, not dropped**. This is a frequent point of confusion for beginners.

Similar to `mutate()` and `summarize()`, you can filter by **constructing a logical expression using ANY combination of columns**, as long as the result is a vector of TRUE/FALSE values, one for each row. In the end, only rows with TRUE will be returned as output.

Let's return to using our original `penguins` data frame. Here's a few filtering examples:


``` r
# filter to get penguins >=6kg
penguins %>%
  filter(body_mass_g >= 6000)
```

```
# A tibble: 4 × 8
  species island bill_length_mm bill_depth_mm flipper_length_mm body_mass_g sex  
  <chr>   <chr>           <dbl>         <dbl>             <dbl>       <dbl> <chr>
1 Gentoo  Biscoe           49.2          15.2               221        6300 male 
2 Gentoo  Biscoe           59.6          17                 230        6050 male 
3 Gentoo  Biscoe           51.1          16.3               220        6000 male 
4 Gentoo  Biscoe           48.8          16.2               222        6000 male 
# ℹ 1 more variable: year <dbl>
```

``` r
# combining multiple filtering conditions using & and |
penguins %>% filter(
  (species == "Adelie" | species == "Gentoo") &
    island %in% c("Biscoe", "Dream") & year < 2008
)
```

```
# A tibble: 62 × 8
  species island bill_length_mm bill_depth_mm flipper_length_mm body_mass_g sex   
  <chr>   <chr>           <dbl>         <dbl>             <dbl>       <dbl> <chr> 
1 Adelie  Biscoe           37.8          18.3               174        3400 female
2 Adelie  Biscoe           37.7          18.7               180        3600 male  
3 Adelie  Biscoe           35.9          19.2               189        3800 female
4 Adelie  Biscoe           38.2          18.1               185        3950 male  
5 Adelie  Biscoe           38.8          17.2               180        3800 male  
# ℹ 57 more rows
# ℹ 1 more variable: year <dbl>
```

``` r
# you can of course use more complex functions and expressions,
# you can also use , to separate multiple conditions in filter() instead of &
# e.g. this code gets rows with no "e" in the species name, and also
# bill depth is higher than median but flipper length is lower than median
penguins %>% filter(
  !grepl("e", species),
  bill_depth_mm > median(bill_depth_mm),
  flipper_length_mm < median(flipper_length_mm)
)
```

```
# A tibble: 24 × 8
  species   island bill_length_mm bill_depth_mm flipper_length_mm body_mass_g sex   
  <chr>     <chr>           <dbl>         <dbl>             <dbl>       <dbl> <chr> 
1 Chinstrap Dream            46.5          17.9               192        3500 female
2 Chinstrap Dream            50            19.5               196        3900 male  
3 Chinstrap Dream            51.3          19.2               193        3650 male  
4 Chinstrap Dream            45.4          18.7               188        3525 female
5 Chinstrap Dream            46.1          18.2               178        3250 female
# ℹ 19 more rows
# ℹ 1 more variable: year <dbl>
```


``` r
# an example of an even more complicated expression,
# this line gets penguins with body mass and bill length
# within a 1 SD circle centered around the mean of both,
# then plots the result to visually inspect
# note the result df can be directly piped into ggplot()
penguins %>%
  filter(
    ((body_mass_g - mean(body_mass_g)) / sd(body_mass_g))^2 +
      ((bill_length_mm - mean(bill_length_mm)) / sd(bill_length_mm))^2 <= 1
  ) %>%
  ggplot(aes(x = bill_length_mm, y = body_mass_g)) + geom_point() +
  labs(title = "Filter demo (points in a 1-SD circle around mean of x,y)",
       x = "Bill length (mm)", y = "Body mass (g)") +
  coord_fixed(.0067) # make the plot window a square
```

<img src="07-intro-dplyr_files/figure-html/filter2-1.svg" width="672" style="display: block; margin: auto;" />


### `slice()`

There are several [`slice...()`{.R}](https://dplyr.tidyverse.org/reference/slice.html) functions in dplyr for slicing out specific rows, similar to `filter()` but more specialized. The main one `slice()` is used to select by position (i.e. by row number). Examples:


``` r
# slice rows 11-15
penguins %>% slice(11:15)
```

```
# A tibble: 5 × 8
  species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g sex   
  <chr>   <chr>              <dbl>         <dbl>             <dbl>       <dbl> <chr> 
1 Adelie  Torgersen           36.6          17.8               185        3700 female
2 Adelie  Torgersen           38.7          19                 195        3450 female
3 Adelie  Torgersen           42.5          20.7               197        4500 male  
4 Adelie  Torgersen           34.4          18.4               184        3325 female
5 Adelie  Torgersen           46            21.5               194        4200 male  
# ℹ 1 more variable: year <dbl>
```

``` r
# slice every 10th row
penguins %>% slice(seq(0, nrow(penguins), 10))
```

```
# A tibble: 33 × 8
  species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g sex   
  <chr>   <chr>              <dbl>         <dbl>             <dbl>       <dbl> <chr> 
1 Adelie  Torgersen           34.6          21.1               198        4400 male  
2 Adelie  Biscoe              38.8          17.2               180        3800 male  
3 Adelie  Dream               36.4          17                 195        3325 female
4 Adelie  Dream               37            16.9               185        3000 female
5 Adelie  Biscoe              41.4          18.6               191        3700 male  
# ℹ 28 more rows
# ℹ 1 more variable: year <dbl>
```

``` r
# remove the first 200 rows
penguins %>% slice(-(1:200))
```

```
# A tibble: 133 × 8
  species island bill_length_mm bill_depth_mm flipper_length_mm body_mass_g sex   
  <chr>   <chr>           <dbl>         <dbl>             <dbl>       <dbl> <chr> 
1 Gentoo  Biscoe           45            15.4               220        5050 male  
2 Gentoo  Biscoe           43.8          13.9               208        4300 female
3 Gentoo  Biscoe           45.5          15                 220        5000 male  
4 Gentoo  Biscoe           43.2          14.5               208        4450 female
5 Gentoo  Biscoe           50.4          15.3               224        5550 male  
# ℹ 128 more rows
# ℹ 1 more variable: year <dbl>
```

`slice_head()` and `slice_tail()` specifically slice out rows at the top or bottom, by either number `n` or proportion `prop`. Examples:


``` r
# get the first 25 rows
penguins %>% slice_head(n = 25)
```

```
# A tibble: 25 × 8
  species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g sex   
  <chr>   <chr>              <dbl>         <dbl>             <dbl>       <dbl> <chr> 
1 Adelie  Torgersen           39.1          18.7               181        3750 male  
2 Adelie  Torgersen           39.5          17.4               186        3800 female
3 Adelie  Torgersen           40.3          18                 195        3250 female
4 Adelie  Torgersen           36.7          19.3               193        3450 female
5 Adelie  Torgersen           39.3          20.6               190        3650 male  
# ℹ 20 more rows
# ℹ 1 more variable: year <dbl>
```

``` r
# get the last 10% of rows
penguins %>% slice_tail(prop = 0.1)
```

```
# A tibble: 33 × 8
  species   island bill_length_mm bill_depth_mm flipper_length_mm body_mass_g sex   
  <chr>     <chr>           <dbl>         <dbl>             <dbl>       <dbl> <chr> 
1 Chinstrap Dream            47.5          16.8               199        3900 female
2 Chinstrap Dream            47.6          18.3               195        3850 female
3 Chinstrap Dream            52            20.7               210        4800 male  
4 Chinstrap Dream            46.9          16.6               192        2700 female
5 Chinstrap Dream            53.5          19.9               205        4500 male  
# ℹ 28 more rows
# ℹ 1 more variable: year <dbl>
```

`slice_min()` and `slice_max()` are used to slice rows which contain the min/max values for a specific variable. For example, suppose we want to get the penguin with the smallest body mass:


``` r
# get smallest penguin by mass
penguins %>% slice_min(body_mass_g, n = 1)
```

```
# A tibble: 1 × 8
  species   island bill_length_mm bill_depth_mm flipper_length_mm body_mass_g sex   
  <chr>     <chr>           <dbl>         <dbl>             <dbl>       <dbl> <chr> 
1 Chinstrap Dream            46.9          16.6               192        2700 female
# ℹ 1 more variable: year <dbl>
```

If there are ties, by default **all tied rows are printed**, e.g. suppose we want the 3 penguins with the longest flipper lengths:


``` r
# get 3 penguins with longest flippers
penguins %>% slice_max(flipper_length_mm, n = 3)
```

```
# A tibble: 8 × 8
  species island bill_length_mm bill_depth_mm flipper_length_mm body_mass_g sex  
  <chr>   <chr>           <dbl>         <dbl>             <dbl>       <dbl> <chr>
1 Gentoo  Biscoe           54.3          15.7               231        5650 male 
2 Gentoo  Biscoe           50            16.3               230        5700 male 
3 Gentoo  Biscoe           59.6          17                 230        6050 male 
4 Gentoo  Biscoe           49.8          16.8               230        5700 male 
5 Gentoo  Biscoe           48.6          16                 230        5800 male 
6 Gentoo  Biscoe           52.1          17                 230        5550 male 
7 Gentoo  Biscoe           51.5          16.3               230        5500 male 
8 Gentoo  Biscoe           55.1          16                 230        5850 male 
# ℹ 1 more variable: year <dbl>
```

It looks like 7 different Gentoo penguins are all tied for 2nd place, so they are ALL returned! You can disable this with an argument, but it's recommended to keep the default behavior here.

You can also set `prop` instead of `n` to return by percent. E.g. let's get the top 1% of penguins by bill length:


``` r
# get top 1% of penguins by bill length
penguins %>% slice_max(bill_length_mm, prop = 0.01)
```

```
# A tibble: 3 × 8
  species   island bill_length_mm bill_depth_mm flipper_length_mm body_mass_g sex   
  <chr>     <chr>           <dbl>         <dbl>             <dbl>       <dbl> <chr> 
1 Gentoo    Biscoe           59.6          17                 230        6050 male  
2 Chinstrap Dream            58            17.8               181        3700 female
3 Gentoo    Biscoe           55.9          17                 228        5600 male  
# ℹ 1 more variable: year <dbl>
```


### `arrange()`

`arrange()` is used to sort rows. Note that since it only sorts rows, it does NOT change the data frame in any "meaningful" way (generally, order of rows/columns is not considered a "meaningful" change). It's primarily used for visual appeal, i.e. for neater presentation of a dataset.

The syntax is `df %>% arrange(expr1, expr2, ...)` where `expr1`, `expr2`, ... can be simply **a column, or some vector expression using columns in the data frame** (similar to `mutate()` or `filter()`) whose resultant values are used for sorting the rows. A few important notes:

 1. **Each next expression is ONLY used to break ties in the previous expressions**, otherwise it's ignored! E.g. if two rows can be sorted by `expr1`, only that is used. However if two rows are tied for `expr1`, then `expr2` (if it exists) will be used to try to break the tie, and so on. This is also a frequent point of confusion for beginners.
 2. Default order is always **ascending**, i.e. small to large, A to Z, earlier to later, FALSE to TRUE. For descending order, wrap your expression in `desc()`.
 3. Rows that are completely tied may be returned in any order.^[For the CS folks again, this means `arrange()` does not guarantee a [stable sort](https://en.wikipedia.org/wiki/Sorting_algorithm#Stability). It seems like this generally isn't a huge concern or priority for the Tidyverse developers, which is fair enough.]

Examples of `arrange()`:


``` r
# sort penguins by ascending flipper length
penguins %>% arrange(flipper_length_mm)
```

```
# A tibble: 333 × 8
  species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g sex   
  <chr>   <chr>              <dbl>         <dbl>             <dbl>       <dbl> <chr> 
1 Adelie  Biscoe              37.9          18.6               172        3150 female
2 Adelie  Biscoe              37.8          18.3               174        3400 female
3 Adelie  Torgersen           40.2          17                 176        3450 female
4 Adelie  Dream               39.5          16.7               178        3250 female
5 Adelie  Dream               37.2          18.1               178        3900 male  
# ℹ 328 more rows
# ℹ 1 more variable: year <dbl>
```

``` r
# sort penguins by descending flipper length
penguins %>% arrange(desc(flipper_length_mm))
```

```
# A tibble: 333 × 8
  species island bill_length_mm bill_depth_mm flipper_length_mm body_mass_g sex  
  <chr>   <chr>           <dbl>         <dbl>             <dbl>       <dbl> <chr>
1 Gentoo  Biscoe           54.3          15.7               231        5650 male 
2 Gentoo  Biscoe           50            16.3               230        5700 male 
3 Gentoo  Biscoe           59.6          17                 230        6050 male 
4 Gentoo  Biscoe           49.8          16.8               230        5700 male 
5 Gentoo  Biscoe           48.6          16                 230        5800 male 
# ℹ 328 more rows
# ℹ 1 more variable: year <dbl>
```

``` r
# since mathematical expressions are allowed, this is also equivalent
penguins %>% arrange(-flipper_length_mm)
```

```
# A tibble: 333 × 8
  species island bill_length_mm bill_depth_mm flipper_length_mm body_mass_g sex  
  <chr>   <chr>           <dbl>         <dbl>             <dbl>       <dbl> <chr>
1 Gentoo  Biscoe           54.3          15.7               231        5650 male 
2 Gentoo  Biscoe           50            16.3               230        5700 male 
3 Gentoo  Biscoe           59.6          17                 230        6050 male 
4 Gentoo  Biscoe           49.8          16.8               230        5700 male 
5 Gentoo  Biscoe           48.6          16                 230        5800 male 
# ℹ 328 more rows
# ℹ 1 more variable: year <dbl>
```

``` r
# sort first by island, then by descending species (if there are ties)
penguins %>% arrange(island, desc(species))
```

```
# A tibble: 333 × 8
  species island bill_length_mm bill_depth_mm flipper_length_mm body_mass_g sex   
  <chr>   <chr>           <dbl>         <dbl>             <dbl>       <dbl> <chr> 
1 Gentoo  Biscoe           46.1          13.2               211        4500 female
2 Gentoo  Biscoe           50            16.3               230        5700 male  
3 Gentoo  Biscoe           48.7          14.1               210        4450 female
4 Gentoo  Biscoe           50            15.2               218        5700 male  
5 Gentoo  Biscoe           47.6          14.5               215        5400 male  
# ℹ 328 more rows
# ℹ 1 more variable: year <dbl>
```

``` r
# again, any expression is possible,
# let's sort first by number of SDs away from mean body mass,
# then by descending last letter of species name for ties,
# then by ascending approximate bill volume if there are further ties
penguins %>% arrange(
  abs(body_mass_g - mean(body_mass_g)) / sd(body_mass_g),
  desc(substr(species, nchar(species), nchar(species))),
  pi * (bill_depth_mm / 2)^2 * bill_length_mm
)
```

```
# A tibble: 333 × 8
  species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g sex   
  <chr>   <chr>              <dbl>         <dbl>             <dbl>       <dbl> <chr> 
1 Gentoo  Biscoe              45.3          13.8               208        4200 female
2 Gentoo  Biscoe              45.5          13.9               210        4200 female
3 Gentoo  Biscoe              45.8          14.6               210        4200 female
4 Adelie  Torgersen           35.1          19.4               193        4200 male  
5 Adelie  Torgersen           46            21.5               194        4200 male  
# ℹ 328 more rows
# ℹ 1 more variable: year <dbl>
```


### Other row functions

Besides these, there's a few other row operations that you may sometimes need, such as `distinct()` for removing duplicates or `add_row()` for manually adding new observations. These may occasionally show up in later contexts, but for now please feel free to explore these on your own.



## Missing values

Before ending this chapter, let's briefly discuss handling missing values, i.e. NAs in R. Missing values are unfortunately very common in data science and are usually tricky to handle well due to many associated pitfalls. We will *briefly* discuss missing values both from a theoretical perspective, and a practical R handling perspective.


### Why missing?

When working with missing values, it's important to ask yourself this: "**why is this data missing**?" Usually, this is impossible to answer definitively, and different observations may be missing for different reasons.

Without getting too out of scope, broadly speaking data can be missing either FOR a relevant reason or NOT FOR a relevant reason.^[This is a **massive oversimplification** here but unfortunately, we don't have time to address the buried nuances. See [this summary](https://www.ncbi.nlm.nih.gov/books/NBK493614) or [this article](https://www.jstor.org/stable/2335739) for the nitty gritty.]

For example, suppose I'm setting up a weather station with several sensors, but I have a small budget, so I buy a cheap pressure sensor that isn't properly weather-proofed and is more prone to producing NAs when it rains. These NAs are missing for a relevant reason; there's a systematic pattern behind the missingness. Since rain and pressure are closely related, this means the pattern of missingness is meaningful, so removing NAs will add significant bias to the data.

Now, suppose I replace it with a different cheap pressure sensor that is weather-proof but just slightly buggy overall, and every hour there's independently a 1% chance it will just randomly read NA. This data is NOT missing for a relevant reason, i.e. the pattern of missingness is not meaningful, and you can simply remove the NAs.

When working with data you should ALWAYS **look for a pattern in the NAs** and ask yourself if there's evidence of a relevant reason for the missingness. You should **ONLY remove NAs with NO clear pattern**, otherwise you risk introducing further systematic biases in your analysis and results.

Again, this is *extremely* simplified, but sufficient for now. In general, for STAT 240 we will only encounter datasets where it's probably ok to drop NA values, but do NOT assume this for all datasets in the real world.


### NAs in R

Let's now briefly discuss R techniques for handling NAs. First it's important to review the difference between `NA` and `NaN` in R:

 - `NA` means the absence of an observation, i.e. a data point was not recorded.
 - `NaN` is usually the result of a mathematically invalid operation, like `0/0`, `0*Inf`, or `Inf-Inf`.
    - Note that `sqrt(-1)` and `log(-1)` also return `NaN` since the input type is of real type. Replace `-1` with `0-1i` to trigger complex evaluation.

Even though they're not the exact same, both `NA` and `NaN` are considered missing in R and can be handled together using the operations covered below. It's also worth noting `NA` is NOT the same as `"NA"`, i.e. a string made of the letters `"N"` and `"A"`


``` r
# check if two objects are the exact same
identical(NA, NA)
```

```
[1] TRUE
```

``` r
identical(NA, NaN)
```

```
[1] FALSE
```

``` r
identical(NA, "NA")
```

```
[1] FALSE
```

In general expressions involving an NA will result in an NA output (though there are some notable exceptions, particularly with character types).


### Identifying NAs

NAs (and also NaNs) in a vector can be identified using `is.na()` which produces a TRUE/FALSE vector corresponding to if a value is NA or not:


``` r
# demo missing vector, note both NA/NaN count as missing
x <- c(3, 8, NA, 2, NaN)
# which values are NA?
is.na(x)
```

```
[1] FALSE FALSE  TRUE FALSE  TRUE
```

``` r
# get only non-NA values
x[!is.na(x)]
```

```
[1] 3 8 2
```

Since this is an ordinary vectorized function, it can be used inside any compatible dplyr function above, such as `mutate()`, `summarize()`, `filter()`, and `arrange()`. To demonstrate these, let's create a demo data frame with a mix of data types as well as some missing values.


``` r
# demo data frame with missing values
df.demo <- tibble(
  date = ymd("24.1.1") + c(0:3, 5),
  x = c(NA, rep(c("A", "B"), 2)),
  y = c(NA, 1, 2, NA, 3),
  z = c(NA, TRUE, FALSE, NA, NA)
)
df.demo
```

```
# A tibble: 5 × 4
  date       x         y z    
  <date>     <chr> <dbl> <lgl>
1 2024-01-01 <NA>     NA NA   
2 2024-01-02 A         1 TRUE 
3 2024-01-03 B         2 FALSE
4 2024-01-04 A        NA NA   
5 2024-01-06 B         3 NA   
```

A common rudimentary of checking missingness is with the aforementioned `summary()` function from section \@ref(basic-df). Note this is the base R `summary()`, NOT the Tidyverse `summarize()` we just covered above. Note however it only reports NAs for some columns, depending on type.


``` r
summary(df.demo)
```

```
      date                 x                   y           z          
 Min.   :2024-01-01   Length:5           Min.   :1.0   Mode :logical  
 1st Qu.:2024-01-02   Class :character   1st Qu.:1.5   FALSE:1        
 Median :2024-01-03   Mode  :character   Median :2.0   TRUE :1        
 Mean   :2024-01-03                      Mean   :2.0   NA's :3        
 3rd Qu.:2024-01-04                      3rd Qu.:2.5                  
 Max.   :2024-01-06                      Max.   :3.0                  
                                         NA's   :2                    
```

A better way is to pipe into `summarize()` and use `is.na()` with either `sum()` for count or `mean()` for proportion of missing values. You can also add `!` in front of `is.na()` to get the count/proportion of non-missing values. All 4 combinations are shown below:


``` r
# get the count/proportion of missing/non-missing values
df.demo %>% summarize(
  num_date_na   = sum(is.na(date)),
  prop_x_na     = mean(is.na(x)),
  num_y_not_na  = sum(!is.na(y)),
  prop_z_not_na = mean(!is.na(z)),
  nrows         = n() # add number of rows for convenience
)
```

```
# A tibble: 1 × 5
  num_date_na prop_x_na num_y_not_na prop_z_not_na nrows
        <int>     <dbl>        <int>         <dbl> <int>
1           0       0.2            3           0.4     5
```

If you just want to apply one function to all columns, you can use `summarize_all()` which is a shortcut for exactly this. For example, we can apply the function `\(x) mean(is.na(x))*100` to get the percent missing in each column:


``` r
# get percent missing in each column
df.demo %>% summarize_all(\(x) mean(is.na(x)) * 100)
```

```
# A tibble: 1 × 4
   date     x     y     z
  <dbl> <dbl> <dbl> <dbl>
1     0    20    40    60
```

:::{.note}
If you check the help page of `summarize_all()` you'll notice this function is tagged with ![](https://dplyr.tidyverse.org/reference/figures/lifecycle-superseded.svg){style="width:115px!important;margin:0!important"} which basically means you can keep using it, but there's a new recommended alternative syntax.^[See this [page on lifecycles](https://lifecycle.r-lib.org/articles/stages.html).] For this function, the new recommendation is to use `across()` instead, but this is a bit outside our scope, so read at your own discretion.
:::

Of course you can also use `filter()` to inspect rows with missing values in some (or all) columns. Examples:


``` r
# get rows with missing x
df.demo %>% filter(is.na(x))
```

```
# A tibble: 1 × 4
  date       x         y z    
  <date>     <chr> <dbl> <lgl>
1 2024-01-01 <NA>     NA NA   
```

``` r
# get rows with missing x or y
df.demo %>% filter(is.na(x) | is.na(y))
```

```
# A tibble: 2 × 4
  date       x         y z    
  <date>     <chr> <dbl> <lgl>
1 2024-01-01 <NA>     NA NA   
2 2024-01-04 A        NA NA   
```

``` r
# get rows where y is missing but x is NOT missing
df.demo %>% filter(is.na(y) & !is.na(x))
```

```
# A tibble: 1 × 4
  date       x         y z    
  <date>     <chr> <dbl> <lgl>
1 2024-01-04 A        NA NA   
```

``` r
# get rows where ANY variable is missing
# this uses if_any() which checks if any given cols satisfy a condition
df.demo %>% filter(if_any(everything(), is.na))
```

```
# A tibble: 3 × 4
  date       x         y z    
  <date>     <chr> <dbl> <lgl>
1 2024-01-01 <NA>     NA NA   
2 2024-01-04 A        NA NA   
3 2024-01-06 B         3 NA   
```

One more thing, did you notice there's actually another form of missingness in `df.demo`? This data frame appears to contain daily observations, but `"2024-01-05"` appears to be missing completely from the data frame. This sneaky situation of data missing by not existing in the data frame completely is surprisingly common and can sometimes be hard to identify (since there's no NAs in the date column to detect).

One easy way to fix this is to use `complete()` and `full_seq()` from [tidyr](https://tidyr.tidyverse.org), yet another core Tidyverse package. This combination can be used to generate a `complete()` data frame by generating a `full_seq()`--uence of values for some specified column. Other columns are filled with NAs by default. Example:


``` r
# this generates a full sequence of dates
# the argument 1 indicates the sequence increases by 1 each observation
df.demo %>% complete(date = full_seq(date, 1))
```

```
# A tibble: 6 × 4
  date       x         y z    
  <date>     <chr> <dbl> <lgl>
1 2024-01-01 <NA>     NA NA   
2 2024-01-02 A         1 TRUE 
3 2024-01-03 B         2 FALSE
4 2024-01-04 A        NA NA   
5 2024-01-05 <NA>     NA NA   
6 2024-01-06 B         3 NA   
```

``` r
# to show ONLY rows that were added using this operation,
# we can first create a dummy column filled with some value,
# complete the data frame, then filter to where the dummy column is NA
df.demo %>%
  mutate(preexisting = TRUE) %>%
  complete(date = full_seq(date, 1)) %>%
  filter(is.na(preexisting))
```

```
# A tibble: 1 × 5
  date       x         y z     preexisting
  <date>     <chr> <dbl> <lgl> <lgl>      
1 2024-01-05 <NA>     NA NA    NA         
```


### Dropping NAs

As mentioned before, for the limited scope of this class, usually rows with NAs can just be dropped for simplicity. The easiest way is to use `drop_na(col1, col2, ...)` where `col1`, `col2`, ... are the columns we care about dropping NAs in. If left empty, `drop_na()` will drop rows where ANY column contains NA. Examples:


``` r
# drop only rows where x is missing
df.demo %>% drop_na(x)
```

```
# A tibble: 4 × 4
  date       x         y z    
  <date>     <chr> <dbl> <lgl>
1 2024-01-02 A         1 TRUE 
2 2024-01-03 B         2 FALSE
3 2024-01-04 A        NA NA   
4 2024-01-06 B         3 NA   
```

``` r
# drop rows where x and y are missing
df.demo %>% drop_na(x, y)
```

```
# A tibble: 3 × 4
  date       x         y z    
  <date>     <chr> <dbl> <lgl>
1 2024-01-02 A         1 TRUE 
2 2024-01-03 B         2 FALSE
3 2024-01-06 B         3 NA   
```

``` r
# drop rows where ANY values are missing
df.demo %>% drop_na()
```

```
# A tibble: 2 × 4
  date       x         y z    
  <date>     <chr> <dbl> <lgl>
1 2024-01-02 A         1 TRUE 
2 2024-01-03 B         2 FALSE
```

:::{.note}
Make sure to **only drop NAs where absolutely necessary**; avoid over-dropping! E.g. suppose you want to use only `x` and `y` for your analysis. You should not drop rows where `z` is missing since it probably won't impede your work.

This is another VERY common pitfall for students. In general you should be extremely "lazy" about dropping, i.e. only use `drop_na()` when and where it is absolutely necessary to do so.
:::


### Replacing NAs

In some *rare* circumstances, you may want to replace NAs with other values. Of course you can do any kind of conditional replacement using `mutate()` and `case_when()`, but you can also use `mutate()` and the specialized tidyr function `replace_na()`. Examples of both:


``` r
# suppose we need to replace NAs in y column with 0
# using mutate and case_when:
df.demo %>% mutate(
  y = case_when(
    is.na(y) ~ 0,
    .default = y
  )
)
```

```
# A tibble: 5 × 4
  date       x         y z    
  <date>     <chr> <dbl> <lgl>
1 2024-01-01 <NA>      0 NA   
2 2024-01-02 A         1 TRUE 
3 2024-01-03 B         2 FALSE
4 2024-01-04 A         0 NA   
5 2024-01-06 B         3 NA   
```

``` r
# same thing but using replace_na instead of case_when:
df.demo %>% mutate(y = replace_na(y, 0))
```

```
# A tibble: 5 × 4
  date       x         y z    
  <date>     <chr> <dbl> <lgl>
1 2024-01-01 <NA>      0 NA   
2 2024-01-02 A         1 TRUE 
3 2024-01-03 B         2 FALSE
4 2024-01-04 A         0 NA   
5 2024-01-06 B         3 NA   
```

In some datasets, NAs may be coded using certain obviously invalid values, e.g. -9999. These can of course also be mutated using `case_when()`, but there's a special function `na_if()` for just this purpose:


``` r
df.demo <- df.demo %>% mutate(w = c(-9999, -9999, 20, 30, -9999))
df.demo
```

```
# A tibble: 5 × 5
  date       x         y z         w
  <date>     <chr> <dbl> <lgl> <dbl>
1 2024-01-01 <NA>     NA NA    -9999
2 2024-01-02 A         1 TRUE  -9999
3 2024-01-03 B         2 FALSE    20
4 2024-01-04 A        NA NA       30
5 2024-01-06 B         3 NA    -9999
```

``` r
df.demo %>% mutate(w = na_if(w, -9999))
```

```
# A tibble: 5 × 5
  date       x         y z         w
  <date>     <chr> <dbl> <lgl> <dbl>
1 2024-01-01 <NA>     NA NA       NA
2 2024-01-02 A         1 TRUE     NA
3 2024-01-03 B         2 FALSE    20
4 2024-01-04 A        NA NA       30
5 2024-01-06 B         3 NA       NA
```
