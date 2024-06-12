

# Intro to R/Rstudio {#rstudio-intro}


This chapter will introduce to you the basics of Rstudio and help you develop a workflow for testing R code and producing beautiful R Markdown documents, which we will be using throughout the semester.



## Why Rstudio? {#rstudio-why}


Rstudio is a free and [open-source](https://github.com/rstudio/rstudio) IDE (integrated development environment) that is designed to help facilitate development of R code. Of course you don't need it (you can write R code using any text editor and execute it with a terminal) but using Rstudio gives you access to a host of modern conveniences, just to name a few:

 - R code completion & highlighting
 - easy access to interpreter console, plots, history, help, etc.
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


That concludes the tour of the basic Rstudio interface. There is also a file editor window (also known as the source panel/window) which we will discuss later in section \@ref(rstudio-rmarkdown), but for now, let's learn to run some basic R commands!




## Basics of R


In this section, we will give you a brief introduction to working with R. No prior coding experience is assumed. You are *highly encouraged* to copy and run the examples provided as you read, as well as to try the exercises and peruse the extra references when provided.



### Running R code


The main way to run R code is to type or copy into the console. Comments can be written after a hashtag `#` and will not be run.

If there is output, it will be displayed either in the console directly if it's text, or in the plot window if it's visual. In these notes, output is shown in a separate box below, starting with `##` .

Try running these examples below in your console and observe the output:


``` r
# this line is a comment and will not be run
# use the copy button in the top corner to easily run this example --->
print("output is shown here")     # you can also add comments here
```

```
## [1] "output is shown here"
```




``` r
# a VERY simple barplot
# the c() function creates a vector of numbers
barplot(c(1,3,2))
```

<img src="02-rstudio-basics_files/figure-html/visual-output-1.svg" width="576" />


:::{.tip}
All functions in these notes should automatically link to their online help pages (these are the same help pages inside Rstudio that we saw in the previous section). Try clicking on the `barplot()` function here or in the previous code block to see its help page.
:::


### Basic math

One of the first things you should learn about R is how to use it as a calculator to do basic math. Operators like `+`, `-`, `*`, `/`, `^`, and parentheses `( )` work just like how you'd expect and respect order of operations:


``` r
( 5 * 2 ^ 3 - 4 ) / 9 + 1
```

```
## [1] 5
```

Trigonometric functions like `sin()`, `cos()`, `tan()`, (and their `asin()`, `acos()`, `atan()` where the a-- prefix means arc--), also work as you'd expect and use radian units. Note `pi` is conveniently predefined too.


``` r
cos(2 * pi) * atan(-1) * 4
```

```
## [1] -3.141593
```

Exponential and logarithm functions `exp()`, `log()`, also work as you'd expect and default to natural base $e$.
















<!--

- basic rundown of R commands
- add notes about common console issues
  - `>` prompt character
  - `+` prompt when line not ended
  - white space and splitting lines
  - saving doesn't return
  - practice using tab
  - practice using console history


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
