

# Intro to Probability

In this section, we'll introduce you to some foundational probability theory that will be necessary for later models. We will do this in a way that is only semi-rigorous, with an emphasis on teaching the materials in an intuitive fashion.


## Random variables

Suppose we have an **experiment** that produces an **outcome** each time it's observed. This is modeled by a **random variable**, often denoted with a capital letter, e.g. $X$ or $Y$. The set of all possible outcomes is called the **sample space** and often denoted $\Omega$.

Sets of possible outcomes are called **events**. Each event has some **probability** associated with it. The probability of some event is often denoted $P(\text{event})$.

:::{.eg}
Let $X$ be the result of rolling a 6-sided die that is **fair**, i.e. the outcomes 1, 2, 3, 4, 5, and 6 all have equal probability. Here are few examples of events and their corresponding probabilities:

 - Probability of getting a 1: $P(X=1)=\frac16$
 - Probability of getting more than 4: $P(X>4)=\frac13$
 - Probability of getting an even number: $P(X=2,4,\text{or }6)=\frac12$
 - Probability of getting a 7: $P(X=7)=0$
:::


## Axioms of probability

In math, **axioms** are basic rules which formally define an object and which are inviolably true. Below are the axioms of probability, **which can never be broken**:

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

If $A$, $B$ are **mutually exclusive**, then they have no intersection, i.e. there are no outcomes that are in both $A$ and $B$.
:::

:::{.eg}
Let's see these in an example. Let $X$ again be the result of rolling a fair, 6-sided die with outcomes 1,2,…,6.

Let $A$ be the event of observing $X$ to be more than 4, and let $B$ be the event of observing $X$ to be an even number. Then, $A\cap B=\{6\}$ and $A\cup B=\{2,4,5,6\}$. Note that $1,3$ are in neither $A$ nor $B$.

Since $A\cap B=\{6\}$ which is NOT empty, $A$ and $B$ are NOT mutually exclusive. Suppose we define a third event $C$ as observing $X$ to be either 1 or 3. Then, $C$ is mutually exclusive with both $A$ and $B$, since both $A\cap C$ and $B\cap C$ are empty.
:::
