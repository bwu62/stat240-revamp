

# Sampling & Inference

In the previous chapter, we introduced the basics of probability theory and discussed some basic random variable models. These form the basis of our inference techniques in the rest of the notes.

In this chapter we'll discuss the concept of **inference**, where you use your observations in a sample to try to infer underlying facts about the broader population. In the process, we will make extensive use of our probability concepts and random variable models from the previous chapter.


## Population vs sample

Recall the idea of population vs sample. Usually we imagine that the **population has some fixed distribution with unknown but constant parameters**. We draw some sample from the population and **observe some sample statistics**. Based on our sample as well as possibly some other **reasonable assumptions we can make**, we identify a potential model that can be applied to the population.

Once we have our sample and our intended model, there are two common methods of inference that we can pursue; they are conceptually related, but have subtle differences:

 - We can run a **hypothesis test**, where we test models against the data to determine which explains the results better.
 - Or we can find **confidence intervals** for the underlying parameters of interest in the model, producing a range in which we are quite certain the true value lies.

These methods are not mutually exclusive and you can certainly do both, but most problems only call for one method. We will discuss both shortly, but first let's briefly discuss sampling distributions.


## Sampling distributions

Why is inference even necessary in the first place? The main reason is this: **samples are random**! This may sound trivially obvious, but the implications are worth examining more closely.


### Example: Coin flips

Imagine we have a **perfectly fair coin**, i.e. Heads (H) and Tails (T) have the exact same probability (and you can't land on the edge). Also assume you have good throwing technique and flip the coin a good many times in the air, so that past throws don't affect subsequent throws, i.e. the **throws are all mutually independent**. This is of course an idealized model, but it usually turns out to be quite practical.

### \# Heads v. $n$

Suppose you flip the coin 10 times and define $X$ as the number of total heads. Note that we can model $X\sim\bin(10,0.5)$. What is the probably of getting exactly 5? Or how about some other number? In fact we've already seen this exact distribution function last chapter:

:::{.fold .s}


``` r
# remember to import tidyverse (and optionally, update theme options)
# also importing latex2exp to write math in plot annotations
library(latex2exp)
tibble(k = 0:10, p = dbinom(k, 10, 0.5)) %>% 
ggplot(aes(x = k, y = p)) + geom_col() +
  scale_x_continuous(breaks = seq(0, 10, 1), expand = 0) +
  scale_y_continuous(breaks = seq(0, 0.25, 0.05), limits = c(0, 0.25),
                     minor_breaks = seq(0, 0.25, 0.01), expand = 0) +
  labs(title = TeX("Binomial(10, 0.5) PMF    [ $\\mu=(10)(0.5)=5$,  $\\sigma
                   =\\sqrt{(10)(0.5)(1-0.5)}\\approx 1.58$ ]"),
       x = "k", y = "probability")
```

<img src="11-inference_files/figure-html/unnamed-chunk-1-1.svg" width="672" style="display: block; margin: auto;" />
:::

You can see that even though 5 is more likely than any other outcome, there's actually over 75% chance that you'd observe something else entirely.

Now suppose you keep going until you get to 100 flips, and again consider the total number of heads $X\sim\bin(100,0.5)$. Here's the distribution:

:::{.fold .s}

``` r
tibble(k = 0:100, p = dbinom(k, 100, 0.5)) %>% 
ggplot(aes(x = k, y = p)) + geom_col(color = "white") +
  scale_x_continuous(breaks = seq(0, 100, 10), expand = 0) +
  scale_y_continuous(breaks = seq(0, 0.08, 0.01), limits = c(0, 0.08), expand = 0) +
  labs(title = TeX("Binomial(100, 0.5) PMF    [ $\\mu=(100)(0.5)=50$,  $
                   \\sigma=\\sqrt{(100)(0.5)(1-0.5)}=5$ ]"),
       x = "k", y = "probability")
```

<img src="11-inference_files/figure-html/unnamed-chunk-2-1.svg" width="672" style="display: block; margin: auto;" />
:::

One thing is immediately apparent: even though the raw SD has increased from 1.58 to 5, the **range of likely outcomes has narrowed compared to $\Omega$**, i.e. compared to $n$, you're unlikely to deviate by as much when the total number of flips is higher. If we continue on to 1000 flips, this becomes even more evident:

:::{.fold .s}

``` r
tibble(k = 0:1000, p = dbinom(k, 1000, 0.5)) %>% 
    ggplot(aes(x = k, y = p)) + geom_area(color="gray35", fill="gray35") +
    scale_x_continuous(breaks = seq(0, 1000, 100), expand = 0) +
    scale_y_continuous(breaks = seq(0, 0.025, 0.005), expand = 0,
                       minor_breaks = seq(0, 0.025, 0.001)) +
  labs(title = TeX("Binomial(1000, 0.5) PMF    [ $\\mu=(1000)(0.5)=500$,  $
                   \\sigma=\\sqrt{(1000)(0.5)(1-0.5)}\\approx 15.8$ ]"),
       x = "k", y = "probability") + theme(plot.title = element_text(size=12),
                                           plot.margin = margin(6,10,6,6))
```

<img src="11-inference_files/figure-html/unnamed-chunk-3-1.svg" width="672" style="display: block; margin: auto;" />
:::


### \% Heads v. $n$

We've just seen that as $n$ increases, the range of values for $X$ (number of heads) we are likely to observe **narrows with respect to the total range** of 0 to $n$.

Let's see this fact in a different way. Let's **actually simulate a sequence of 1000 flips** according to this model, then make a plot showing the **proportion of heads as we go along** after each flip.

:::{.fold .s}

``` r
# use rbinom to explicitly generate 1000 individual flips
# enframe wraps the vector in a data frame for ggplot
# cumsum computes the cumulative sum, i.e. "how many heads so far"
samp <- rbinom(1000, 1, 0.5)
samp %>% enframe("n", "x") %>% ggplot(aes(x = n, y = cumsum(x)/n)) +
  geom_hline(yintercept = 0.5, color = "blue", linetype = "dashed") +
  geom_line() + labs(title = "Running proportion of heads vs n", y = "proportion",
                     subtitle = TeX("(blue dashed line shows theoretical $p=0.5$)"))
```

<img src="11-inference_files/figure-html/unnamed-chunk-4-1.svg" width="672" style="display: block; margin: auto;" />
:::

Let's increase the sample size to $n=10^{5}$ and show $n$ on a logarithmic scale, which improves readability (generally whenever a column is *always positive* and *covers several orders of magnitude*, this can significantly help improve readability).

:::{.fold .s}

``` r
# extend experiment out to 1e5 flips
# log.indices used to slice out indices evenly spaced on a log scale,
# which significantly improves performance at no cost to visual fidelity
# scales::comma suppresses scientific notation
samp <- c(samp, rbinom(1e5-length(samp), 1, 0.5))
log.indices <- unique(round(10^seq(0,5,length.out=1e3)))
samp %>% enframe("n", "x") %>% mutate(p = cumsum(x)/n) %>% slice(log.indices) %>%
  ggplot(aes(x = n, y = p)) +
  geom_hline(yintercept = 0.5, color = "blue", linetype = "dashed") +
  geom_line() + scale_x_log10(breaks = 10^(0:5), labels = scales::comma) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
  labs(title = "Running proportion of heads vs n", y = "proportion",
       subtitle = TeX("(blue dashed line shows theoretical $p=0.5$)"))
```

<img src="11-inference_files/figure-html/unnamed-chunk-5-1.svg" width="672" style="display: block; margin: auto;" />
:::

Let's make a final addition to our plot and add 2 additional runs where the entire experiment is repeated, as well as 2 pairs of dashed gray curves showing the ±1 and ±2 SD for each $n$.

:::{.i96 .fold .s}

``` r
p <- tibble(n = 1:1e5, run1 = cumsum(samp)/n,
            run2 = cumsum(rbinom(1e5, 1, 0.5))/n,
            run3 = cumsum(rbinom(1e5, 1, 0.5))/n) %>%
  slice(log.indices) %>%
  pivot_longer(contains("run"), names_to = "Run", values_to = "x") %>%
  ggplot(aes(x = n, y = x, color = Run))
for(i in -2:2) p <- p + geom_function(fun = \(x, i) 0.5*(1+i/sqrt(x)),
                                      args = list(i = i), color = "black",
                                      linetype = "dashed", alpha = 0.5)
p <- p + geom_line(linewidth = 0.7) +
  scale_x_log10(breaks = 10^(0:5), labels = scales::comma, expand = 0) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 10), limits = c(0, 1), expand = .01) +
  labs(title = "Running proportion of heads vs n  (3 runs)", y = "proportion",
       subtitle = TeX("(dashed lines show theoretical $p=0.5$ and ±1, ±2 SD curves)"))
p
```

<img src="11-inference_files/figure-html/unnamed-chunk-6-1.svg" width="672" style="display: block; margin: auto;" />
:::

Now we see a remarkable phenomenon: not only do the runs all converge to the true value of $p=0.5$, but their rates of convergence all fall reasonably within an "envelope" that's proportional to the SD-vs-n curves.


### Law of large numbers (LLN)

The previous plots show a simulated demonstration of what's called the [**law of large numbers**](https://en.wikipedia.org/wiki/Law_of_large_numbers) (LLN), which essentially states that certain statistics are guaranteed to converge to their true values as you increase your sample size.

Specifically, the LLN guarantees for a sample of independently drawn observations, **as $n\to\infty$, any statistic computed as an _average_ of some expression _will_ converge to the true theoretical average value as long as it exists** (i.e. has a well-defined, finite value). This is an oversimplification of course, but it serves our purposes. Note however there's no statement of the rate of convergence, i.e. how fast it converges, merely that it's inevitable.

Examples of some statistics that will converge under the LLN:

$$
\begin{align}
\text{(sample mean)}&&\bar{x}=\frac1n\sum_{i=1}^nx_i~~&\longrightarrow~\mu=\e(X)&&\text{(expected value)}\\
\text{(sample variance)}&&s^2=\frac{\sum_{i=1}^n(x_i-\bar{x})^2}{n-1}~~&\longrightarrow~\sigma^2=\e\big((X-\mu)^2\big)&&\text{(variance)}
\end{align}
$$

where $x_i$ are a sample of [**independent and identically distributed** (iid)](https://en.wikipedia.org/wiki/Independent_and_identically_distributed_random_variables) observations drawn from a population represented by the random variable $X$.

There are many other statistics that also converge (e.g. correlation, skew, etc...) but these two are the most important to us right now. Note the **sample variance also converges to the true variance**, since it can be thought of as the **average squared distance** from the mean if you factor out a $\frac{n}{n-1}$ correction factor term (as long the $\sigma^2$ exists).

Also note the proportion of heads we saw in the last example can be thought of as the **average of a sample of 1s and 0s** where 1 denotes H and 0 denotes T, so it also **converges to the true probability of heads** by LLN.

The LLN forms the basis of the inference topics which we are about to embark on.


## Confidence intervals (CI)

If you look again at the last plot from the coin flips example but in a different way, since each run stays within a fairly predictable margin of the true probability, for any given sample size we can use our sample proportion to find a range of reasonable values for the true probability. This is what we call a **confidence interval**.

A confidence interval usually has the following form:

$$
\text{$C\%$ confidence interval}~=~(\text{estimate})~\pm~(\text{crit. value})\cdot(\text{std. error})
$$

 - **$C$** is the **level of confidence** desired. Most commonly, a 95%-level confidence is reported by convention, but this can be any number betweeo 0-100% (not inclusive).
 - **Estimate** is your best guess of the true value based on your sample. For example, if you're trying to estimate the probability of heads, you'd use the proportion of heads in your sample.
 - **Critical value** is a multiplier that depends on $C$, the level of confidence. If you want higher confidence, you must cover more values. For a standard 95% CI, this value is usually approximately 2.
 - **Standard error** is what we call an estimate of the true SD using our sample. In out last plot, this would be an estimate of how far the inner gray lines are from the true probability $p=0.5$.

We'll cover in detail how to compute each of the above quantities for different experiments in the next few chapters, but for now let's do a quick visual example to help build more intuition.

:::{.eg}
Using the last plot, give an approximate 95% confidence interval for the true probability of heads $p$ based on just the first $n=10$ flips from the "run1" experiment.

Looking at a vertical slice along $n=10$, we can see that "run1" had a sample proportion of 0.6, which implies 6 of the first 10 flips were heads. Thus, our sample estimate is 0.6.

We can also see at that point, the 1-SD-above line is at approximately 0.65, which is 0.15 away from the true value, implying the standard error would be close to 0.15.

Using the approximate critical value of 2, our 95% confidence interval for $p$ is $0.6\pm2\cdot0.15=(0.3,0.9)$.

Put it a different way, based on the sample thus far (6/10 heads), we are **95% confident the true probability of heads $p$ is between 30-90%**.
:::

Below is a plot of how the 95% CI updates as the run1 experiment progresses one flip at a time. You can see at any given point in time, we usually do cover the true probability of heads $p=0.5$, as we expect to.

:::{.fold .s}

``` r
# compute and plot 95% CI as experiment progresses
# this will be covered in detail later, but SE is computed by sqrt(p*(1-p)/n)
# where here p refers to the running sample proportion of % of heads out of n
# pmin & pmax are used to ensure the CI bounds for the true p don't exceed [0,1]
tibble(n = 1:1e5, p = cumsum(samp)/n, se = sqrt(p*(1-p)/n)) %>%
  slice(log.indices) %>%
  ggplot(aes(x = n, y = p)) +
  geom_ribbon(aes(ymin = pmax(0, p-2*se), ymax = pmin(1, p+2*se)), alpha = 0.2) +
  geom_hline(yintercept = 0.5, color = "black", alpha = 0.5) + geom_line(aes(color = "run1")) +
  scale_x_log10(breaks = 10^(0:5), labels = scales::comma, expand = 0) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 10), limits = c(0, 1), expand = .01) +
  labs(title = "95% confidence interval for p vs n for run1", y = "proportion")
```

<img src="11-inference_files/figure-html/unnamed-chunk-7-1.svg" width="672" style="display: block; margin: auto;" />
:::


### Interpretation of CI

Let's briefly examine the interpretation of CIs more closely. What does it mean exactly when we say "95% confidence"?

Briefly, a 95% CI means if we repeat the exact same experiment over and over again, each time performing the exact same 95% CI calculation, on average we would expect about 95% of the reps to result in a CI that does in fact contain the true $p=0.5$. The plot below shows a simulation of this fact.



:::{.fold .s}

``` r
N = 20 ; n = 10  # number of repetitions / number of flips in each rep
tibble(flips = rbinom(N*n, 1, 0.5),
       run = rep(1:N,each=n) %>% str_pad(2,pad="0") %>% paste0("run",.)) %>% 
  group_by(run) %>%
  summarize(heads = sum(flips), flips = str_flatten(ifelse(flips,"H","T"))) %>% 
  mutate(p = heads/n, se = sqrt(p*(1-p)/n), ci1 = pmax(0,p-2*se), ci2 = pmin(1,p+2*se),
         capture = ci1<=0.5 & 0.5<=ci2) %>% 
  ggplot(aes(y = fct_rev(paste(run,flips)), x = p, xmin = ci1, xmax = ci2, color = capture)) +
  geom_vline(xintercept = 0.5, color = "black", linetype = "dashed", alpha = 0.5) +
  geom_pointrange(linewidth = 0.8) + scale_color_manual(values = c("red", "black")) +
  theme(axis.text.y = element_text(family = "mono")) + labs(
    y = NULL, title = "Repeated 95% CIs for p vs true p=0.5")
```

<img src="11-inference_files/figure-html/unnamed-chunk-9-1.svg" width="672" style="display: block; margin: auto;" />
:::

Remember that in a real-world example, you don't know what the true probability of heads is, and you only have data from a single experiment, so you don't know if your interval captures the true value or not, but you can be 95% confident that it does.


## Hypothesis testing

If instead of estimating a parameter, your primary goal is to test if a certain parameter value agrees with the data, then you probably want to perform a **hypothesis test**.

A hypothesis test usually starts with specifying a pair of **competing hypotheses** of the following form:

$$
\begin{align}
H_0&:\text{parameter}~\theta=\theta_0\\
H_a&:\text{parameter}~\theta\left.\begin{cases}&<\theta_0\\\text{one of}\!\!&\neq\theta_0\\&>\theta_0\end{cases}\right\rbrace
\end{align}
$$

 - $H_0$ is called the **null hypothesis** and represents your starting assumption, i.e. we begin by assuming $H_0$ to be true with the goal of rejecting it if it differs too much from the data.
 - $H_a$ is called the **alternative hypothesis** and is exactly what it sounds like: the alternative explanation we settle on if we reject the null.
 - $\theta$ here simply represents some parameter of the underlying distribution, e.g. the $p$ in a binomial, or the $\mu$ in a normal.
 - $\theta_0$ is the value of interest for parameter $\theta$ that you are testing against the data.

The actual decision of whether to reject the null is made by computing a **p-value**, which is simply the **probability of observing our dataset _if the null was actually true_**, i.e. the likeliness of the data under $H_0$. If this probability is small enough, it means our null doesn't fit the data, leading to its rejection. The threshold we use for our p-value (i.e. where we begin to reject the null) is called the **significance level $\alpha$** and is commonly set to 0.05 by convention.

In summary, here are the steps involved for a typical hypothesis test:

 1. Specify $H_0$ and $H_a$, and set your desired significance level $\alpha$.
 2. Assuming $H_0$ is true, find the likeliness of your data, i.e. the p-value.
 3. If p-value $<\alpha$, reject $H_0$ in favor of $H_a$. Otherwise, stay with $H_0$.
 4. Interpret the results clearly in the context of the original problem.

This probably all feels very new and nebulous, so let's ground ourselves with a concrete example.

:::{.eg}
You suspect a given coin is weighted to come up heads more often than not. You decide to flip it 10 times and observe a total of 7 heads. At the common $\alpha=0.05$, can you conclude the coin is biased?

Let $p$ represent the true underlying probability of heads for this coin. Then our null $H_0:p=0.5$ (i.e. the coin is fair), and our alternative $H_a:p>0.5$ (i.e. the coin is biasing heads).

Next, we assume the null to be true and compute our p-value. Note that under the null assumption, we can model the number of heads $X\sim\bin(10,p\!=\!0.5)$. For reasons which will be explained soon, our "likeliness of data" for the p-value is actually defined as $\p(X\ge7)$. We can find this using `pbinom()`.


``` r
# recall pbinom gives ≤ the input, so for ≥7, we need:
1 - pbinom(6, 10, 0.5)
```

```
[1] 0.171875
```

``` r
# another way using dbinom instead:
sum(dbinom(7:10, 10, 0.5))
```

```
[1] 0.171875
```

Thus, our p-value is about 0.17, which does not pass our threshold of $\alpha=0.05$, so we do not reject the null. In other words, **our data is not strong enough to conclude the coin is biased** for heads.
:::

The result of the previous example may seem surprising, but is simply a reflection of that fact that 7/10 heads is not that unusual even for a perfectly fair coin, so the **data did not exceed our threshold of disbelief $\alpha$**. If instead of 7 we had observed 9/10 heads, you can check we would've rejected $H_0$ and be able to conclude bias in the coin.

:::{.note}
The interpretations in the previous example are very carefully worded. In hypothesis testing, the mental model you should always have is **does the data disagree strongly enough with the null to reject it or not**. In particular, the following are some common pitfalls of hypothesis testing:

 - The choice is always to **reject or not reject** the null, never "accept" the null.
 - If you reject the null, it does not mean the null is in fact false (you could have made an incorrect rejection).
 - Similarly if you do not reject the null, it does not mean the null is true (your inability to reject could also have been incorrect).
 - Failing to reject the null should be thought of as the evidence not rising to a high enough standard to prefer the alternative.
 - The **p-value is a true probability** and obeys all the usual laws of probability.
:::


### $H_a$ directions

Why did we compute the p-value earlier as $\p(X\ge7)$? One way of thinking about it is the "likeliness" of our dataset here must be found by comparing it with all other possible outcomes for our dataset and ranking it again them. Our p-value of 0.17 earlier basically means it ranks in the top 17% of possible datasets when using total number of heads as a statistic.

Here's a follow-up question then, why do we want to find here the "top percentage" value here by number of heads? The reason for this is that our alternative $H_a:p>0.5$. In order to disprove $H_0$ and support $H_a$, our dataset must get more heads than we would expect vs fair. If instead our alternative hypothesis had been $H_a:p<0.5$, we would've instead computed $\p(X\le7)$, which would have been a much larger value (i.e. much closer to 1 than 0).

What if instead of suspecting the coin to be biasing heads, we only suspected it was unfair but were unsure of the direction (i.e. it could bias heads or tails)? In this case, we'd set $H_a:p\ne0.5$. As for our p-value, we need to compute $\p(X\ge7)+\p(X\le3)$. The first term represents the "top percentage" comparing to other possible outcomes with even more heads, and the second term represents if the situation had been reversed and we instead had 7 tails and 3 heads and the "likeliness" under that scenario or the "bottom percentage" there comparing to other possible outcomes with even fewer heads.

That might seem strange, but it'll make sense if we think about test results in a different way.


### Rejection regions

Let's change to a different example for a fresh perspective (and to aid some upcoming diagrams). Suppose we know a certain population is distributed normally as $X\sim\n(\mu,1)$, in other words we know the standard deviation $\sigma=1$ but we don't know the mean $\mu$. We would like to draw a sample and use it to test at $\alpha=0.05$ the null $H_0:\mu=0$ vs one of the possible alternatives $H_a:\mu<,\ne,\text{or}>0$. Note that under $H_0$, $X$ is standard normal.

This time, instead of simulating or specifying an actual sample, let's just broadly consider what possible samples would result in which conclusions under each alternative.

1. If $H_a:\mu>0$, then in order to reject $H_0$ in favor of $H_a$, our sample would need to have a sample mean $\bar{x}$ so high that it lands in the top $\alpha$, or top 5% of all possible datasets. If it does, we'd have p-value $<\alpha$ and we'd reject $H_0$. This forms the **right-side one-tailed rejection region**:

    <div class="fold s">
    
    ``` r
    ggplot() + geom_function(fun=dnorm, xlim=c(-4,4)) +
      stat_function(fun=dnorm, geom="area", xlim=c(qnorm(.95),4), fill="red") +
      scale_x_continuous(
        breaks=c(-4:4,qnorm(.95)), labels=\(x)prettyNum(x,digits=3), expand=0) +
      scale_y_continuous(expand=0) + labs(x="sample mean", y="density",
        title=TeX("$H_a\\,:\\,\\mu>0$ one-sided rejection region ($\\alpha=0.05$)"))
    ```
    
    <img src="11-inference_files/figure-html/unnamed-chunk-11-1.svg" width="672" style="display: block; margin: auto;" />
    </div>

2. If $H_a:\mu<0$, then conversely in order to reject $H_0$ in favor of $H_a$, our sample would need to have a sample mean $\bar{x}$ so low that it lands in the bottom $\alpha$, or bottom 5% of all possible datasets. If it does, we'd again have p-value $<\alpha$ and we'd reject $H_0$. This forms the **left-side one-tailed rejection region**:

    <div class="fold s">
    
    ``` r
    ggplot() + geom_function(fun=dnorm, xlim=c(-4,4)) +
      stat_function(fun=dnorm, geom="area", xlim=c(-4,qnorm(.05)), fill="red") +
      scale_x_continuous(
        breaks=c(-4:4,qnorm(.05)), labels=\(x)prettyNum(x,digits=3), expand=0) +
      scale_y_continuous(expand=0) + labs(x="sample mean", y="density",
        title=TeX("$H_a\\,:\\,\\mu<0$ one-sided rejection region ($\\alpha=0.05$)"))
    ```
    
    <img src="11-inference_files/figure-html/unnamed-chunk-12-1.svg" width="672" style="display: block; margin: auto;" />
    </div>

3. Finally, if $H_a:\mu\ne0$, then a **sample mean $\bar{x}$ either too high OR too low** should result in rejecting $H_0$ in favor of $H_a$. Here, we'd need our rejection region to cover together the $\alpha$ or 5% **most extreme possible datasets on either side**. In other words, we want both the $\alpha/2$ or 2.5% top AND bottom corners. This forms the **two-sided rejection region**:

    <div class="fold s">
    
    ``` r
    ggplot() + geom_function(fun=dnorm, xlim=c(-4,4)) +
      stat_function(fun=dnorm, geom="area", xlim=c(-4,qnorm(.025)), fill="red") +
      stat_function(fun=dnorm, geom="area", xlim=c(qnorm(.975),4), fill="red") +
      scale_x_continuous(
        breaks=c(-4:-3,-1:1,3:4,qnorm(c(.025,.975))), labels=\(x)prettyNum(x,digits=3), expand=0) +
      scale_y_continuous(expand=0) + labs(x="sample mean", y="density",
        title=TeX("$H_a\\,:\\,\\mu{\\ne}0$ two-sided rejection region ($\\alpha=0.05$)"))
    ```
    
    <img src="11-inference_files/figure-html/unnamed-chunk-13-1.svg" width="672" style="display: block; margin: auto;" />
    </div>

Thus, in order to properly compute the p-value of a given sample, we need to evalute different "tail" areas depending on our $H_a$. Suppose your parameter is $\theta$, your hypothesized value under the null is $\theta_0$, and your sample observed statistic is $\theta_s$. Then:

 - For one-sided hypotheses, simply take the corresponding "tail" area on that side,

   - So if $H_a:\theta>\theta_0$, take the upper tail area, or $\p(\theta\ge\theta_s)$,

   - Or if $H_a:\theta<\theta_0$, take the lower tail area, or $\p(\theta\le\theta_s)$,

 - For a two-sided hypothesis, take _both outer_ "tails" on either side of the distribution beyond your statistic,

   - So if $H_a:\theta\ne\theta_0$, take $\p(\theta\le\theta_{s\text{-lower}})+\p(\theta\ge\theta_{s\text{-upper}})$ where $\theta_{s\text{-lower}},\theta_{s\text{-upper}}$ are the two opposite-tailed lower and upper statistics for your sample.

   - If the distribution under the null (which is what we've been plotting each time) is symmetric, you can just find one side and multiply it by 2 to get both sides.

   - Furthermore, if the distribution is not only symmetric but also centered around 0 (as in the example above), the two-sided p-value expression is often written $\p(|\theta|\!\ge\!|\theta_s|)$.


