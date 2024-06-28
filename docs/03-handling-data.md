

# Handling Data


In this chapter we will discuss handling data in R. We will begin with a discussion of the different data types and structures in R, learn some basic ways of manipulating them, then end with a discussion of reading and writing data files.




## Vectors


First, let's discuss vectors. **Vectors are arguably the MOST fundamental data structure in R**. We briefly saw an example of vectors last chapter in section \@ref(summary-functions) on summary functions:


``` r
# create an example dataset of a small sample of numbers
data <- c(3, 6, 6, 2, 4, 1, 5)
data
```

```
## [1] 3 6 6 2 4 1 5
```

Last chapter, we mostly used vectors to demonstrate summary functions like `sum()`, `mean()`, or `sd()`, but this is just the tip of the iceberg. In fact, **most functions in R run on vectors directly, *one value at a time***, and are actually most efficient when used this way.

:::{.note}
In R, a vector can only have ONE "type" (or "class") of object at a time, e.g. a vector of ALL numbers, or a vector of ALL characters, or a vector of ALL dates, etc. Vectors of mixed-type are NOT allowed in R.

Also, we have actually been working with vectors all along. That's because single values in R are in fact vectors of length 1. E.g. take any number, let's say 5; we can use `is.vector()` to show that this is in fact a vector of length 1.

``` r
x <- 5
is.vector(x)
```

```
## [1] TRUE
```

``` r
length(x)
```

```
## [1] 1
```

This is why vectors are the most fundamental structure. It may be useful going forward to think of numbers instead as numeric vectors, logicals (TRUE/FALSE) as logical vectors, characters (i.e. strings) as character vectors, etc. **Everything runs on vectors**!
:::



### Types of vectors

There are LOTS of types of vectors, everything from numeric to character to complex number and raw objects. In this class, we will only need to learn the following 4 types of vectors:

 - **Numeric** vectors, which contain real numbers. Generally, R functions don't distinguish between integers and decimal numbers (also called "doubles" or "floats") so treat all numbers as decimal-valued real numbers. ^[To be pedantic, R represents all numbers by default as double-precision floating-point numbers, as per [IEC 60559](https://www.iso.org/standard/80985.html) specifications, which is identical to [IEEE 754](https://en.wikipedia.org/wiki/IEEE_754) specs.]




<!--


## Data types

In R, there are 4 main data types (also called classes) we will commonly work with: numeric, character, logical, and date. We will briefly discuss each of these below, as well as cover some common functions for working with each data type.



### Numeric

Numeric values are the most common data type in R. Generally, R does not distinguish between integer and decimal numbers, so treat all numbers as decimal-valued real numbers.

-->



### Numeric vectors


Let's start with numeric vectors. For example, suppose we want to double, or square, or take the arc-tangent, or find the rounded base-2 logarithm of each `data` value, we can just do so directly on the vector, and it runs one value at a time:


``` r
data * 2
```

```
## [1]  6 12 12  4  8  2 10
```

``` r
data^2
```

```
## [1]  9 36 36  4 16  1 25
```

``` r
atan(data)
```

```
## [1] 1.2490458 1.4056476 1.4056476 1.1071487 1.3258177 0.7853982
## [7] 1.3734008
```

``` r
round(log2(data))
```

```
## [1] 2 3 3 1 2 0 2
```

Note you can also use `data` on the other side of these operators, or as the argument to certain functions:


``` r
2^data
```

```
## [1]  8 64 64  4 16  2 32
```

``` r
# log(10) with various bases; note the Inf due to base 1
log(10, base = data)
```

```
## [1] 2.095903 1.285097 1.285097 3.321928 1.660964      Inf
## [7] 1.430677
```

We can combine these with summary functions to do some neat things. For example, suppose we want to manually calculate the [standard deviation](https://www.mathsisfun.com/data/standard-deviation.html)---i.e. the average deviation from the mean---of the sample. Again, we will discuss this in more detail later in the course, but for now here is the formula:

$$SD = \sqrt{\frac1{n-1}\sum_{i=x}^n(x_i-\bar x)^2}\qquad\text{where $\bar{x}=\frac1n\sum_{x=i}^nx_i$}$$

In other words, the standard deviation is the square root of 1/(n-1) times the sum of the squared differences between the sample mean and each `data` value. This is very easy to do with vector arithmetic in R:


``` r
# implementing sd() using vector arithmetic syntax
n <- length(data)
sqrt((1 / (n - 1)) * sum((data - mean(data))^2))
```

```
## [1] 1.9518
```

Let's break this down. On the inside, `data - mean(data)` subtracts the mean from each data value one at a time:


``` r
data - mean(data)
```

```
## [1] -0.8571429  2.1428571  2.1428571 -1.8571429  0.1428571
## [6] -2.8571429  1.1428571
```

This is then squared `( ... )^2` and again, this operates one at a time:


``` r
(data - mean(data))^2
```

```
## [1] 0.73469388 4.59183673 4.59183673 3.44897959 0.02040816
## [6] 8.16326531 1.30612245
```

Finally, this vector is summed, scaled by 1/(n-1), and square rooted to get the standard deviation. We can check this is correct by comparing with the built-in `sd()` function.


``` r
sd(data)
```

```
## [1] 1.9518
```




### Logical vectors


These ["vectorized"](https://osu-codeclub.github.io/posts/basics_04/) operations also work with logical comparisons, and these produce **logical vectors**. For example, we can ask R which observations are even:


``` r
# recall %% gives the division remainder
data %% 2 == 0
```

```
## [1] FALSE  TRUE  TRUE  TRUE  TRUE FALSE FALSE
```

Or we can ask which of our values are within 1 standard deviation of the mean:


``` r
# recall & is the AND operator
# note the inequality checks EACH value of data against the other side
(mean(data) - sd(data) <= data) & (data <= mean(data) + sd(data))
```

```
## [1]  TRUE FALSE FALSE  TRUE  TRUE FALSE  TRUE
```

Remember from section \@ref(r-specials) how doing any kind of **math turns `TRUE` into 1 and `FALSE` into 0**? This turns out to be extremely useful. For example, we can use `sum()` to count how many values are even:


``` r
# sum(logical vector) counts the number of TRUEs
# here, we find 4 data values are even
sum(data %% 2 == 0)
```

```
## [1] 4
```

Or we can ask what *proportion* of our data is within 1 standard deviation of the mean, which involves taking the sum of a logical comparison and dividing by the length, i.e. computing the mean:


``` r
# mean(logical vector) = sum(logical vector) / length(logical vector)
# thus, it's a shortcut for calculating proportion of TRUEs
# here, we find 57% of the data is within 1 sd of the mean
mean(
  (mean(data) - sd(data) <= data) & (data <= mean(data) + sd(data))
)
```

```
## [1] 0.5714286
```

:::{.tip}
Remember: whenever you have a vector of `TRUE`/`FALSE` values---usually as a result of some logical comparison---you can use `sum()` to count how many are `TRUE`, or `mean()` to compute the proportion of `TRUE` values. You can of course also use these in other numeric operations, just remember `TRUE`$\rightarrow1$, `FALSE`$\rightarrow0$.
:::




### Other constructors


So far we only learned to construct vectors with the `c()` function, e.g. `data<-c(3,6,6,2,4,1,5)`. There are a few other common ways to construct them.

One of the easiest, if you just need a sequence of integers, is to use the `:` operator:


``` r
1:5
```

```
## [1] 1 2 3 4 5
```

``` r
10:-10
```

```
##  [1]  10   9   8   7   6   5   4   3   2   1   0  -1  -2  -3  -4
## [16]  -5  -6  -7  -8  -9 -10
```

The `seq()` function does something similar, except it also has additional arguments `by` to specify the step size and `length.out` which specifies how many numbers to have in total (note only ONE of these arguments can be set at a time).


``` r
seq(1, 5)
```

```
## [1] 1 2 3 4 5
```

``` r
seq(0, 100, by = 10)
```

```
##  [1]   0  10  20  30  40  50  60  70  80  90 100
```

``` r
seq(0, 1, length.out = 101)
```

```
##   [1] 0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11
##  [13] 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23
##  [25] 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35
##  [37] 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47
##  [49] 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59
##  [61] 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71
##  [73] 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83
##  [85] 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95
##  [97] 0.96 0.97 0.98 0.99 1.00
```

Vectors can also be created with the `rep()` function which lets you repeat the contents. There are two arguments: `times` which controls how many times to repeat the entire input, and `each` which controls how many times to repeat each element if the input is a vector. You can specify either or both of these arguments. Note `rep()` can be used to repeat other objects too, not just numbers.


``` r
# repeat a single number
rep(2, 5)
```

```
## [1] 2 2 2 2 2
```

``` r
# repeat a vector, specifying both times and each
rep(1:3, times = 3, each = 4)
```

```
##  [1] 1 1 1 1 2 2 2 2 3 3 3 3 1 1 1 1 2 2 2 2 3 3 3 3 1 1 1 1 2 2
## [31] 2 2 3 3 3 3
```

``` r
# you can also let times be a vector, as well as repeat other objects
rep(c(TRUE, FALSE), times = c(2, 4))
```

```
## [1]  TRUE  TRUE FALSE FALSE FALSE FALSE
```

Finally, you can mix and match all these constructors, using a combination of `c()`, `:`, `seq()`, and `rep()` to your heart's content.


``` r
rep(c(1, 3, 7:9, seq(10, 12, by = 0.5)), each = 2)
```

```
##  [1]  1.0  1.0  3.0  3.0  7.0  7.0  8.0  8.0  9.0  9.0 10.0 10.0
## [13] 10.5 10.5 11.0 11.0 11.5 11.5 12.0 12.0
```




### Multiple vectors + vector recycling


It may not surprise you to learn all these vectorized operations also work on multiple vectors! If the vectors aren't the same length, **the shorter vectors will be repeated** until they matches the length of the longest vector. This is called [**recycling**](https://www.geeksforgeeks.org/vector-recycling-in-r/). Example:


``` r
# define some vectors for demo
# x1, x2 are both length 6 vectors
# y and z have lengths 3 and 2
x1 <- 0:5         # x1:  0, 1, 2, 3, 4, 5
x2 <- -2:3        # x2: -2,-1, 0, 1, 2, 3
y  <- 1:3         #  y:  1, 2, 3
z  <- c(-1, 1)    #  z: -1, 1
```


``` r
# sum vectors one element at a time
x1 + x2
```

```
## [1] -2  0  2  4  6  8
```

``` r
# take powers, again one element at a time from each vector
x2^x1
```

```
## [1]   1  -1   0   1  16 243
```

``` r
# take differences, one element at a time, recycling y
x1 - y
```

```
## [1] -1 -1 -1  2  2  2
```

``` r
# log y with x1+2 as base, again recycling y
log(y, base = x1 + 2)
```

```
## [1] 0.0000000 0.6309298 0.7924813 0.0000000 0.3868528 0.5645750
```

``` r
# more complex operation that recycles multiple vectors,
# as well as some numbers (which are just length-1 vectors)
2^abs(x1 * z) - x2^y - median(data)
```

```
## [1] -1 -3  0  3  8  1
```

``` r
# these also work with other numeric/logical functions we've seen so far
# here, left side is a length-6 vector, right side is a length-2 vector,
# so right side is recycled three times then compared with left
x2 <= atan(z) * mean(x1)
```

```
## [1]  TRUE  TRUE FALSE  TRUE FALSE FALSE
```

:::{.note}
In this class, **you should *never* need a for loop** for any exercises (hence why it's considered a bonus topic and not covered in the notes but instead left as optional additional reading).

Instead, ***always* look for a solution using vectorized operations**. In R, vectorized operations are basically always [MUCH faster than for loops](https://datakuity.com/2018/01/17/for-loop-vs-vectorization-in-r/), due to low-level parallelization optimizations.
:::




### `%in%` (Vector membership)


One notable exception to all this is the [`%in%`{.R}](https://rdrr.io/r/base/match.html) operator, which only "vectorizes" on the left side. For example, suppose we want to know which elements of `z` are in `x1`. Here's how:


``` r
z %in% x1
```

```
## [1] FALSE  TRUE
```

Note the difference between this and `z == x1`, which **recycles `z`, then checks element-wise equality**:


``` r
z == x1
```

```
## [1] FALSE  TRUE FALSE FALSE FALSE FALSE
```

This is another common point of confusion for first time R users. Make sure you understand the **difference between checking vector membership**, i.e. if each element of one vector is also contained in another vector, **vs checking element-by-element equality**, i.e. checking if the 1^st^ elements are the same, and the 2^nd^ elements are the same, and the 3^rd^ elements are the same, etc. (possibly with recycling). See [this StackOverflow page](https://stackoverflow.com/a/42637186/25278020) for more examples.


:::{.note}
Going forward, we will continue to implicitly use vectorized functions and vector recycling in code examples without drawing attention to it, for sake of brevity. Pretty soon, these concepts should feel like second nature to you!
:::




### Vector subsetting

Let's quickly also talk about





<!--

### Character vectors

Another important data type in R is **character vectors** (i.e. strings in some other programming languages).

-->

