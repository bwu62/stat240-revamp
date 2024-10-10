

# Intro to Probability

In this section, we'll introduce you to some foundational probability theory that will be necessary for later models. We will do this in a way that is only semi-rigorous, with an emphasis on teaching the materials in an intuitive fashion.


## Random variables (RVs)

Suppose we have an **experiment** that produces an **outcome** each time it's observed. This is modeled by a **random variable**, often denoted with a capital letter, e.g. $X$ or $Y$. The set of all possible outcomes is called the **sample space** and often denoted $\Omega$.

Sets of possible outcomes are called **events**. Each event has some **probability** associated with it. The probability of some event is often denoted $P(\text{event})$.

A **distribution** is any specification of both the outcomes and the associated probabilities of a random variable.

:::{.eg}
Let $X$ be the result of rolling a standard 6-sided die that is **fair**, i.e. the outcomes 1, 2, 3, 4, 5, and 6 all have equal probability. Here are few examples of events and their corresponding probabilities:

 - Probability of getting a 1: $P(X=1)=\frac16$
 - Probability of getting more than 4: $P(X>4)=\frac13$
 - Probability of getting an even number: $P(X=2,4,\text{or }6)=\frac12$
 - Probability of getting a 7: $P(X=7)=0$
:::


## Axioms of probability

In math, **axioms** are basic rules which formally define an object and which are assumed to be true without proof. These form the basis on which everything else rests. These are the axioms of probability:

 1. The probability of an event is always non-negative.
    - Mathematically, $P(E)\ge0$ for any event $E$ of some random variable.
 2. The probability of the entire sample space is always 1.
    - Mathematically, $P(\Omega)=1$ for any random variable. Note 1 is equivalent to 100\%.
 3. The probability of the **union** of **mutually exclusive** events is equal to the sum of the probabilities of each event.
    - Mathematically, if $A\cap B$ is empty, then $P(A\cup B)=P(A)+P(B)$

:::{.def}
Let $A$ and $B$ be two events for some random variable.

The **union** of $A$ and $B$, denoted $A\cup B$, is the event of observing $A$ OR $B$.

The **intersection** of $A$ and $B$, denoted $A\cap B$, is the event of observing $A$ AND $B$.

$A$, $B$ are called **mutually exclusive** if they don't intersect, i.e. they have no outcomes in common.
:::

:::{.eg}
Let's see these in an example. Let $X$ again be the result of rolling a fair, 6-sided die with outcomes $1,2,\ldots,6$.

Let $A$ be the event of observing $X$ to be more than 4, and let $B$ be the event of observing $X$ to be an even number. Then, $A\cap B=\{6\}$ and $A\cup B=\{2,4,5,6\}$. Note that $1,3$ are in neither $A$ nor $B$.

Since $A\cap B=\{6\}$ which is NOT empty, $A$ and $B$ are NOT mutually exclusive. Suppose we define a third event $C$ as observing $X$ to be either $1$ or $3$. Then, $C$ is mutually exclusive with both $A$ and $B$, since both $A\cap C$ and $B\cap C$ are empty.
:::


### Corollaries

From these axioms, we have a few important corollaries (i.e. derived statements) that are also true:

 1. Probabilities are always between 0 and 1.
    - Mathematically, for any event $E$, we have $0\le P(E)\le1$
 2. To get the probability of the "opposite" event, subtract from 1.
    - Mathematically, for any event $E$, we have $P(\text{not }E)=1-P(E)$.
 3. In general, for any $A,B$, the probability of $A$ or $B$ is the probability of $A$ plus $B$ minus the intersection of $A$ and $B$. This is the generalized form of the 3^rd^ axiom.
    - Mathematically, $P(A\cup B)=P(A)+P(B)-P(A\cap B)$.

These are not difficult to derive from the axioms, but we omit the proofs for brevity.^[See [here](https://en.wikipedia.org/wiki/Probability_axioms#Consequences) for details.] 


:::{.eg}
Here's an example of how to use these axioms. Suppose in Nice Town, on an average day, there's a 70% chance it's sunny, and a 40% chance of a light breeze. Suppose there's a 20% chance of being neither sunny nor breezy. What's the probability it's both sunny and breezy?

Let $S$ represent sunny, and $B$ represent breezy. Then, from the information given, we know $P(S)=0.7$, $P(B)=0.4$, and $P(\text{neither \(S\) nor \(B\)})=0.2$.

By corollary 2, $P(\text{neither \(S\) nor \(B\)})=1-P(S\cup B)$, so we have $P(S\cup B)=0.8$.

By corollary 3, $P(S\cup B)=P(S)+P(B)-P(S\cap B)$, so we have $P(S\cap B)=P(S)+P(B)-P(S\cup B)=0.7+0.4-0.8=0.3$. Thus, there's a 30% chance of it being both sunny and breezy.
:::


## Discrete vs Continuous RVs

Generally, random variables are either **discrete** or **continuous**.

:::{.def}
A **discrete** RV is one whose **outcomes can be listed out one-by-one**. The list is allowed to be infinite.^[Formally, $\Omega$ must be [countable](https://en.wikipedia.org/wiki/Countable_set).]

A **continuous** RV is the opposite, where **outcomes are in a continuous range** and not listable.
:::

In practice, we usually use **discrete RVs to model integer valued outcomes**, e.g. counts of something; and **continuous RVs to model real number valued outcomes**, e.g. lengths/weights/durations. These require slightly different mathematical notations/treatments.


### Discrete RVs

For discrete RVs, the distribution of outcomes and probabilities is specified with a **probability mass function** (PMF). Note the PMF must satisfy all rules of probability. In particular, all probabilities must be in $[0,1]$, and $P(\Omega)=\sum_\text{k}P(k)=1$ where $k$ represents each possible outcome.


:::{.def}
Let $X$ be a discrete RV. The **probability mass function (PMF)** of $X$ is a function $P$ which, for each possible outcome $k$ in the sample space, specifies the probability that $X$ is observed to be $k$, denoted $P(X\! =\!k)$, or sometimes $P(k)$ for short.

To be a valid PMF, $P$ must satisfy the probability axioms, namely it always be **non-negative** and **sum to 1** across all possible outcomes in the sample space.
:::


PMFs can be specified using either a table, function, or plot.

:::{.eg}
Let $X$ be the number of dollars you win from a new casino game where there's only 4 possible outcomes: you either win nothing with 40% chance, or you win \$1 with 30% chance, or you win \$2 with 20% chance, or you win \$3 with 10% chance.

First, it's easy to see the axioms are satisfied, since all probabilities are in $[0,1]$ and $0.1+0.2+0.3+0.4=1$. Thus, this is a valid PMF. We can specify the PMF in any of the following equivalent ways:

#### Table: {-}

<center>

     k | P(k)
    ---+-----
     0 | 0.4 
     1 | 0.3 
     2 | 0.2 
     3 | 0.1 

</center>

#### Function: {-}

$$P(X\! =\!k)=\begin{cases}\frac1{10}\big(4-k\big) & k=0,1,2,3 \\ 0 & \text{otherwise}\end{cases}$$

#### Plot: {-}




``` r
# remember to import tidyverse (and optionally, update theme options)
tibble(k = 0:3, p = (4:1)/10) %>%
  ggplot(aes(x = k, y = p)) + geom_col() +
  labs(title = "Distribution of X (winnings from made-up casino game)")
```

<img src="10-probability_files/figure-html/unnamed-chunk-1-1.svg" width="672" style="display: block; margin: auto;" />

:::


:::{.eg}
For another example, let $X$ be the sum of rolling 2 ordinary, fair 6-sided dice (independently)^[[Independence](https://www.probabilitycourse.com/chapter1/1_4_1_independence.php) has a formal probabilistic definition that's beyond the scope of 240. You can simply think of it as rolling the dice in a way that doesn't affect each other.]. What is the PMF of $X$?

First, note the possible outcomes $k$ in the sample space are the integers $k=2,3,\ldots,12$. Next, since the dice are fair, we can find the probability of each outcome $k$ by counting the number of combinations that add to $k$. For example, for $k=5$ the outcomes are 14, 23, 32, and 41. Each outcome has probability 1/36 so summing them we get $P(X=5)=4\cdot\frac1{36}=\frac19$

From this, you can show the probability for each $k=2,3,\ldots,12$ is $P(X=k)=(6-|k-7|)/36$. Thus we can write the PMF as:

$$P(X\! =\!k)=\begin{cases}\frac1{36}\big(6-|k-7|\big)&k=2,3,\ldots,12\\0&\text{otherwise}\end{cases}$$

You can easily check this PMF satisfies the probability axioms. Here's a plot of this PMF:


``` r
tibble(k = 2:12, p = (6-abs(k-7))/36) %>%
  ggplot(aes(x = k, y = p)) + geom_col() +
  labs(title = "Distribution of X (sum of 2 independent & fair ordinary 6-sided dice)") +
  scale_x_continuous(breaks = 2:12) +
  scale_y_continuous(breaks = seq(0,.2,.02))
```

<img src="10-probability_files/figure-html/unnamed-chunk-2-1.svg" width="672" style="display: block; margin: auto;" />

:::


### Continuous RVs

For continuous RVs, distributions are specified with a **probability density function** (PDF). They are similar to PMFs but with a key distinction: a **PDF's value is NOT the probability of an outcome**, rather it denotes "density" which can be thought of as the rate of change of probability.

:::{.def}
Let $X$ be a continuous RV. The **probability density function (PDF)** of $X$ is a function $P$ which, for each outcome $x$ in the sample space, specifies the density of probability around $x$.

To be a valid PDF, $P$ must also satisfy the probability axioms, i.e. $P$ must always be **non-negative** and **integrate to 1** across the sample space.
:::

:::{.note}
Unlike discrete PMFs, continuous **PDFs do NOT give the probability at an outcome**! For continuous PDFs, **probabilities of events are instead ALWAYS areas under PDF function**.

Also note it's customary to use $k$ to represent possible outcomes of discrete PMFs, and $x$ to represent possible outcomes of continuous PDFs.
:::

PDFs are the continuous analog of PMFs, so whenever you might use PMFs in a summation $\sum$ expression, you would switch to a definite integral $\int$ for a PDF. In STAT 240, **we will NOT require you to evaluate these integrals** but we may occasionally show them to familiarize you with the notation. Computations with simple PMFs may be asked however.

:::{.eg}
PDFs can be hard to understand at first, so here's an easy example to start. Let $X$ be a normal
:::


