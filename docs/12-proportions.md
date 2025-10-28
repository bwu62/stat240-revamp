

# Proportions

Let's look specifically at proportions-type inference setups, where we apply a **binomial model** to sample proportions to infer about an underlying **probability** in the population. We will divide this into two scenarios:

 - One-proportion scenario, where there is a single population with a single probability parameter of interest, and
 - Two-proportions scenario, where there are two populations, each with its own probability parameter, which we seek to compare.


:::{.note}
A proportions-type inference approach using a binomial model is **only appropriate** if your sample consists of either 1 or 2 samples where, for each sample, your data looks like **counts across two categories**, one of which we consider "success" and the other "failure" (e.g. heads/tails, true/false, etc.).

In these setups, the probability parameter of the binomial model **always corresponds to the probability of the _success_ category** by convention. Make sure to define the category whose probability is of primary interest as "success".
:::


## One proportion

### Model notation

In the one-proportion scenario, suppose we draw a **fixed sample size of $n$** observations, each of which we model as **independent** and having some constant underlying **true probability $p$ of being a success**, and $1-p$ of being a failure (and there's no other possible outcome).

Let lower-case **$x$ be the observed number of successes in our sample**, and note that we must have $0\le x\le n$. Let $\hat p=x/n$ denote then the **proportion of successes in our sample**.

It's customary to also use upper-case $X$ to represent our model of the true distribution of $x$, which here we choose to be $X\sim\bin(n,p)$.

Under these assumptions, $\hat p$ is a natural **point estimate** for $p$, i.e. our **sample proportion of successes estimates the true underlying probability of success $p$**, since the LLN guarantees $\hat p\to p$ as $n\to\infty$.

:::{.note}
Note several things:

 - $n$ must be a fixed, predetermined sample size,
 - trials must be able to be reasonably modeled as independent,
 - there must only be 2 possible outcomes (success & failure) for each trial,
 - $p$ is always the probability of the "success" category, however it's defined,
 - $x$ usually represents the actual "observed" number of successes in your sample out of $n$ trials,
 - $X$ usually represents the theoretical random variable model we choose to apply to the sample's observed $x$.
:::

:::{.eg}




Let's see all this in the context of an example. The following are $n=200$ rolls of a purportedly fair 5-sided die I bought online (yes, I really sat in my office and rolled this die 200 times).

![](d5.jpg){.i3}


``` r
# combine 50-roll chunks of data, split, then parse to numeric vector
rolls <- paste0("21252134521555355115322514314333142113433335345333",
                "43242443535423223523352541521331244241531554241354",
                "34244524112155254341541335443433245314125431131335",
                "43114331251421521112234535251142334354341123345541") %>%
  strsplit("") %>% unlist %>% as.numeric
rolls
```

```
  [1] 2 1 2 5 2 1 3 4 5 2 1 5 5 5 3 5 5 1 1 5 3 2 2 5 1 4 3 1 4 3 3 3 1 4 2 1 1
 [38] 3 4 3 3 3 3 5 3 4 5 3 3 3 4 3 2 4 2 4 4 3 5 3 5 4 2 3 2 2 3 5 2 3 3 5 2 5
 [75] 4 1 5 2 1 3 3 1 2 4 4 2 4 1 5 3 1 5 5 4 2 4 1 3 5 4 3 4 2 4 4 5 2 4 1 1 2
[112] 1 5 5 2 5 4 3 4 1 5 4 1 3 3 5 4 4 3 4 3 3 2 4 5 3 1 4 1 2 5 4 3 1 1 3 1 3
[149] 3 5 4 3 1 1 4 3 3 1 2 5 1 4 2 1 5 2 1 1 1 2 2 3 4 5 3 5 2 5 1 1 4 2 3 3 4
[186] 3 5 4 3 4 1 1 2 3 3 4 5 5 4 1
```

``` r
# quick table + plot of results using base R
table(rolls)
```

```
rolls
 1  2  3  4  5 
39 32 50 41 38 
```

``` r
barplot(table(rolls))
```

:::{.i6}
<img src="12-proportions_files/figure-html/unnamed-chunk-4-1.svg" width="672" style="display: block; margin: auto;" />
:::

Suppose my question of interest is whether or not this specific die design does in fact give fair results. There are different ways of testing this^[the most [powerful](https://www.scribbr.com/statistics/statistical-power) method is probably a [chi-squared test](https://www.scribbr.com/statistics/chi-square-tests).], but a simple way using a proportions-type setup is to ask **whether the two triangular-shaped faces** (which are 4 and 5) **are observed 2/5 or 40% of the time**.

In this setup, we can define "success" as getting 4 or 5, which has theoretical probability $p=0.4$. Our RV model for $X$ where $X$ is the number of successes (4s & 5s) is then $X\sim\bin(n=200,p=0.4)$. In our sample, we observed $x=41+38=79$ times this occured, which gives us a sample proportion of $\hat p=x/n=79/200=0.395$.
:::

