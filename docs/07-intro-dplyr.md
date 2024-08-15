

# Intro to dplyr

[dplyr](https://dplyr.tidyverse.org) is the core Tidyverse package for transforming and your raw datasets into a clean and usable format ([link to cheat sheet](https://rstudio.github.io/cheatsheets/data-transformation.pdf)). Its functions are versatile, performant, and have a consistent and user friendly syntax. These traits make it highly suitable for data science at all levels.



``` r
# import all core tidyverse packages
library(tidyverse)
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


## Column-wise functions

### `select()`

### `rename()`

### `mutate()`

### `summarize()`

## Row-wise functions

### `slice()`

### `drop_na()`

### `filter()`

### `arrange()`
