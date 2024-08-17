

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

For now, we're going to continue using the Palmer penguins dataset [`penguins_complete.csv`](https://bwu62.github.io/stat240-revamp/data/penguins_complete.csv) as an example data frame. Let's load the data in:


``` r
# load in the familiar penguins dataset
penguins <- read_csv(
  "https://bwu62.github.io/stat240-revamp/data/penguins_complete.csv",
  show_col_types = FALSE
)
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
penguins <- read_csv("data/penguins_complete.csv", show_col_types = FALSE)
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
penguins2 %>%
  mutate(
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
penguins2 %>%
  mutate(
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
penguins2 %>%
  mutate(
    small_bill = bill_length_mm < 39 | bill_depth_mm < 18,
    fake_dates = seq(today(), today() + nrow(penguins) - 1, by = 1)
  )
```

```
# A tibble: 333 × 6
  species sex    bill_length_mm bill_depth_mm small_bill fake_dates
  <chr>   <chr>           <dbl>         <dbl> <lgl>      <date>    
1 Adelie  male             39.1          18.7 FALSE      2024-08-16
2 Adelie  female           39.5          17.4 TRUE       2024-08-17
3 Adelie  female           40.3          18   FALSE      2024-08-18
4 Adelie  female           36.7          19.3 TRUE       2024-08-19
5 Adelie  male             39.3          20.6 FALSE      2024-08-20
# ℹ 328 more rows
```

A notable function that is extremely useful inside `mutate()` is `case_when()` which can calculate different values depending on certain conditions.^[It's similar to a switch function in other languages.] The basic syntax is `df %>% mutate(new_col = case_when(cond1 ~ expr1, cond2 ~ expr2, ...))` where `cond1`, `cond2`, ... are logical condition vectors checked one by one in the given order, and `expr1`, `expr2`, ... are R expressions that are activated when a condition matches.

For example, suppose we want to create some new column differently depending on sex and bill depth:


``` r
# use case_when() inside a mutate() depending on some conditions
# .default sets the "default" result, when no conditions match OR when we have NAs
penguins2 %>%
  mutate(
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
penguins2 %>%
  summarize(
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
penguins2 %>%
  summarize(
    n            = n(),
    n_male       = sum(sex == "male"),
    pct_male     = 100 * n_male / n,
    n_female     = sum(sex == "female"),
    pct_female   = 100 * n_female / n,
    pct_NA       = 100 * mean(
      is.na(species) | is.na(sex) | is.na(bill_length_mm) | is.na(bill_depth_mm)
    ), # get proportion of rows with NA (mean of logicals gives proportion of TRUEs)
    q90_len      = quantile(bill_length_mm, 0.90),
    q90_dep      = quantile(bill_depth_mm,  0.90),
    pmed_len     = mean(bill_length_mm <= median(bill_length_mm)),
    pmed_dep     = mean(bill_depth_mm  <= median(bill_depth_mm))
  )
```

```
# A tibble: 1 × 10
      n n_male pct_male n_female pct_female pct_NA q90_len q90_dep pmed_len pmed_dep
  <int>  <int>    <dbl>    <int>      <dbl>  <dbl>   <dbl>   <dbl>    <dbl>    <dbl>
1   333    168     50.5      165       49.5      0    50.8    19.5    0.502    0.508
```

It's also common to use `summarize()` to compute statistical results. For example we can calculate the 95% confidence intervals for the mean bill length and depth (ignoring species/sex) which is something we will cover in more detail later in the course:


``` r
# we first compute some intermediate statistics,
# then use those to compute the intervals
penguins2 %>%
  summarize(
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

Again, I think it's important to stress **ANY expression involving columns that results in a single value** can be used inside `summarize()`. The [dplyr cheat sheet](https://rstudio.github.io/cheatsheets/data-transformation.pdf) has on page 2 some more examples of useful summarizing functions if you wish to read more.


## Row-wise functions

### `slice()`

### `drop_na()`

### `filter()`

### `arrange()`
