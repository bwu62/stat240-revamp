

# Intro to Rstudio {#rstudio-intro}

This chapter will introduce to you the basics of Rstudio and help you develop a workflow for testing R code and producing beautiful R Markdown documents, which we will be using throughout the semester.


## What is Rstudio? {#rstudio-whatis}

Rstudio is a free and [open-source](https://github.com/rstudio/rstudio) IDE (integrated development environment) that is designed to help facilitate development of R code. Of course you don't need it (you can write R code using any text editor and execute it with a terminal) but using Rstudio gives you access to a host of modern conveniences, just to name a few:

 - syntax completion & highlighting
 - easy access to code, plots, history, help, etc.
 - robust debugging tools
 - easy package/environment management
 - custom project workflows (e.g. building websites, presentations, packages, etc.)
 - GitHub and SVN integration
 - and so much more...

We will only learn a small fraction of what Rstudio has to offer in this course. As always, you are encouraged to explore more on your own.


## Interface {#rstudio-interface}

This is the default interface setup of Rstudio. Of course you can customize it, but this is what you should see out-of-the-box:

![](https://i.imgur.com/V9PAoE2.png)

Below is a brief description of the purpose of each tab. The ones we will be using most frequently in this course are highlighted in **bold**.

 A.  In section A you will find the Console, Terminal, and Background Jobs tabs
     - **Console**: This is arguably the most important tab in Rstudio. It provides direct access to the R interpreter, allowing you to run code and see outputs.
     
       There are a few other useful tips for working in the console:
       - You can use the TAB key to autocomplete code as you type. This works both for built in functions, user-defined objects, or even file paths (more on this later). It is *highly recommended* to make use of autocomplete as much as possible because it can help prevent typo errors in your code.
       - You can also easily rerun previously executed commands by either using the keyboard UP and DOWN arrow keys to navigate through your history, or even search your history by using CTRL/CMD + R.
     - Terminal: This tab opens a terminal in your current working directory (see section \@ref(rstudio-wd)). By default, this is a [Git Bash](https://gitforwindows.org/) terminal on Windows and a [zsh](https://medium.com/@luzhenna/getting-started-with-zsh-on-a-macbook-bd1c98c6f383) terminal on Macs, but this can be easily changed in the Options menu.
     - Background Jobs: Rstudio will sometimes run certain setup operations here as a background job. Alternatively, you can also use this tab to run an R script in the background if you desire.
     
 B.  In section B you will find the Environment, History, Connections, and Tutorial tabs
     - **Environment**: This is probably the second most important tab in Rstudio. Any created variables, defined functions, imported datasets, or other objects used in your current session will appear here, along with some other brief descriptions about them.
       - Note: the [broomstick icon](https://i.imgur.com/llL6kyv.png) in this tab can be used to clear the current session environment, removing all defined objects. This is basically equivalent to restarting Rstudio.
     - History





## run some r code

- add notes about common console issues
  - `>` prompt character
  - `+` prompt when line not ended
  - white space and splitting lines
  - saving doesnt return
  - practice using tab
  - practice using console history


## R Markdown {#rstudio-rmarkdown}



### Working directory {#rstudio-wd}



<!--

<details><summary>Exercise solutions</summary>


``` r
head(mtcars)
#>                    mpg cyl disp  hp drat    wt  qsec vs am
#> Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1
#> Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1
#> Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1
#> Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0
#> Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0
#> Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0
#>                   gear carb
#> Mazda RX4            4    4
#> Mazda RX4 Wag        4    4
#> Datsun 710           4    1
#> Hornet 4 Drive       3    1
#> Hornet Sportabout    3    2
#> Valiant              3    1
```

</details> 

-->
