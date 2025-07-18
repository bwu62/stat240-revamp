


# Descriptive Statistics {#descriptive}


Descriptive statistics is what most people think of when they hear the word "statistics", i.e. a collection of numbers that summarize some data. This is often a good starting point for exploring a newly encountered dataset.

:::{.def}
A **statistic** is just some number computed from a sample of data, often intended to summarize the data in a specific way. Virtually any function that ingests a sample and outputs a number can be referred to as a statistic.
:::



## Measures of central tendency

There are MANY statistics that aim to quantify the "center" of a sample. These are all collectively referred to as **measures of central tendency**, also often called **averages** for short. The 3 most common averages are the **mean**, **median**, and **mode**.

:::{.note}
**"Average" can refer to ANY measure of central tendency**, i.e. average can refer to either mean, median, or mode (or any of these [other measures](https://en.wikipedia.org/wiki/Central_tendency#Measures)). Thus, it's generally recommended to specify which measure you're referring to and avoid using the word "average" (unless you're being strategically ambiguous).
:::


### Mean

The arithmetic mean of a sample, commonly referred to as just "mean", is what most people think of when they hear "average". It is the **sum of a sample divided by the sample size**. Formally, given a sample $x_1,x_2,\dots,x_n$ the mean $\bar{x}$ is defined as:

$$\bar{x}=\frac1n\sum_{i=1}^nx_i=\frac{x_1+x_2+\cdots+x_n}n$$

The mean may seem the most natural and intuitive central tendency measure, but it has a number of drawbacks:

 1. The mean is sensitive to "outliers" and is not recommended with heavily skewed data.
 2. The mean should generally only be used with truly numeric data, i.e. data where values are intrinsically tied to some quantitative observable.
    - A common example of data that is not "truly" numeric is ordinal data, which is commonly generated by [Likert scales](https://en.wikipedia.org/wiki/Likert_scale) (e.g. strongly disagree, disagree, neutral, agree, strongly agree), or star-based review systems (e.g. &#9733;&#9733;&#9733;&#9733;&#9734;).^[In practice, this kind of ordinal data is often treated as numeric anyway, implicitly assuming a constant interval between each step, and for most purposes this is probably fine.]

Continuing with our previous 21^st^ century US volcanic eruptions dataset, you can use `mean()` to, for example, find the mean length of eruptions in days:


``` r
# import all core tidyverse packages, since we will need several
# (again, this imports readr, tibble, and stringr, as well as several others)
library(tidyverse)
# reload dataset
eruptions_recent <- read_csv(
  "https://bwu62.github.io/stat240-revamp/data/eruptions_recent.csv",
  show_col_types = FALSE
)
```



``` r
# compute mean duration of eruptions
mean(eruptions_recent$duration)
```

```
[1] 172.0133
```

``` r
# we can check this agrees with our mathematical definition
sum(eruptions_recent$duration) / length(eruptions_recent$duration)
```

```
[1] 172.0133
```

:::{.note}
If a vector has missing values, i.e. `NA`, `mean()` and most other statistical functions will return `NA`. This is a safety measure, to help remind you to handle missing values appropriately before attempting further analysis. You can tell R to ignore `NA`s and proceed by setting `na.rm = TRUE` in the function.

``` r
# example of NAs causing mean to fail
mean(c(1, 6, NA, 2))
```

```
[1] NA
```

``` r
# setting na.rm = TRUE tells R to safely ignore NAs
mean(c(1, 6, NA, 2), na.rm = TRUE)
```

```
[1] 3
```
:::



### Median

The median, a common alternative to the mean, is defined as the **"middle" number in a sorted sample**. Formally, it's the value that is both greater than or equal to half the sample, and also less than or equal to half the sample. If there are an even number of observations, the median isn't uniquely defined but is commonly taken as the mean of the middle two numbers.

The median is generally recommended over the mean in the following situations:

 1. There are "outliers", or the data is significantly skewed.
 2. The data is not truly numeric, e.g. if you have ordinal data.

We can use `median()` to find the median length of eruptions in days:


``` r
# compute median duration of eruptions
median(eruptions_recent$duration)
```

```
[1] 62
```

``` r
# check to see if it satisfies the formal definition
# recall from the logical vectors section from Chapter 3 that
# mean() of a logical vector gives the proportion of TRUEs
c(
  mean(
    eruptions_recent$duration >= median(eruptions_recent$duration)
  ),
  mean(
    eruptions_recent$duration <= median(eruptions_recent$duration)
  )
)
```

```
[1] 0.5066667 0.5066667
```

Note the median length of eruptions, 62, is significantly smaller than the mean, 172.0133333, because the data is extremely skewed, i.e. there are a few extremely long eruptions, which pull the mean up to be much higher (since it's more sensitive to extreme values).

:::{.note}
It's worth mentioning here the word "outliers" isn't well defined formally and is actually a surprisingly tricky subject in statistics. Here, an "outlier" just loosely refers to observations that differ dramatically compared to the rest of your data. It's important to remember that **not all "outliers" are errors**; some may in fact point to new information you're not aware of.
:::

:::{.def}
Statistics that are **less sensitive to "outliers" are called *robust***. E.g. the median is more robust than the mean.
:::



### Mode

The mode is the oft-maligned black sheep of the central tendency family. It is defined as **the most common observation**, i.e. the observation that occurs the most number of times in a sample. It's primarily intended for categorical data (e.g. male vs female) though it also has some relevance to distributions (more on this much later).

The mode is of course also a form of "average". For example, statistics show roughly [95% of lumberjacks in the US are male](https://www.zippia.com/lumberjack-jobs/demographics). It would therefore be accurate to say "the average American lumberjack is male". In fact, for categorical data---which is ubiquitous---this is the only possible measure of central tendency.

Unfortunately, base R does not have a convenient function for computing the mode (the function `mode()` is [completely unrelated](https://ds-pl-r-book.netlify.app/modes-types-classes-of-objects.html)), but you can easily either define it yourself or import `Mode()` from the `DescTools` package


``` r
# this defines a simple Mode function using mostly commands we already know
# explanation: table tabulates observations, then
#              sort(- ...) sorts by descending order, then
#              names(...)[1] extracts the name of the first item
# note this function doesn't return multiple modes if there are more than 1
Mode <- \(x) names(sort(-table(x)))[1]
```


``` r
# find the volcano with the most number of eruptions
Mode(eruptions_recent$volcano)
```

```
[1] "Cleveland"
```

``` r
# how many eruptions has Cleveland had since 2001?
sum(eruptions_recent$volcano == "Cleveland")
```

```
[1] 13
```


``` r
# the DescTools package also has a Mode function,
# which correctly handles ties and also gives the frequency
# make sure to install it before using: install.packages("DescTools")
DescTools::Mode(eruptions_recent$volcano)
```

```
[1] "Cleveland"
attr(,"freq")
[1] 13
```


### Aside: Modality {#modality}

Most common distributions have only 1 mode, i.e. they are unimodal, but some distributions may have 2 or more modes, in which case they're called bimodal (for 2 modes) or multimodal (for ≥2 modes). Here's an example of a bimodal distribution:

<img src="05-descriptive-statistics_files/figure-html/modality-1.svg" width="672" style="display: block; margin: auto;" />


### Aside 2: Visualizing mean/median/mode

Here's a good diagram showing visual interpretations of the mean, median, and mode on a skewed unimodal distribution.^[Courtesy of [Wikimedia Commons](https://upload.wikimedia.org/wikipedia/commons/3/33/Visualisation_mode_median_mean.svg).]

 - Mode: point where the "peak" of the distribution is.
 - Median: point which splits the distribution into two equal areas.
 - Mean: the point where the distribution would balance on, if cut out.

![](mode-median-mean-visual.svg){.i3}


### Other measures

The mean, median, and mode are by far the most common measures of central tendency, and they are the only ones you need to know for this course. However, I thought it might be worth briefly mentioning a few other averages with interesting applications just for fun:

 - The [quadratic mean](https://en.wikipedia.org/wiki/Root_mean_square), also known as the root mean square, is defined for a sample $x_1,\dots,x_n$ as $\sqrt{\frac1n(x_1^2+\cdots+x_n^2)}$. This shows up in some statistical contexts, e.g. the standard deviation is almost a quadratic mean of the difference of each observation from the arithmetic mean, except dividing by $n-1$ instead of $n$ (which corrects a small bias and is called [Bessel's correction](https://en.wikipedia.org/wiki/Bessel%27s_correction)). It also has applications in model evaluation, statistical physics, electronics engineering, signal analysis, and more.
 - The [geometric mean](https://en.wikipedia.org/wiki/Geometric_mean) is defined as $\sqrt[n]{x_1x_2\cdots x_n}$ and is only valid for positive-valued data. This is useful when data is multiplicative rather than additive in nature, e.g. growth rates, interest rates, comparisons of relative performance on benchmarks, etc. It has many applications in finance and economics, some areas of optical engineering, and even cinematography.
   - Note the logarithm of the geometric mean of a sample is equal to the arithmetic mean of the logarithm of the same sample. In other words, a geometric mean viewed on a log scale "looks like" an arithmetic mean on a linear scale. Log transforms are an important tool for certain contexts, see [this page](https://people.duke.edu/~rnau/411log.htm) for a brief overview.
 - The [harmonic mean](https://en.wikipedia.org/wiki/Harmonic_mean) is defined as $\left(\frac{x_1^{-1}+\,\cdots\,+x_n^{-1}}{n}\right)^{\!-1}$, i.e. the reciprocal of the arithmetic mean of the reciprocals of the data, and is also typically only used for positive-valued data. It turns out to be the correct mean to use in certain applications involving rate, ratio, or time values. It also has applications in machine learning, physics, finance, and even [baseball](https://en.wikipedia.org/wiki/Power%E2%80%93speed_number).
 - Collectively, the arithmetic, geometric, and harmonic means are also known as the [Pythagorean means](https://en.wikipedia.org/wiki/Pythagorean_means).

This is just a short list; there are a host of [other means](https://en.wikipedia.org/wiki/Central_tendency#Measures) that exist. Once again, **you do NOT need to know any of these advanced means**; you are only expected to know the arithmetic mean, median, and mode.



## Measures of spread

Arguably the next most important set of summary statistics after measures of central tendency are **measures of spread**, which aim to quantify how "spread out" a dataset is. **Variance** and **standard deviation** are by far the most common measures, but the **IQR** and **range** are also sometimes useful.

Unlike measures of central tendency, measures of spread are typically location-agnostic, i.e. they don't change if the entire dataset is shifted up or down by a constant. Formally, a sample $x_1,\dots,x_n$ and a sample $x_1+c,\,\dots,\,x_n+c$ have the same spread for all $c$.



### Variance (and standard deviation)

Let's get the easy one out of the way first. **Standard deviation is always defined as the (positive) square root of variance**. So what's the variance then? The **variance of a sample is defined as**:

$$s^2=\frac1{n-1}\sum_{i=1}^n(x_i-\bar{x})^2=\frac{(x_1-\bar{x})^2+\cdots+(x_n-\bar{x})^2}{n-1}$$

Basically, it's the **mean squared-distance from the mean**, $\bar{x}$, except we use $n-1$ instead of $n$ to correct for a [small bias](https://en.wikipedia.org/wiki/Bessel%27s_correction). For example, we can compute the variance of the duration of eruptions, in **days squared**:


``` r
# compute variance of duration
var(eruptions_recent$duration)
```

```
[1] 86978.66
```

In other words, the "average" squared difference of an eruption's duration and the mean duration is about 87k days^2^.

Note the units of the variance are squared of the data units. This makes it inconvenient to work with, since it means it cannot be directly compared with the data. This is why instead we often work with **its square root, i.e. the standard deviation**:

$$s=\sqrt{\frac1{n-1}\sum_{i=1}^n(x_i-\bar{x})^2}$$

which can be thought of as the **"average" distance from the mean** for a given observation. This can be computed using `sd()`:


``` r
# compute the standard deviation of duration
sd(eruptions_recent$duration)
```

```
[1] 294.9215
```

``` r
# you can check this is equal to sqrt(var(...))
sqrt(var(eruptions_recent$duration))
```

```
[1] 294.9215
```

In other words, the "average" distance in days between the duration of eruptions and the mean is about 294.9 days.

:::{.note}
Since the standard deviation is defined as the square root of the variance (and thus the variance is always the square of the standard deviation), knowing one of these quantities enables you to also easily compute the other.
:::

The variance and standard deviation are the most common measures of spread, but like the arithmetic mean, they are also sensitive to outliers and may not be suitable with highly skewed data.


### Interquartile range {#iqr}

The interquartile range, also called the IQR, is the **distance between the 1^st^ and 3^rd^ quartile**. To understand this, let's first briefly review percentiles.


### Percentiles

Percentiles are a generalization of the median. Recall the median is the data point that is just barely greater than or equal to 50% of the data. Similarly, a **$p$^th^ percentile is the data point just barely greater than or equal to $p$% of the data**. Percentiles are computed using the [`quantile(x, probs = p)`{.R}](https://rdrr.io/r/stats/quantile.html) function, where `x` is the data vector, and `p` is a desired percentile (or vector thereof). For example, we can compute the 0^th^, 25^th^, 50^th^, 75^th^, and 100^th^ percentiles of eruption duration with:


``` r
quantile(eruptions_recent$duration, probs = c(0, 0.25, 0.5, 0.75, 1))
```

```
    0%    25%    50%    75%   100% 
   0.0    5.5   62.0  184.0 1491.0 
```

These 5 numbers correspond to the **min**, **1^st^ quartile ($Q_1$)**, **median**, **3^rd^ quartile ($Q_3$)**, and max respectively, which are often collectively known as the [five-number summary](https://en.wikipedia.org/wiki/Five-number_summary). $Q_1$ and $Q_3$ are also frequently called the upper and lower **hinges** of a dataset.

The **difference $Q_3-Q_1$ is called the interquartile range**, and is often used instead of the variance/standard deviation when outliers/skewness is a significant concern in a dataset due to its increased robustness. The IQR can be computed with the `IQR()` function:


``` r
# compute the interquartile range of eruption durations
IQR(eruptions_recent$duration)
```

```
[1] 178.5
```



### Range

The range is the crudest of the measures of spread, defined as the **difference between the minimum and maximum** of a sample. It is even more sensitive to outliers than the variance/standard deviation, and thus less commonly used in formal statistical settings. It is sometimes the only practical measures for extremely small datasets.

In R, the `range()` function gives the minimum and maximum in a vector; to get the actual range, you can use `diff()` to take the difference of the two:


``` r
# range() gives the min/max vector
range(eruptions_recent$duration)
```

```
[1]    0 1491
```

``` r
# diff() of range() gives the true statistical range
diff(range(eruptions_recent$duration))
```

```
[1] 1491
```



### Other measures

The variance, standard deviation, IQR, and range are the only measures of spread you need to know for this course, but here are a few other measures just for fun:

 - The [median absolute deviation](https://en.wikipedia.org/wiki/Median_absolute_deviation) or MAD is exactly what it sounds like, the median of the absolute value deviation from the median. It's a more robust (i.e. outlier-resistant) version of the standard deviation.
 - The [Gini coefficient](https://en.wikipedia.org/wiki/Gini_coefficient) is another interesting measure of spread (one of my favorites). It's the only one on this list that is dimensionless (i.e. always a "pure" number with no units) and always between 0 and 1 for non-negative data. It's defined as half the [relative mean absolute difference](https://en.wikipedia.org/wiki/Mean_absolute_difference#Relative_mean_absolute_difference), which is itself defined as the average absolute difference $|x_i-x_j|$ between all pairs of observations divided by the arithmetic mean. It's commonly used in economics to characterize inequality, with 0 being total equality (e.g. everyone has exactly the same amount of wealth) and 1 being total inequality (e.g. one person having all the wealth and everyone else having none).

Once again, this is just a subset of the possible [measures of spread](https://en.wikipedia.org/wiki/Statistical_dispersion), and **you do NOT need to know these other measures**; you are only expected to know the variance, standard deviation, IQR, and range.



## Skew

Another important summary statistic is the skew of a dataset. Skew has a precise mathematical definition that is beyond the scope of this course. All you need to know is the **difference between a positive (also called right) skew and a negative (also called left) skew** in a dataset.

The side of the skewness is always the **side with the longer tail**. If the longer tail is on the positive (or right) side, it's called positive (or right) skew. If the longer tail is on the negative (or left) side, it's called negative (or left) skew.

Below, we have 3 example (unimodal) distributions showing the kinds of skewness, with the [**modes**]{style="color:#ff1919"} of each aligned.

 1. An unskewed, or symmetric distribution, where [**mode**]{style="color:#ff1919"} $=$ [**median**]{style="color:#3333ff"} $=$ [**mean**]{style="color:#009900"}.
 2. A positive, or right skewed distribution, where [**mode**]{style="color:#ff1919"} $<$ [**median**]{style="color:#3333ff"} $<$ [**mean**]{style="color:#009900"}.
 3. A negative, or left skewed distribution, where [**mean**]{style="color:#009900"} $<$ [**median**]{style="color:#3333ff"} $<$ [**mode**]{style="color:#ff1919"}.

<img src="05-descriptive-statistics_files/figure-html/skew-diagram-1.svg" width="672" style="display: block; margin: auto;" />

This shows again, as we already learned, that the median is more robust vs the mean to "outliers"/skew, or in other words, the mean is more affected by "outliers"/skew and gets "dragged away" further by the skewness. 

:::{.note}
Visually, the mode is always the "peak", the median splits the distribution into 2 equal areas, and the mean is the center of mass of the shape along the horizontal axis (i.e. its "balancing point").
:::
