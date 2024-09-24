--- 
title: "STAT 240 Revamp"
author: "Bi Cheng Wu, with help from Bret Larget and Cameron Jones"
date: "2024-09-24"
site: bookdown::bookdown_site
documentclass: book
bibliography: [book.bib, packages.bib]
url: https://bwu62.github.io/stat240-revamp
# cover-image: path to the social sharing image like images/cover.jpg
description: Revamped STAT240 notes
biblio-style: apalike
csl: chicago-fullnote-bibliography.csl
mathjax-config: TeX-AMS-MML_HTMLorMML
---


# Welcome! {-}

This is the in-progress working draft of a revamp of the STAT 240 course notes. Significant changes have been made to the order of topics, degree of coverage, and examples employed. Currently, this is intended to supplement rather than replace the existing body of STAT 240 notes.


## Prerequisites/scope {-}

For these notes, no prior R or computer science knowledge is assumed; everything is taught from scratch.

As you consult these notes, please keep in mind the aim is **NOT to teach you everything you need to know about each topic, but rather equip you with a foundational understanding and encourage you to learn and explore further** on your own. As such, we will typically only cover the basic usage of most operations and demonstrate a few key examples, leaving the details for you to practice.

Also note occasionally some bonus/extra/aside content considered advanced knowledge may be mentioned in passing for sake of completeness in discussing a topic, but these are considered **outside the scope of what you need to know**.


## How to use this book {-}

Here's a few tips on how to get the most out of this book.


### Organization {-}

These notes are loosely organized into the following order of topics:

 A.  Setup,
 B.  R crash course, to rapidly bring you up to speed on basic R usage,
 C.  Data exploration, to introduce you to data exploration in R,
 D.  Data transformation, to demonstrate common data cleaning techniques,
 E.  Probability theory (in progress), to introduce basic probability theory,
 F.  Inference (to be added soon), to teach foundational inference techniques, specifically:
     i.   Inference on means,
     ii.  Inference on proportions,
     iii. Inference in regression.

There are also some appendices with additional info:

 A.  Datasets: info on the sources and preprocessing done for data set examples,
 B.  Cheat sheets: list of cheat sheets for various packages/programs used in the notes.


### Notes layout {-}

First, note the table of contents on the left and chapter navigation bar on the right of each page. Use these to quickly navigate around the notes. Also note the search bar in the top corner; use this to search and highlight keywords across the entire site. On smaller phone screens these elements may collapse, but they should be fully visible on wider laptop/tablet screens.

The notes pages are mostly composed of paragraph of text (like this one), and code chunks (see below). You will also occasionally encounter additional reference links, embedded images, footnotes with extra info, tables, and other elements.

The block below is a code chunk. They are frequently annotated with comments. Note you can copy the contents of a chunk using the clipboard icon in the corner. Also note functions automatically link to their help pages with usage notes, argument explanations, and examples.


``` r
# this is a code chunk; lines starting with # are comments
# R code in here will be run and output shown below
print("Hello world!")
```

```
[1] "Hello world!"
```

:::{.note}
Important notes, often warning you against common mistakes/errors, will appear in yellow alert boxes.
:::

:::{.tip}
Tips on improving your R understanding or optimizing your workflow will sppear in green alert boxes.
:::


### Source code {-}

These notes are [open-sourced on GitHub](https://github.com/bwu62/stat240-revamp) and built using [bookdown](https://github.com/rstudio/bookdown) and served by [GitHub pages](https://pages.github.com), which provides a convenient, easily editable, and reproducible workflow. Each page has a link to "View source" of the page in the right-side navbar, if you want to see what's under the hood.

Note the code base is primarily written in [R Markdown](https://rmarkdown.rstudio.com/lesson-1.html) syntax, which may include ordinary text, [markdown](https://www.markdownguide.org/basic-syntax) code, [YAML](https://yaml.org) headers, R chunks, [knitr](https://yihui.org/knitr/options) tweaks, [$\LaTeX$](https://www.overleaf.com/learn/latex/Mathematical_expressions) formulae, and pandoc elements (especially [fenced divs](https://pandoc.org/MANUAL.html#divs-and-spans) and [braced attributes](https://pandoc.org/MANUAL.html#extension-bracketed_spans)). In some auxiliary files, you may even find HTML/CSS/jQuery snippets. These are obviously not made for you to read/understand, so browse at your own curiosity.


### Contributing {-}

We work hard to avoid errors, but alas nothing is perfect! If you notice any errors, **please consider contributing a suggestion!** You can do this in 2 ways. (Note: both ways require a [GitHub](https://github.com) account, so make sure to [sign in](https://github.com/login) or [register](https://github.com/signup?source=login) first!^[Use your wisc.edu email for some nice [student perks](https://github.com/edu/students) like free Pro status.])

 1. Directly propose a change in a GitHub [pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests):
    i.   On the page with the error, click the "Edit this page" in the right-side navbar.
    ii.  If this is your first time contributing to this project, you will be asked to "Fork this repository", i.e. make a copy.
    iii. After forking, make your edits in the text editor window that appears and click "Commit changes...". **Make sure to add a brief, descriptive title**, as well as any additional necessary details in the description box. Note the description box supports [markdown syntax](https://www.markdownguide.org/basic-syntax).
    iv.  Next, click "Propose changes", then click "Create pull request". Again, make sure you have a good title and description, then click "Create pull request" again. **Make sure to leave "Allow edits by maintainers" checked**, so I can modify your edit if I want!
    v.   You can check the status of your pull request (PR) in the [PR tab](https://github.com/bwu62/stat240-revamp/pulls) of the repo.
         - If the PR looks perfect, I may immediately merge it.
         - If the PR is good but not perfect, I may make further comments/edits before eventually merging.
         - If the PR isn't up to par for some reason, I may discuss it more, ask follow up questions, or simply close it. If I close your PR, don't be discouraged! You're welcome to make further contributions, just make sure you understand why I didn't merge it and try to make a better PR next time!
 
 2. If that seems like too much work, you can also simply [raise an issue](https://github.com/bwu62/stat240-revamp/issues/new/choose) and point me to the error. Note since this is more work for me, it will usually have lower priority than a well-written PR, which can be easily merged with a single click.


### Acknowledgements {-}



This is a good time to acknowledge people that have made contributions. Bret Larget is the original creator of STAT 240 and author of the first set of STAT 240 notes, which is a primary source of inspiration for many aspects of these notes. Cameron Jones has also agreed to help write some practice materials as these notes evolve. Beyond that, thanks also to [\@jennamotto1](https://github.com/jennamotto1) for also contributing to the repo (make a successful PR to get your name on this list!).


## Future ideas {-}

Below is a list of additional ideas for future improvements to these notes, to be considered for implementation at an unspecified future time (not to be prioritized over finishing the first-pass writeup).

 - dark mode?
 - add exercises to each page
 - automagic index generator using _common.R?
 - glossary?
 - DT datatable fancy printouts??


<!--

dataset ideas (note: should prioritize datasets most students would find interesting)

 - olympics
 - politics
 - crime
 - causes of death
 - climate
 - something economic
 - SSA names

other notes to self:

 - use [params](https://bookdown.org/yihui/rmarkdown/params-declare.html) to control:
   - course directory
   - hw/ds solution generation in files (in separate private repo?)
 - basic data literacy concepts?
   - percent of, percent change, X change
   - percent vs points (and point difference)
   - bad plots
   - biases (survivorship, selection (e.g. sampling, berkson), generalization (e.g. WEIRD))
   - fallacies (prosecutor, gambler, correlation, dredging, regression to mean)
 - build db of past 240 stats
 - rethink discord management
 - sample of graded, commentated papers (example of an A, AB, B, BC, C, D, F)
 - grade by comparing with reference papers
 - conditional stratified sample of papers based on distribution of grades in group
 - after paring down samples, ask Derek & Cameron to help with grading evaluation for calibrating papers
 - pare down more, use focused sample to calibrate TAs/instructors if needed?

-->


