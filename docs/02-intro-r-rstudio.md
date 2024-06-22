

# Intro to R/Rstudio {#rstudio-intro}


This chapter will introduce to you the basics of Rstudio and help you develop a workflow for testing R code and producing beautiful R Markdown documents, which we will be using throughout the semester.



## Why Rstudio? {#rstudio-why}


Rstudio is a free and [open-source](https://github.com/rstudio/rstudio) IDE (integrated development environment) that is designed to help facilitate development of R code. Of course you don't need it (you can write R code using any text editor and execute it with a terminal) but using Rstudio gives you access to a host of modern conveniences, just to name a few:

 - R code completion & highlighting
 - easy access to interpreter console, plots, history, help, etc.
 - integration with scientific communication tools (e.g. R Markdown, Shiny, etc.)
 - robust debugging tools
 - easy package/environment management
 - custom project workflows (e.g. building websites, presentations, packages, etc.)
 - GitHub and SVN integration
 - and so much more...

We will only learn a small fraction of what Rstudio has to offer in this course. As always, you are encouraged to explore more on your own.



## Rstudio interface {#rstudio-interface}


This is the default interface setup of Rstudio. Of course you can customize it, but this is what you should see out-of-the-box:

![](https://i.imgur.com/V9PAoE2.png)

Below is a brief description of the purpose of each tab. The ones we will be using most frequently in this course are highlighted in **bold**.


 A.  In section A you will find the **Console**, Terminal, and Background Jobs tabs
     - **Console**: This is arguably the most important tab in Rstudio. It provides direct access to the R interpreter, allowing you to run code and see outputs.
     
     There are a few other useful tips for working in the console:
     - You can use the TAB key to autocomplete code as you type. This works both for built in functions, user-defined objects, or even file paths (more on this later). It is *highly recommended* to make use of autocomplete as much as possible because it can help prevent typo errors in your code.
     - You can also easily rerun previously executed commands by either using the keyboard UP and DOWN arrow keys to navigate through your history, or even search your history by using CTRL/CMD + R.
     - Terminal: This tab opens a terminal in your current working directory (see section \@ref(rstudio-wd)). By default, this is a [Git Bash](https://gitforwindows.org/) terminal on Windows and a [zsh](https://medium.com/@luzhenna/getting-started-with-zsh-on-a-macbook-bd1c98c6f383) terminal on Macs, but this can be easily changed in the Options menu.
     - Background Jobs: Rstudio may sometimes run certain operations as background jobs here. Alternatively, you can also run background R scripts here if you desire.
     
 B.  In section B we have the **Environment**, History, Connections, and Tutorial tabs
     - **Environment**: This is probably the second most important tab in Rstudio. Any created variables, defined functions, imported datasets, or other objects used in your current session will appear here, along with some brief descriptions about them.
       - The [broomstick icon](https://i.imgur.com/llL6kyv.png) in this tab can be used to clear the current session environment, removing all defined objects. This is basically equivalent to restarting Rstudio.
       - Next to the broomstick, there's an icon that shows the memory usage of your current R session, as well as an "Import Dataset" option that can help you load datasets, although we will primarily try to write this code by hand for learning purposes.
     - History: In this tab, you will find a history of previous commands from your current session, if you want to edit and rerun something. You can also search through this history, which will search through not just your current session but ALL previous commands anytime you opened Rstudio in the past.
     - Connections/Tutorial: You can start special data connections, or find some extra R tutorials here if you wish.
     
 C.  In section C are the Files, **Plots**, Packages, **Help**, **Viewer**, and Presentation tabs.
     - Files: This tab gives you a small, integrated file explorer. You can navigate around your computer, create/delete/rename files, copy/move files, etc.
     - **Plots**: Any plots/graphs you make will show up here (if you set the options right, otherwise they may show in a pop-up). There are a few other useful features to know:
       - In the top left corner of this tab, there are left/right arrows for navigating between previous and next plots (if you made multiple plots)
       - Next to that, there's a "Zoom" button which opens the plot in a larger window.
       - Next, there's an "Export" button which allows you to export the plot to image/pdf/clipboard. This opens a window with additional export options.
       - Next, there are buttons to remove the current plot, or clear all plots.
     - Packages: Here you can view/install/update/load/unload packages. Note you can also install packages using the console, like we did in the previous section.
     - **Help**: This is one of the other most useful tabs in Rstudio. Here, you can access the built in R help pages. This is one of the FIRST places you should visit for help with R functions/objects.
       - There are several ways to access the help pages. Suppose you want help with the `install.packages()` function. You can either run `?install.packages` or `help(install.packages)` in the console, or put your cursor on the function in your code and hit the F1 key.
       - The help page may contain these following sections, each of which presents different types of information:
         i.   *Description*, showing a brief summary of the purpose of the function
         ii.  *Usage*, listing available arguments (i.e. options). If an argument has an ` = ` sign and a value, this denotes the default value
         iii. *Arguments*, where more details about the arguments can be found
         iv.  *Details*, where further details on the function can be found
         v.   *Value*, which gives info on what the function returns as an output
         vi.  Sometimes, other sections may appear here with more specialized info
         vii. At the end, you may also find some advanced notes, links to related functions, additional references, and example code demos.
     - **Viewer**: This is where a preview of your Rmd document output will appear when knitting (which we learn very soon).
       - In the top corner, there are buttons letting you clear current or all viewer items, as well a button to open the viewer in a new window in your default web browser, which can also be useful sometimes for checking your work or printing/exporting.
     - Presentation: This final tab is useful if you ever make presentations in Rstudio, e.g. using R's [Beamer](https://bookdown.org/yihui/rmarkdown/beamer-presentation.html) or [reveal.js](https://github.com/rstudio/revealjs) integrations.


That concludes the tour of the basic Rstudio interface. There is also a file editor window (also known as the source panel/window) which we will discuss later in section \@ref(rstudio-rmarkdown), but for now, let's learn to run some basic R commands!




## Basics of R {#r-basics}


In this section, we will give you a brief introduction to working with R. No prior coding experience is assumed. You are **highly encouraged** to copy and **run the examples** as you read. If you have time and capacity, you are also encouraged to peruse the linked help pages and extra reference links, but this is not mandatory.



### Running R code {#r-running}


The main way to run R code is to type or copy into the console. Comments can be written after a hashtag `#` and will not be run. If there is output, it will be displayed either in the console directly if it's text, or in the plot window if it's visual. In these notes, output is shown in a separate box below, starting with `##` .

Try running these examples below in your console and observe the output:


``` r
# this line is a comment and will not be run
# use the copy button in the top corner to easily run this example --->
print("output is shown here") # you can also add comments here
```

```
## [1] "output is shown here"
```


:::{.note}
The ` [1] ` that appears at the start of the output line just means this is the first output value. These bracketed numbers are not part of the actual output and should be ignored.
:::





``` r
# a VERY simple barplot
# the c() function creates a vector of numbers
barplot(c(1, 3, 2))
```

<img src="02-intro-r-rstudio_files/figure-html/visual-output-1.svg" width="576" />




:::{.tip}
All functions in these notes should automatically link to their online help pages (these are the same help pages inside Rstudio that we saw in the previous section). Try clicking on the `barplot()` function here or in the previous code block to see its help page.
:::




### Basic math {#r-math}


One of the first things you should learn about R is how to use it as a calculator to do basic math. Operators like `+`, `-`, `*`, `/`, `^`, and parentheses `( )` work just like how you'd expect. Note **R respects standard order of operations** (see [this page on operation order](https://rdrr.io/r/base/Syntax.html) for more details).


``` r
(-5 * -3^2 + 4) / 7 - 6
```

```
## [1] 1
```


:::{.note}
R will sometimes output in scientific notation, especially if the number cannot be exactly numerically represented due to computing limitations. For example, if you compute `2^50` R will show the result as `1.1259e+15`, i.e. $1.1259\times10^{15}$. You can also type in this scientific notation and R will understand it.

``` r
2^50
```

```
## [1] 1.1259e+15
```

Also note that due to the limitations of [how computers represent numbers](https://en.wikipedia.org/wiki/IEEE_754), R cannot distinguish between 2 numbers that differ by less than about $2\times10^{-16}$, or 0.0000000000000002.
:::


You can also perform integer division in R, i.e. dividing to get the quotient and remainder, by using `%/%` for the quotient and `%%` for the remainder. This allows you to check, for example, if a number is even or odd.


``` r
13 %/% 2
```

```
## [1] 6
```

``` r
13 %% 2
```

```
## [1] 1
```


:::{.note}
Operators like `%/%` or `%%` may seem strange at first, but they work just like any other [binary operators](https://www.datacamp.com/tutorial/operators-in-r) in R such as `+` or `^` . There are other examples of such operators like `%in%` and `%>%` which we will learn about later.
:::


Trigonometric functions `sin()`, `cos()`, `tan()`, (and their inverses `asin()`, `acos()`, `atan()` where the a-- prefix means arc--), also work as you'd expect and use radian units. Note `pi` is conveniently predefined as $\pi$. [Hyperbolic trig functions](https://rdrr.io/r/base/Hyperbolic.html) also exist if you need them.


``` r
cos(2 * pi)
```

```
## [1] 1
```

``` r
atan(-1) * 4
```

```
## [1] -3.141593
```

Exponential and logarithm functions `exp()` and `log()`, also work as you'd expect and default to the natural base $e$. Note the log function has an optional `base` argument for using a different base. There are also special base 10 and 2 versions `log10()` and `log2()` .


``` r
log(exp(2)) * log10(100)
```

```
## [1] 4
```


``` r
log(3^5, base = 3)
```

```
## [1] 5
```

Additionally, `abs()` computes the absolute value and `sqrt()` the square root (note by convention, ONLY the positive root is returned). Taking the square root of a negative number will return `NaN`.


``` r
sqrt(abs(-9))
```

```
## [1] 3
```




### Special values {#r-specials}


We already mentioned `pi` is predefined. There are a few other important special values in R. `TRUE` and `FALSE`, along with their abbreviations `T` and `F` are also predefined. Note the capitalization; **R is a case-sensitive language** so `true`, `True`, and `t` are NOT the same as `TRUE` (the first two are not defined, while `t()` is the matrix transpose function).


``` r
T
```

```
## [1] TRUE
```

``` r
true
```

```
## Error in eval(expr, envir, enclos): object 'true' not found
```

An important thing to note is that in R, doing any kind of **math turns `TRUE` into 1 and `FALSE` into 0**.


``` r
exp(FALSE) * (TRUE + sqrt(TRUE))
```

```
## [1] 2
```

Mathematical expressions may also return `NaN` for **N**ot **a** **N**umber, i.e. undefined; or `Inf` for infinite. Note R differentiates between positive infinity `Inf` and negative infinity `-Inf`.


``` r
sqrt(-4)
```

```
## [1] NaN
```

``` r
1 / 0
```

```
## [1] Inf
```

``` r
log(0)
```

```
## [1] -Inf
```

Additionally, `NA` is used to represent missing values, i.e. when data is not available. **Note `NA` and `NaN` are NOT the same**. We will learn later about how to handle `NA` missing values.




### Assignment


In R, variables are typically assigned using the `<-` operator, which is just a less than `<` and minus `-` put together. You can also use `=` but `<-` is recommended for stylistic reasons (see [this blog post](https://colinfay.me/r-assignment/) for more details). For this class, **both are acceptable** but we will prefer `<-` in the notes. ^[A comprehensive R style guide written by Hadley Wickham can be found here: <https://style.tidyverse.org/>{target="_blank"}.]


``` r
# this is preferred
x <- 5
print(x)
```

```
## [1] 5
```


``` r
# this is equivalent and acceptable, but discouraged
x = 5
print(x)
```

```
## [1] 5
```


:::{.tip}
There are convenient keyboard shortcuts for the assignment `<-` operator: ALT + -- on Windows and Option (⌥) + -- on Mac.
:::


Generally, `=` is reserved for setting arguments inside functions, e.g. like the previous code chunk where we computed `log()` with a custom base by setting the `base` argument.


``` r
log(3^5, base = 3)
```

```
## [1] 5
```

Variable names can be any combination of upper and lower-case letters, numbers, or period `.` and underscore `_` (which are both treated similar to letters), with one caveat: **variables must begin with a letter or period**, not a number or underscore. You may not use any other characters in variable names. ^[This is only a short summary. Technically, any set of ANY characters can be used to create a [non-syntactic name](https://adv-r.hadley.nz/names-values.html#non-syntactic), but this is beyond our current scope.]


``` r
# these variable names are ok,
# also remember R is case sensitive!
var1 <- 1
Var1 <- 2
.OtherVariable <- 3
another.variable_42 <- 4

var1 + Var1 + .OtherVariable + another.variable_42
```

```
## [1] 10
```

``` r
# even these morse code looking variable names,
# while not recommended, are technically ok:
. <- 1
.. <- 2
._ <- 3
._..__ <- 4

. + .. + ._ + ._..__
```

```
## [1] 10
```


``` r
# these variable names will raise errors:
#   1var, _var, bad-var,   e.g.:
1var <- 1
```

```
## Error: unexpected symbol in "1var"
```


:::{.note}
Observe that if the results of an expression are saved to a variable, R will NOT print it by default. This is often confusing to first time R users, since it may seem like nothing happened. For example, running the following:

``` r
result <- 3 * 4 - 5
```
produces no visible output. This is normal behavior, since the output has been redirected into a variable. To inspect the result, you must explicitly call or `print()` the object again:

``` r
result
```

```
## [1] 7
```
:::




### Summary functions


So far, we've only seen functions that run on individual values, but there are also functions in R that run on and summarize a dataset. These are often statistical in nature. We will only give a brief summary here of how to compute these in R. A more in-depth discussion of their meaning and applications will be saved for later in the course.

Suppose we gather a sample and observe the following values: 3, 6, 6, 2, 4, 1, 5 (don't worry about what these mean, we're just using it as a demo). We can create a vector using the `c()` function to store our data and save it:


``` r
data <- c(3, 6, 6, 2, 4, 1, 5)
data
```

```
## [1] 3 6 6 2 4 1 5
```

The `sum()` and `length()` functions work like you expect and produce the sum and length of the sample. You can use them to compute the [mean](https://www.mathsisfun.com/mean.html) of your sample, which can also be done directly using `mean()`.


``` r
sum(data) / length(data)
```

```
## [1] 3.857143
```

``` r
mean(data)
```

```
## [1] 3.857143
```

We can also find the [median](https://www.mathsisfun.com/median.html) (i.e. middle number) with the `median()` function. (Sadly, there's no built-in [mode](https://www.mathsisfun.com/mode.html) function in R, but this can be achieved with [other packages](https://rdrr.io/cran/DescTools/man/Mode.html).)


``` r
median(data)
```

```
## [1] 4
```

We can generalize from the median (which is the 50-th percentile) to compute [any percentile](https://www.mathsisfun.com/data/percentiles.html) using the `quantile()` function, e.g. suppose we want to compute the 30-th percentile:


``` r
quantile(data, 0.3)
```

```
## 30% 
## 2.8
```

The [standard deviation](https://www.mathsisfun.com/data/standard-deviation.html) is another important statistic (think of it as the distance of the average observation from the mean) and can be computed using `sd()`. Note this is equivalent to the square root of the variance which can be found with `var()`.


``` r
sqrt(var(data))
```

```
## [1] 1.9518
```

``` r
sd(data)
```

```
## [1] 1.9518
```

We can also find the `min()` and `max()` of the sample (which together give us the `range()` of the dataset).


``` r
min(data)
```

```
## [1] 1
```

``` r
max(data)
```

```
## [1] 6
```

Another important function for working with samples is the `%in%` operator, which lets us check if a value exists in the dataset.


``` r
# 6 appears in the sample
6 %in% data
```

```
## [1] TRUE
```

``` r
# 7 does not appear in the sample
7 %in% data
```

```
## [1] FALSE
```

One final statistical function that is extremely common is `cor()` which computes the correlation between 2 vectors. E.g. suppose you had the following $(x,y)$ points: (3.4,1), (5,4.6), (5.7,6.8), (6.5,5.3). You can compute the correlation between the $x$ and $y$ points like so:


``` r
x = c(5, 6.5, 3.4, 5.7)
y = c(4.6, 5.3, 1, 6.8)
cor(x,y)
```

```
## [1] 0.8690548
```

There are other miscellaneous functions for working with vectors that are sometimes useful that we won't cover in detail now, but you can explore them on your own, such as `prod()` for computing the product of all numbers in a vector, `sort()` for sorting a vector, `rev()` for reversing a vector, `unique()` for getting the unique values in a vector, `scale()` for linearly shifting and scaling the data to have mean 0 and standard deviation 1, and `cumsum()` and `cumprod()` for the cumulative sum and product along a vector, and many many more...



### Logical comparison


Finally, let's learn some basic logical comparisons. These will be crucial for data cleaning and filtering operations later on.

In R, equality comparison is done using the `==` operator. **Note the double equal sign**; single equal is for assignments and arguments. Inequality can be checked using `!=`.


``` r
x <- (2 + 3)^2
x == 25
```

```
## [1] TRUE
```

``` r
# if instead we ask "is x not equal to 25", we should get FALSE
x != 25
```

```
## [1] FALSE
```

Note `!` used individually is the NOT operator, i.e. it turns `TRUE` into `FALSE` and vice versa.


``` r
!TRUE
```

```
## [1] FALSE
```

``` r
# this is equivalent to x != 25
!(x == 25)
```

```
## [1] FALSE
```

Inequalities are done using `<`, `<=`, `>`, `>=`, for less than (or equal to) and greater than (or equal to).


``` r
x < 30
```

```
## [1] TRUE
```

``` r
x >= 25
```

```
## [1] TRUE
```

Logical statements can be chained together using the `&` AND operator as well as the `|` OR operator (this vertical bar character is typed on most keyboards using SHIFT + `\`).

`&` will only return true if the expressions on both sides are both true; `|` will return true if at least one of the expressions on both sides is true. Note that `&` appears higher on R's [order of operations](https://stat.ethz.ch/R-manual/R-devel/library/base/html/Syntax.html) than `|`.


``` r
(x > 20) & (x <= 30)
```

```
## [1] TRUE
```

``` r
(x > 20) | (x != 25)
```

```
## [1] TRUE
```

You can of course chain these together with other R commands to compare more complicated expressions. The sky is the limit!


``` r
# check if x² is even OR if mean of data + 2 * sd is greater than the max
# note order of operations means we don't need extra parentheses
# of course, you can add extra parentheses for readability if you wish!
x^2 %% 2 == 0 | mean(data) + 2 * sd(data) > max(data)
```

```
## [1] TRUE
```




### Packages


As a last topic, let's briefly discuss packages. One of the best features of R is the ability for anyone to easily write and distribute packages on [CRAN](https://cran.r-project.org/) (**C**omprehensive **R** **A**rchive **N**etwork). Currently, there are 20976 packages available on CRAN. There are also a further 2300 packages on the bioinformatics-specific package archive [Bioconductor](https://www.bioconductor.org/), as well as countless more on [GitHub](https://github.com/topics/r-package).

In this course, we will primarily make use of the [Tidyverse](https://www.tidyverse.org/) suite of packages, which contains several important packages for data science: `readr` for reading in data, `ggplot2` for plotting data, `dplyr` and `tidyr` for cleaning data, and `lubridate` and `stringr` for working with dates and strings. We will learn each of these as the course progresses.

The most important thing you need to remember about packages is this:

> ***install once; load daily***

I.e. you only need to install a package *once* to your computer, but you need to load it *every time* you reopen Rstudio and want to use it (unless you're one of those people that never closes any programs). Of course if you want to setup R/Rstudio on a new computer, you need to install it again there as well.




#### Install a package


Unless you're doing extremely niche work, generally any packages you want to use will be on CRAN and can be easily installed one at a time by running the following.


``` r
# you should have already installed tidyverse from last chapter
# note the package name MUST be in quotes
install.packages("tidyverse")
```

It's important to check the output messages to see if the install was successful, and if not, to find important "Error:..." keywords to use for troubleshooting. Sometimes R will ask you different things during install:

 - If R asks you to use a "personal library", say yes. This just means it can't store the package files in your system folder due to system permissions, so it will store it somewhere else (typically in your user directory).
 - If R asks you to install "from source", try no first; if that fails, retry with yes. This just means if you want R to prioritize using precompiled executable files when installing, which is generally much faster.
 - If R asks you to update existing packages before installing a new package, this is entirely up to you. I like to update my packages regularly, but there's usually no harm if you don't want update immediately.
   - If you try to update packages that are currently loaded, R may ask you to first "restart R", which is usually a good idea.




#### Loading a package


You can load a package by using either `library()` or `require()`, which are basically the same. ^[The only difference is `require()` can be used to check if a package exists and will return `FALSE` if it doesn't, whereas `library()` will just error out, see <https://www.geeksforgeeks.org/the-difference-between-require-and-library-in-r/>{target="_blank"} for more details.]



``` r
library(tidyverse)
```

```
## ── Conflicts ────────────────────── tidyverse_conflicts() ──
## ✖ tidyr::extract()        masks magrittr::extract()
## ✖ dplyr::filter()         masks stats::filter()
## ✖ rvest::guess_encoding() masks readr::guess_encoding()
## ✖ dplyr::lag()            masks stats::lag()
## ✖ purrr::set_names()      masks magrittr::set_names()
## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

Upon loading, many packages will print various diagnostic messages to the console. These are generally completely ignorable. Sometimes these will warn about "Conflicts", this is standard and just means it has overridden other default functions. E.g. You can see above the `filter()` function from the package `dplyr` has overwritten the pre-loaded [`filter()`{.R}](https://rdrr.io/r/stats/filter.html) function from the `stats` package.

:::{.tip}
You may have already guessed from the message in the output above, but you can also access a function from another package without loading the entire package by using the syntax `package::function()`. This is often done to either avoid name conflicts or to clarify to the reader which functions come from which packages.
:::




### R cheat sheets


Those are probably the most important R commands you need to know for now. Below I have curated a short selection of R "cheat sheets" for your reference should you need it, in rough order of how useful I think it will be for a first time R learner.

 - Matt Baggott's [R Reference Card v2.0](https://cran.r-project.org/doc/contrib/Baggott-refcard-v2.pdf) is a nice complete one-stop-shop for all of R's built-in functions.
 - IQSS's [Base R Cheat Sheet](https://iqss.github.io/dss-workshops/R/Rintro/base-r-cheat-sheet.pdf) and Alexey Shipunov's [One Page R Reference Card](https://herba.msu.ru/shipunov/school/biol_240/en/supp/refcard/rrefc_en.pdf) are both slightly shorter and more curated, but offer a nice, tighter set of the most critical R commands, along with useful examples of their syntax.
 - For a slightly longer but more complete reference manual on R, especially with more details of how R works and different object types and data structures, Emmanuel Paradis's [R for Beginners](https://cran.r-project.org/doc/contrib/Paradis-rdebuts_en.pdf) may be helpful.

<!--https://cran.r-project.org/doc/contrib/Short-refcard.pdf-->
<!--https://www.maths.usyd.edu.au/u/jchan/Rcommands.pdf-->




## R Markdown


In the final section of this chapter, we will introduce you to R Markdown, which is a document format that allows you to seamlessly organize and integrate text and R code/output in an easily readable and editable way. It supports many [output file types](https://rmarkdown.rstudio.com/lesson-9.html) including HTML, PDF, and DOCX, and can be used to write reports, articles, presentations, ebooks, and even websites (in fact, this entire website is written in R Markdown, and the GitHub repo even maintained using Rstudio; you can view the source code of any page using the "View source" button in the right sidebar).

Let's start with an example! Below is a basic R Markdown demo file called [`demo.Rmd`](demo.Rmd), which produces [`demo.html`](demo.html){target="_blank"} as output (feel free to download the demo to test it out). We will use this example below to learn how to work with Rmd files.


````{.md .wrapCode}
---
title: "Demo Rmd file"
author: "Jane Doe"
date: "2024-06-20"
output: html_document
---

```{r setup, include=FALSE}
# this is a standard "setup" chunk usually found at the top of Rmd files,
# often used for setting options, loading files, and importing libraries
knitr::opts_chunk$set(echo = TRUE)
library(tidyverse)
```

# Section 1

## Subsection A

Here's some ordinary text. You can use Markdown syntax to add more features, e.g. here's a [link](https://markdownguide.org/cheat-sheet), here's some **bold text**, and here's some `inline code`.

 1. Lists are also east to add!
 2. Here's a second item.
 3. You can even add sublists:
    - Here's a sublist with bullets.
    - Another bullet?

## Subsection B

You can easily incorporate R code into an Rmd file, with outputs and plots that auto-update. Here's an example code chunk named "chunk1".

```{r chunk1, fig.align="center"}
data <- c(3, 6, 6, 2, 4, 1, 5)
mean(data)
hist(data)
```

You can even refer to R objects inside text, e.g. the sample mean and standard deviation are `r mean(data)` and `r sd(data)`.

# Section 2

Here's a second section.

<!-- comments in an Rmd file must use HTML-style syntax -->
````


Let's briefly break down this file and talk about some of the major pieces.


### YAML header

Rmd files usually start with a [YAML](https://yaml.org/) header:


``` markdown
---
title: "Demo Rmd file"
author: "Jane Doe"
date: "2024-06-20"
output: html_document
---
```

This contains some important metadata about the file, like title, author, and date. The `output:` option sets the output format R uses 






<!--

- add notes about common console issues
  - `>` prompt character
  - `+` prompt when line not ended
  - white space and splitting lines
  - saving doesn't return
  - practice using tab
  - practice using console history

* remember:
  - set %in% operations
  - floor/ceil/round
  - c, :, seq


## R Markdown {#rstudio-rmarkdown}

- things to cover
  - rmd document overview
    - knit and view
    - yaml
    - code chunks
      - setup chunk
      - name
      - options
    - markdown

  - testing code interactively
  - libraries
  - troubleshooting tips


## Extra: if/else, for/while



::: {.tip}
You only need to install a package to your computer once, but you need to load it every time you want to use it in an R session.

To install a package, either use the "Install" button in the Packages tab, or copy the following into the console, replacing "packageName" with the name of the package you want to install.


``` r
install.packages("packageName")
```
:::



### Working directory {#rstudio-wd}




<details><summary>Exercise solutions</summary>


``` r
head(mtcars)
```

```
##                    mpg cyl disp  hp drat    wt  qsec vs am
## Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1
## Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1
## Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1
## Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0
## Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0
## Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0
##                   gear carb
## Mazda RX4            4    4
## Mazda RX4 Wag        4    4
## Datsun 710           4    1
## Hornet 4 Drive       3    1
## Hornet Sportabout    3    2
## Valiant              3    1
```

</details> 

-->