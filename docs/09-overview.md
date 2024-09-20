

# Overview

I want to start the modeling section with the following overview of what role modeling plays in the "life cycle" of a data science project.

:::{.i96}
<img src="09-overview_files/figure-html/unnamed-chunk-1-1.svg" width="768" style="display: block; margin: auto;" />
:::

Roughly speaking, data science can be divided into 3 phases:

 I.   In Phase I, you identify a research question, design an experiment, gather a sample, and collect some raw data. These steps correspond to the first row of the "life cycle".
 II.  In Phase II, you start with your raw data and clean it (this is probably where 60-90% of time is actually spent), explore it, and figure out the best way to model it. This is the second row.
 III. In Phase III, you fine tune your model, double check all your work, and interpret the results, which may involve reporting estimates, computing tests/intervals, making predictions, etc. This is the third row.

Usually, this is an iterative process; you start with a question, gather data, analyze it, then either modify the initial inquiry or ask a follow up question, and the cycle continues.

Experiment design & sampling is a more advanced topic, and thus not covered in detail in STAT 240, however we will summarize a few key ideas from Phase I in the next subsection since they are relevant to later topics.

We've spent a lot of time learning the basics of data cleaning, exploration, and visualization, so we're reasonably well covered for Phase II for now, though of course you're always encouraged to explore further on your own.

For most of the remainder of the class, we will focus on Phase III: identifying appropriate models, fitting them well, interpreting the results meaningfully, producing useful further inference such as hypothesis tests & confidence intervals, and communicating the results effectively to a broader audience.

First, we need to briefly summarize a few key concepts relating to experiment design that will greatly enrich our later exploration of models.



## Population vs sample

Statistics is primarily the science of studying **samples** to understand **populations**. Generally, it's impractical to observe every member of a population, but luckily this is usually not necessary and a well-drawn sample is sufficient to answer most questions.

:::{.def}
A **population** can be any large group we want to learn about, e.g. all US mothers (~85 million), all arctic terns (~3 million), all gen-5 Toyota Priuses (~15000), etc..

A **sample** is a smaller set drawn from (and intended to represent) a population.
:::

There are [MANY ways](https://www.scribbr.com/methodology/sampling-methods) to draw a sample, each with their own pros, cons, and potential [biases](https://www.scribbr.com/research-bias/sampling-bias). A detailed discussion of these is reserved for more advanced courses.



## Model vs data

Using only mathematical logic, we can derive different theoretical probability **models** with certain **parameters** that aim to represent real world phenomena, then compare these with real data, i.e. **fitting**, to evaluate their performance and make further **inferences** and/or **predictions**.

:::{.def}
A **model** is an idealized mathematical representation of a process, e.g. a normal distribution may be used to model the distribution of human heights.

Models often have **parameters** which are values that can be adjusted (or "tuned") to **fit** a model so that it matches real data.
:::


