


# Data Vectors

In this chapter, we will introduce you to handling data in R, starting with vectors. **Vectors are arguably the MOST fundamental data structure in R**. We briefly saw an example of vectors last chapter in section \@ref(summary-functions) on summary functions:


``` r
# create an example dataset of a small sample of numbers
data <- c(3, 6, 6, 2, 4, 1, 5)
data
```

```
[1] 3 6 6 2 4 1 5
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
[1] TRUE
```

``` r
length(x)
```

```
[1] 1
```

This is why vectors are the most fundamental structure. It may be useful going forward to think of numbers instead as numeric vectors, logicals (TRUE/FALSE) as logical vectors, characters (i.e. strings) as character vectors, etc. **Everything runs on vectors**!
:::



## Types of vectors

There are LOTS of types of data that vectors can hold, from real to complex numbers, characters to raw byte-data, and even dates and times.^[Technically, there are only 6 fundamental, or ["atomic"](https://cran.r-project.org/doc/manuals/r-release/R-lang.html#:~:text=R%20has,%20table) types, but some of these can represent multiple "classes" of objects. See the section on [Vectors](https://adv-r.hadley.nz/vectors-chap.html) from Hadley Wickham's excellent "*Advanced R*" book for the minutiae. I know this footnote is overly pedantic and technical, but I don't want to incur the wrath of CS nerds.] In this class, we will only deal with the following 4 types of vectors:

 - **Numeric** vectors, which contain real numbers. Generally, R functions don't distinguish between integers and decimal numbers (also called "doubles" or "floats") so treat all numbers as decimal-valued real numbers.^[For the CS students, R represents all numbers by default as double-precision floating-point numbers as per [IEC 60559/IEEE 754](https://en.wikipedia.org/wiki/IEEE_754) specifications. There are no single precision values in R. You can force a number to be a [32-bit signed integer](https://rdrr.io/r/base/integer.html) by adding an `L` to the end, e.g. `1L`, but this is extremely rare in data science and generally offers no real, tangible advantages.]
 - **Logical** vectors, which contain only `TRUE`/`FALSE` values. Usually, these arise from logical comparison operators or other functions that check if some condition is satisfied. Remember that in computations, TRUE becomes 1 and FALSE becomes 0.^[Again, for the CS nerds, 0 in R is considered "falsy" and all other numbers are considered "truthy". E.g. try running `x & TRUE` for zero and non-zero x and observe the output.]
 - **Character** vectors, which contain characters (often also called "strings"). These are basically categorical or text data. E.g. you may have groups "A" and "B", or sex "Male" and "Female". You can even have sentences, paragraphs, or entire bodies of text in a character. We will only briefly touch on processing text data in this class.^[CS people, looking at you again. Some languages distinguish between "character" type, which can only be just a single character; and "string" type, which are sequences of characters. In R, there is no such distinction; characters and strings are synonymous. Note this means you cannot "slice" through a string as if it's just a list of characters in R like some other languages.]
 - Lastly, **date** vectors will also be covered. These are actually closely related to numeric vectors (more on this later). These are ubiquitous in data science and thus deserving of inclusion.^[I don't have anything pedantic to add here, but all the other vectors got footnotes so I didn't want dates to feel left out :( ... <br/><br/> ...well ok, since you bothered to click this, I'll give you something. We'll discuss this later too, but here's a sneak preview: dates in R, like in many other languages, are stored as [number of days after Jan 1^st^ 1970](https://rdrr.io/r/base/Dates.html), which is often ominously referred to as the "Epoch". Why 1/1/70? Because reportedly it ["*seemed to be as good as any*"](https://retrocomputing.stackexchange.com/a/25599). <br/><br/> This is why dates are basically numeric vectors with extra steps. However, like with anything, the devil's in the details, and learning to work efficiently with dates is not trivial.]
   - Note: we only cover dates themselves, not date + time values (also called datetime) since these are actually quite different data types and we only have so many lectures.^[Similar-ish to dates, datetimes are often stored as a (possibly decimal) [number of seconds after midnight of Jan 1^st^ 1970](https://rdrr.io/r/base/DateTimeClasses.html) called a POSIXct object, although R confusingly also has a whole other type of datetime object called POSIXlt where each date/time component is stored as an element of a [list](https://jennybc.github.io/purrr-tutorial/bk00_vectors-and-lists.html) (which is a whole other giant beast we don't even remotely have time to get into). See Hadley Wickham's page on [datetime](https://r4ds.hadley.nz/datetimes.html) from his book "*R for Data Science*" for more info on datetime objects.]




## Numeric vectors


Let's start with numeric vectors. For example, suppose we want to double, or square, or take the arc-tangent, or find the rounded base-2 logarithm of each `data` value, we can just do so directly on the vector, and it runs one value at a time:


``` r
data * 2
```

```
[1]  6 12 12  4  8  2 10
```

``` r
data^2
```

```
[1]  9 36 36  4 16  1 25
```

``` r
atan(data)
```

```
[1] 1.2490458 1.4056476 1.4056476 1.1071487 1.3258177 0.7853982 1.3734008
```

``` r
round(log2(data))
```

```
[1] 2 3 3 1 2 0 2
```

Note you can also use `data` on the other side of these operators, or as the argument to certain functions:


``` r
2^data
```

```
[1]  8 64 64  4 16  2 32
```

``` r
# log(10) with various bases; note the Inf due to base 1
log(10, base = data)
```

```
[1] 2.095903 1.285097 1.285097 3.321928 1.660964      Inf 1.430677
```

We can combine these with summary functions to do some neat things. For example, suppose we want to manually calculate the [standard deviation](https://www.mathsisfun.com/data/standard-deviation.html)---i.e. the average deviation from the mean---of the sample. Again, we will discuss this in more detail later in the course, but for now here is the formula:

$$SD = \sqrt{\frac1{n-1}\sum_{i=1}^n(x_i-\bar x)^2}\qquad\text{where $\bar{x}=\frac1n\sum_{i=1}^nx_i$}$$

In other words, the standard deviation is the square root of 1/(n-1) times the sum of the squared differences between the sample mean and each `data` value. This is very easy to do with vector arithmetic in R:


``` r
# implementing sd() using vector arithmetic syntax
n <- length(data)
sqrt((1 / (n - 1)) * sum((data - mean(data))^2))
```

```
[1] 1.9518
```

Let's break this down. On the inside, `data - mean(data)` subtracts the mean from each data value one at a time:


``` r
data - mean(data)
```

```
[1] -0.8571429  2.1428571  2.1428571 -1.8571429  0.1428571 -2.8571429  1.1428571
```

This is then squared `( ... )^2` and again, this operates one at a time:


``` r
(data - mean(data))^2
```

```
[1] 0.73469388 4.59183673 4.59183673 3.44897959 0.02040816 8.16326531 1.30612245
```

Finally, this vector is summed, scaled by 1/(n-1), and square rooted to get the standard deviation. We can check this is correct by comparing with the built-in `sd()` function.


``` r
sd(data)
```

```
[1] 1.9518
```




## Logical vectors


These ["vectorized"](https://osu-codeclub.github.io/posts/basics_04) operations also work with logical comparisons, and these produce **logical vectors**. For example, we can ask R which observations are even:


``` r
# recall %% gives the division remainder
data %% 2 == 0
```

```
[1] FALSE  TRUE  TRUE  TRUE  TRUE FALSE FALSE
```

Or we can ask which of our values are within 1 standard deviation of the mean:


``` r
# recall & is the AND operator
# note the inequality checks EACH value of data against the other side
(mean(data) - sd(data) <= data) & (data <= mean(data) + sd(data))
```

```
[1]  TRUE FALSE FALSE  TRUE  TRUE FALSE  TRUE
```

Remember from section \@ref(r-specials) how any **math turns `TRUE` into 1 and `FALSE` into 0**? This turns out to be extremely useful. For example, we can use `sum()` to count how many values are even:


``` r
# sum(logical vector) counts the number of TRUEs
# here, we find 4 data values are even
sum(data %% 2 == 0)
```

```
[1] 4
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
[1] 0.5714286
```

:::{.tip}
Remember: whenever you have a vector of `TRUE`/`FALSE` values---usually as a result of some logical comparison---you can use `sum()` to count how many are `TRUE`, or `mean()` to compute the proportion of `TRUE` values. You can of course also use these in other numeric operations, just remember `TRUE`$\rightarrow1$, `FALSE`$\rightarrow0$.
:::




## Other constructors


So far, we've only learned how to construct vectors by using the `c()` function, for example `data<-c(3,6,6,2,4,1,5)`. There are a few other common ways to construct them.

One of the easiest, if you just need a sequence of integers, is to use the `:` operator:


``` r
1:5
```

```
[1] 1 2 3 4 5
```

``` r
10:-10
```

```
 [1]  10   9   8   7   6   5   4   3   2   1   0  -1  -2  -3  -4  -5  -6  -7  -8  -9
[21] -10
```

The `seq()` function does something similar, except it also has additional arguments `by` to specify the step size and `length.out` which specifies how many numbers to have in total (note: only ONE of these arguments can be set at a time).


``` r
seq(1, 5)
```

```
[1] 1 2 3 4 5
```

``` r
seq(0, 100, by = 10)
```

```
 [1]   0  10  20  30  40  50  60  70  80  90 100
```

``` r
seq(0, 1, length.out = 101)
```

```
  [1] 0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15
 [17] 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31
 [33] 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47
 [49] 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63
 [65] 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79
 [81] 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95
 [97] 0.96 0.97 0.98 0.99 1.00
```

Vectors can also be created with the `rep()` function which lets you repeat the contents. There are two arguments: `times` which controls how many times to repeat the entire input, and `each` which controls how many times to repeat each element if the input is a vector. You can specify either or both of these arguments.^[`rep()` is actually simultaneously an extremely useful and also extremely infuriating function, due to the bafflingly nonintuitive design of its arguments. See Hadley Wickham's [thoughtful diatribe](https://design.tidyverse.org/cs-rep.html) on the matter for more.] Note `rep()` can be used to repeat other objects too, not just numbers.


``` r
# repeat a single number
rep(2, 5)
```

```
[1] 2 2 2 2 2
```

``` r
# repeat a vector, specifying both times and each
rep(1:3, times = 3, each = 4)
```

```
 [1] 1 1 1 1 2 2 2 2 3 3 3 3 1 1 1 1 2 2 2 2 3 3 3 3 1 1 1 1 2 2 2 2 3 3 3 3
```

``` r
# you can also let times be a vector, as well as repeat other objects
rep(c(TRUE, FALSE), times = c(2, 4))
```

```
[1]  TRUE  TRUE FALSE FALSE FALSE FALSE
```

Finally, you can mix and match all these constructors, using a combination of `c()`, `:`, `seq()`, and `rep()` to your heart's content.


``` r
rep(c(1, 3, 7:9, seq(10, 12, by = 0.5)), each = 2)
```

```
 [1]  1.0  1.0  3.0  3.0  7.0  7.0  8.0  8.0  9.0  9.0 10.0 10.0 10.5 10.5 11.0 11.0
[17] 11.5 11.5 12.0 12.0
```




## Multiple vectors + vector recycling


It may not surprise you to learn all these vectorized operations also work on multiple vectors! If the vectors aren't the same length, **the shorter vectors will be repeated** until they match the length of the longest vector. This is called [**recycling**](https://www.geeksforgeeks.org/vector-recycling-in-r). Example:


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
[1] -2  0  2  4  6  8
```

``` r
# take powers, again one element at a time from each vector
x2^x1
```

```
[1]   1  -1   0   1  16 243
```

``` r
# take differences, one element at a time, recycling y
x1 - y
```

```
[1] -1 -1 -1  2  2  2
```

``` r
# log y with x1+2 as base, again recycling y
log(y, base = x1 + 2)
```

```
[1] 0.0000000 0.6309298 0.7924813 0.0000000 0.3868528 0.5645750
```

``` r
# more complex operation that recycles multiple vectors,
# as well as some numbers (which are just length 1 vectors)
2^abs(x1 * z) - x2^y - median(data)
```

```
[1] -1 -3  0  3  8  1
```

``` r
# these also work with other numeric/logical functions we've seen so far
# here, left side is a length 6 vector, right side is a length 2 vector,
# so right side is recycled three times then compared with left
x2 <= atan(z) * mean(x1)
```

```
[1]  TRUE  TRUE FALSE  TRUE FALSE FALSE
```

:::{.note}
In this class, **you should *never* need a for loop** for any exercises (hence why it's considered a bonus topic and not covered in the notes but instead left as optional additional reading).

Instead, ***always* look for a solution using vectorized operations**. In R, vectorized operations are basically always [MUCH faster than for loops](https://datakuity.com/2018/01/17/for-loop-vs-vectorization-in-r), due to low-level parallelization optimizations.
:::




## `%in%` (Membership)


One notable exception to all this is the [`%in%`{.R}](https://rdrr.io/r/base/match.html) operator, which only "vectorizes" on the left side. For example, suppose we want to know which elements of `z` are in `x1`. Here's how:


``` r
z %in% x1
```

```
[1] FALSE  TRUE
```

If you want to ask which elements of `z` are NOT in `x1`, you must prepend the expression with `!` to negate it:


``` r
!z %in% x1
```

```
[1]  TRUE FALSE
```

Note the difference between this and `z == x1`, which recycles `z`, *then* checks element-wise equality:


``` r
z == x1
```

```
[1] FALSE  TRUE FALSE FALSE FALSE FALSE
```

This is another common point of confusion for first time R users. Make sure you understand the **difference between checking vector membership**, i.e. if each element of one vector is also contained *somewhere* in another vector, **vs checking element-by-element equality**, i.e. checking if the 1^st^ elements are the same, and the 2^nd^ elements are the same, and the 3^rd^ elements are the same, etc. (possibly with recycling). See [this StackOverflow page](https://stackoverflow.com/a/42637186/25278020) for more examples.


:::{.note}
Going forward, we will continue to use vectorized functions and vector recycling in code examples, sometimes without drawing attention to it, for sake of brevity. Pretty soon, these concepts should also feel like second nature to you!
:::




## Vector subsetting


Let's also quickly cover vector subsetting. In R, there are many ways to extract a subset (i.e. just a portion) of a vector. There are 2 important things to remember throughout R when subsetting objects:

 1. **R indexes from 1, not 0**. In other words, R starts counting the position of objects from 1.
 2. **Bounds are inclusive**. In other words, R generally includes both start and end bounds when subsetting.

Knowing this, let's learn subsetting with some examples. A pair of useful built-in objects are the vectors [`letters`{.R}](https://rdrr.io/r/base/Constants.html) and [`LETTERS`{.R}](https://rdrr.io/r/base/Constants.html), which contain respectively the 26 lowercase and uppercase letters of the English alphabet. These letters make up a character vector (which we will discuss in detail in the next section).


``` r
letters
```

```
 [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t"
[21] "u" "v" "w" "x" "y" "z"
```

You can extract elements from a vector with the `[]` operator, giving either a vector of numeric positions, a vector of `TRUE`/`FALSE` values, or a negative vector for exclusions (i.e. anything *except*). Examples:


``` r
# giving numeric positions of desired elements
# remember numbers are numeric vectors of length 1
letters[1]
```

```
[1] "a"
```

``` r
# of course this also works with longer vectors
letters[5:10]
```

```
[1] "e" "f" "g" "h" "i" "j"
```

``` r
# naturally you can use more complex syntax if needed,
# as long as the result is a numeric vector,
# repeating indices give duplicate values
letters[c(1, 24:26, rep(5, 8))]
```

```
 [1] "a" "x" "y" "z" "e" "e" "e" "e" "e" "e" "e" "e"
```

``` r
# you can also use a logical vector, here we check if
# each position is even, returning every second letter
letters[1:26 %% 2 == 0]
```

```
 [1] "b" "d" "f" "h" "j" "l" "n" "p" "r" "t" "v" "x" "z"
```

``` r
# logical vectors will be recycled if necessary, so this also works
letters[c(FALSE, TRUE)]
```

```
 [1] "b" "d" "f" "h" "j" "l" "n" "p" "r" "t" "v" "x" "z"
```

``` r
# using negative vectors is like saying "anything EXCEPT"
letters[-1]
```

```
 [1] "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u"
[21] "v" "w" "x" "y" "z"
```

``` r
# again, this also works with vectors of negatives
letters[-1:-10]
```

```
 [1] "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"
```

``` r
# of course this is equivalent to
letters[-(1:10)]
```

```
 [1] "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"
```

``` r
# note the parentheses there, without it you get -1,0,1,...,10
# which raises an error (what we want is -1,-2,...,-10)
# this is because positive and negative position syntax cannot be mixed
letters[-1:10]
```

```
Error in letters[-1:10] : only 0's may be mixed with negative subscripts
```




## Sorting/reordering


Sometimes, you may need to sort/reorder vectors. We already saw in the previous section you can reorder vectors by subsetting with a vector of positions. If the vector of positions exhausts the vector without repeating (i.e. returns each element of the vector exactly once), the result is a reordering of the vector.


``` r
# defining a new data2 vector to use for examples,
# trust me, this will REALLY help clarify what's happening in a minute
data2 <- data * 10
data2
```

```
[1] 30 60 60 20 40 10 50
```

``` r
# ok, now let's proceed with the demos, first up:
# manual reordering, e.g. swapping the first and last elements
n <- length(data2)
data2[c(n, 2:(n-1), 1)]
```

```
[1] 50 60 60 20 40 10 30
```

You can of course also have R sort a vector for you. There are two main functions for sorting: `sort()`, which does what you expect and returns a vector with the elements rearranged from lowest to highest (unless you set the argument `decreasing = TRUE` which does the opposite); and `order()`, which simply returns the order the elements would go in (i.e. a vector of positions where they belong) if they were to be sorted lowest to highest (again, unless you set `decreasing = TRUE`).


``` r
# simply sort the data in ascending order
sort(data2)
```

```
[1] 10 20 30 40 50 60 60
```

``` r
# sort in descending order
sort(data2, decreasing = TRUE)
```

```
[1] 60 60 50 40 30 20 10
```

``` r
# return the order of positions that WOULD sort it
order(data2)
```

```
[1] 6 4 1 5 7 2 3
```

``` r
# passing this as a subsetting vector gives the sorted vector
data2[order(data2)]
```

```
[1] 10 20 30 40 50 60 60
```

A final function that is sometimes handy is the `rev()` function, which reverses the vector.


``` r
# reverse the vector
rev(data2)
```

```
[1] 50 10 40 20 60 60 30
```


:::{.note}
In general, **most R operations do NOT change the input object in place**. E.g. `sort(data2)` returns a COPY of `data2` with the elements sorted; it does NOT actually change `data2`. This is true for most functions in R, with few exceptions. For example, observe:

``` r
# original data2 vector
data2
```

```
[1] 30 60 60 20 40 10 50
```

``` r
# sort data2
sort(data2)
```

```
[1] 10 20 30 40 50 60 60
```

``` r
# is it changed?
data2
```

```
[1] 30 60 60 20 40 10 50
```
If you want an object to be updated in place, you should explicitly tell R to overwrite it again with the assignment `<-` operator, like this:

``` r
# overwrite data2 with the sorted copy (discouraged syntax)
data2 <- sort(data2)
# now it's changed
data2
```

```
[1] 10 20 30 40 50 60 60
```
It's often considered bad practice to overwrite input like this, since it can be destructive and, if not used with caution, can more easily lead to errors down the road. **We recommend whenever possible writing the output to a new object instead**, like this:

``` r
# save sorted data2 to new object (encouraged syntax)
data2_sorted <- sort(data2)
data2_sorted
```

```
[1] 10 20 30 40 50 60 60
```
In general, R inputs and outputs are totally independent objects with no special "connections".^[Put another way, R passes by value not reference, and copies are usually deep not shallow. Yes this can be very inefficient, but it's also arguably more user-friendly and intuitive to less technical users, which is by design.]. If you want an operation to be saved, **make sure to remember to assign the output to something!**
:::




## Character vectors


The [`letters`{.R}](https://rdrr.io/r/base/Constants.html) vector in the last section was one example of a **character vector**. You can create a character vector also with `c()` or `rep()` which we've seen before. When creating characters, you can use either the single [`'`]{.k} or double [`"`]{.k} quote character, no difference.


``` r
# creating a demo character vector, e.g. these are my friends!
friends <- c("Alice", "Bob", "Charlie", "Donny", "Emmy",
             "Francine", "Genevieve", "Heinemann")
friends
```

```
[1] "Alice"     "Bob"       "Charlie"   "Donny"     "Emmy"      "Francine" 
[7] "Genevieve" "Heinemann"
```

``` r
# you can also use rep, e.g. I can assign my friends into 2 groups
groups <- rep(LETTERS[1:2], time = 4)
groups
```

```
[1] "A" "B" "A" "B" "A" "B" "A" "B"
```




### Basic string functions


Base R has a number of common functions for working with strings: `nchar()` for getting the number of characters, `tolower()`/`toupper()` to convert case, `substr()` for extracting substrings, `paste()`/`paste0()` to concatenate (e.g. "glue" together) strings, and `strrep()` for repeating the characters in a string.


``` r
# get the number of characters in each name
nchar(friends)
```

```
[1] 5 3 7 5 4 8 9 9
```

``` r
# convert names to all upper or all lower
toupper(friends)
```

```
[1] "ALICE"     "BOB"       "CHARLIE"   "DONNY"     "EMMY"      "FRANCINE" 
[7] "GENEVIEVE" "HEINEMANN"
```

``` r
tolower(friends)
```

```
[1] "alice"     "bob"       "charlie"   "donny"     "emmy"      "francine" 
[7] "genevieve" "heinemann"
```

``` r
# get the first 3 characters of each name
substr(friends, 1, 3)
```

```
[1] "Ali" "Bob" "Cha" "Don" "Emm" "Fra" "Gen" "Hei"
```

``` r
# get the last 3 characters of each name;
# remember R always includes bounds, so to get the last three,
# we want to get n-2,n-1,n where n is the number of characters
# note this is done once again with our old friend, vectorization!
substr(friends, nchar(friends) - 2, nchar(friends))
```

```
[1] "ice" "Bob" "lie" "nny" "mmy" "ine" "eve" "ann"
```

``` r
# remove the first and last characters of each name
substr(friends, 2, nchar(friends) - 1)
```

```
[1] "lic"     "o"       "harli"   "onn"     "mm"      "rancin"  "eneviev" "eineman"
```

``` r
# paste can "glue" on single or (recycled) vectors of strings
paste(friends, "is my friend")
```

```
[1] "Alice is my friend"     "Bob is my friend"       "Charlie is my friend"  
[4] "Donny is my friend"     "Emmy is my friend"      "Francine is my friend" 
[7] "Genevieve is my friend" "Heinemann is my friend"
```

``` r
paste("My friend", friends, "is in group", groups)
```

```
[1] "My friend Alice is in group A"     "My friend Bob is in group B"      
[3] "My friend Charlie is in group A"   "My friend Donny is in group B"    
[5] "My friend Emmy is in group A"      "My friend Francine is in group B" 
[7] "My friend Genevieve is in group A" "My friend Heinemann is in group B"
```

``` r
# paste0(...) is a shortcut for paste(..., sep="")
# sep sets the separator between each string (default: a space " ")
paste0(friends, "123")
```

```
[1] "Alice123"     "Bob123"       "Charlie123"   "Donny123"     "Emmy123"     
[6] "Francine123"  "Genevieve123" "Heinemann123"
```

``` r
paste(friends, "123", sep = "_")
```

```
[1] "Alice_123"     "Bob_123"       "Charlie_123"   "Donny_123"     "Emmy_123"     
[6] "Francine_123"  "Genevieve_123" "Heinemann_123"
```

``` r
# paste also has an argument called collapse, which sets a separator,
# then uses that separator to collapse the vector into a single string
paste(friends, collapse = ", ")
```

```
[1] "Alice, Bob, Charlie, Donny, Emmy, Francine, Genevieve, Heinemann"
```

``` r
# repeat characters in each string a set number of times
strrep(friends, 3)
```

```
[1] "AliceAliceAlice"             "BobBobBob"                  
[3] "CharlieCharlieCharlie"       "DonnyDonnyDonny"            
[5] "EmmyEmmyEmmy"                "FrancineFrancineFrancine"   
[7] "GenevieveGenevieveGenevieve" "HeinemannHeinemannHeinemann"
```

``` r
# of course, this can also be vectorized!
strrep(friends, 1:8)
```

```
[1] "Alice"                                                                   
[2] "BobBob"                                                                  
[3] "CharlieCharlieCharlie"                                                   
[4] "DonnyDonnyDonnyDonny"                                                    
[5] "EmmyEmmyEmmyEmmyEmmy"                                                    
[6] "FrancineFrancineFrancineFrancineFrancineFrancine"                        
[7] "GenevieveGenevieveGenevieveGenevieveGenevieveGenevieveGenevieve"         
[8] "HeinemannHeinemannHeinemannHeinemannHeinemannHeinemannHeinemannHeinemann"
```




### Pattern string functions


There are also functions for working with patterns. You don't need to master these functions, but a few basic demos of them may prove helpful. Primarily, we have `grep()`/`grepl()` for pattern matching, and `sub()`/`gsub()` for pattern replacing. The prefix/suffix matching `startsWith()`/`endsWith()` are also occasionally useful.

It should be noted the patterns below are all fairly short (mostly one single character) for simplicity of example, but patterns can be as many characters long as necessary.


``` r
# which friends (by position) have a lowercase "e" in their name?
grep("e", friends)
```

```
[1] 1 3 6 7 8
```

``` r
# alternatively, return a TRUE/FALSE vector result instead for each element
grepl("e", friends)
```

```
[1]  TRUE FALSE  TRUE FALSE FALSE  TRUE  TRUE  TRUE
```

``` r
# you can use either one to subset the original vector to get actual names
friends[grep("e", friends)]
```

```
[1] "Alice"     "Charlie"   "Francine"  "Genevieve" "Heinemann"
```

``` r
# you can disable case sensitivity, which adds Emmy to the results
friends[grep("e", friends, ignore.case = TRUE)]
```

```
[1] "Alice"     "Charlie"   "Emmy"      "Francine"  "Genevieve" "Heinemann"
```

``` r
# you can use sub() to replace patterns
# here we can create a set of variant spellings, changing -y to -ie
sub("y", "ie", friends)
```

```
[1] "Alice"     "Bob"       "Charlie"   "Donnie"    "Emmie"     "Francine" 
[7] "Genevieve" "Heinemann"
```

``` r
# sub() can only replace once (inside each element),
# but gsub() can replace ALL occurrences
sub("n", "m", friends)
```

```
[1] "Alice"     "Bob"       "Charlie"   "Domny"     "Emmy"      "Framcine" 
[7] "Gemevieve" "Heimemann"
```

``` r
gsub("n", "m", friends)
```

```
[1] "Alice"     "Bob"       "Charlie"   "Dommy"     "Emmy"      "Framcime" 
[7] "Gemevieve" "Heimemamm"
```

``` r
# which friends have a name that endsWith() "y"?
# (startsWith() does the opposite)
endsWith(friends, "y")
```

```
[1] FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE FALSE
```

Each of these functions (as well as several more listed in the `grep()` help page), actually accept more complex pattern syntax for the search pattern. This advanced search pattern syntax is called "regular expressions" or "regex" for short. You can do things like match groups of characters, match repeated characters or groups, match to specific locations in words or sentences, and more.

In this class we will NOT cover regular expressions to any real detail again due to limited time, but feel free to explore [this cheat sheet](https://paulvanderlaken.com/wp-content/uploads/2017/08/r-regular-expression-cheetsheat.pdf) as well as [these](https://paulvanderlaken.com/2017/10/03/regular-expressions-in-r-part-1-introduction-and-base-r-functions) [two](https://bookdown.org/rdpeng/rprogdatascience/regular-expressions.html) additional articles on the matter.




### Additional stringr functions


[stringr](https://stringr.tidyverse.org), one of the [core Tidyverse](https://www.tidyverse.org/packages/#core-tidyverse) packages, contains an alternative set of functions for working with strings. Many of these are similar in purpose to base R versions (although some have subtle differences). E.g. `str_length()` is the same as `nchar()`, `str_to_lower()`/`str_to_upper()` replicate `tolower()`/`toupper()`, `str_replace()` is similar to `sub()`, `str_sub()` extends `substr()`, etc. Here's a full list of these [doppelgänger stringr functions](https://stringr.tidyverse.org/articles/from-base.html).

However, there are a few useful stringr functions that do not have counterparts in base R (or at least whose counterparts require much more complex expressions). Here is a *small* curation of them.


``` r
# since stringr is a "core" tidyverse package,
# you can load it (+other core packages) with library(tidyverse)
# you can also just load stringr by itself if that's all you need
library(stringr)
```


``` r
# count how many times a pattern occurs
str_count(friends, "e")
```

```
[1] 1 0 1 0 0 1 4 2
```

``` r
# change strings to title case, i.e. first letter uppercase, all else lower
str_to_title(toupper(friends))
```

```
[1] "Alice"     "Bob"       "Charlie"   "Donny"     "Emmy"      "Francine" 
[7] "Genevieve" "Heinemann"
```

``` r
# "pad" a vector of strings to a constant length
str_pad(friends, width = 12, side = "right", pad = ".")
```

```
[1] "Alice......." "Bob........." "Charlie....." "Donny......." "Emmy........"
[6] "Francine...." "Genevieve..." "Heinemann..."
```




### Comparing strings


Strings, like numbers, can also be logically compared in R using the same `==`, `!=`, `<`, `<=`, `>`, `>=` operators (also all vectorized of course). Checking equality is self-explanatory, and **inequalities evaluate by dictionary sorting order**, i.e. what order they might appear in in a dictionary, except generalized to include not just letters but also number and symbols.

This snippet of code below (which you do NOT have to worry about learning right now) prints the "dictionary" sorting order for all ordinary keyboard characters typable on a standard US English keyboard layout in ascending order.


``` r
# print out the result
cat(
  # sort the characters
  sort(
    # flatten list output to a big vector of characters
    unlist(
      # split symbols into individual characters
      strsplit(
        # make a vector of all ordinary keyboard characters
        c(letters, LETTERS, 0:9, "`~!@#$%^&*()_+-=[]\\{}|;':\",./<>? "),
        ""
      )
    )
  ),
  sep = ""
)
```

<pre>
 _-,;:!?.'"()[]{}@*/\&#%`^+<=>|~$0123456789aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ
</pre>

:::{.note}
This ordering depends on the platform; the above order should be for *nix systems (i.e. Mac/Linux). Windows orders by `` '- !"#$%&()*,./:;?@[\]^_`{|}~+<=>0123...yYzZ`` instead.
:::

Characters are sorted by their order in this sequence of characters, with characters earlier in the sequence being "less than" later characters. Strings with the same first character will be sorted by the second character; if the second character is also the same, they will be sorted by the third, and so on (just like normal dictionaries)

Note however that nothingness, i.e. the absence of a character (such as when a string ends), comes before any character, which makes sense because otherwise "app" would appear after "apple". Below is a series of examples demonstrating string sorting.


``` r
"apple" == "apple"
```

```
[1] TRUE
```

``` r
# note equality also implies both >= and <=
"apple" >= "apple"
```

```
[1] TRUE
```

``` r
# remember R is case sensitive, so these are different
"apple" != "Apple"
```

```
[1] TRUE
```

``` r
# comparing apples and oranges
"apple" == "orange"
```

```
[1] FALSE
```

``` r
"apple" < "orange"
```

```
[1] TRUE
```

``` r
# numbers and symbols can also dictionary-sort like letters
# note these numeral characters have NO numeric meaning!
"42" < "43"
```

```
[1] TRUE
```

``` r
"1 pm" < "2 pm"
```

```
[1] TRUE
```

``` r
"STAT240" < "STAT340"
```

```
[1] TRUE
```

``` r
# however symbols come before numbers, thus
"1,000" < "1000"
```

```
[1] TRUE
```

``` r
"-3.00" < "-3.14"
```

```
[1] TRUE
```

``` r
# and remember ending a string comes before any other character
"-3" < "-3.14"
```

```
[1] TRUE
```

Using our newfound wisdom, we can now conclusively settle some age old debates!


``` r
# what is the greatest state? (head prints the first 6)
head(sort(state.name, decreasing = TRUE))
```

```
[1] "Wyoming"       "Wisconsin"     "West Virginia" "Washington"    "Virginia"     
[6] "Vermont"      
```

``` r
# note by definition of inequalities, we can also use min/max
# which will find the first and last alphabetically
c(min(state.name), max(state.name))
```

```
[1] "Alabama" "Wyoming"
```

``` r
# is the pen mightier than the sword?
"pen" > "sword"
```

```
[1] FALSE
```

``` r
# is Windows better than Mac?
"Windows" > "Mac"
```

```
[1] TRUE
```

``` r
# and most importantly, did the chicken come before the egg?
"chicken" < "egg"
```

```
[1] TRUE
```



### Bonus: ordered data {#ordered-data}

Ordered categorical data (also called ordinals) is extremely common, so it's worth briefly mentioning here, even if it's considered mostly outside the scope of this course. If you have characters where a natural ordering is present, it's recommended to use `factor()` to convert it, setting `ordered = TRUE` and using `levels = c(...)` to specify the ordering of the levels in ascending order (low to high).

For example, suppose you have the following data vector of dosage level data for some subjects:


``` r
doses <- c("Low", "High", "Medium", "Low", "High")
```

Naturally, this should be ordered Low < Medium < High but it currently has no ordering structure. We can fix it like this:


``` r
doses <- factor(doses, levels = c("Low", "Medium", "High"), ordered = TRUE)
doses
```

```
[1] Low    High   Medium Low    High  
Levels: Low < Medium < High
```

You can see now it has an ordering structure and R understands how the levels compare to each other. This ordering will also be automatically respected in later plots and analysis, as you'll soon see.




## Coercion (converting types) {#coercion}


Sometimes, we read data in and it may need to be converted before it's usable. E.g. let's say you read in a list of prices from some catalog and you get the following character vector:


``` r
prices_raw <- c("$1,000", "$1,500", "$850", "$2,000")
prices_raw
```

```
[1] "$1,000" "$1,500" "$850"   "$2,000"
```

Since R doesn't natively understand dollar signs or comma grouping, this must start as a character vector. You can check the type of a vector by using the `is.numeric()`, `is.logical()`, `is.character()` functions.


``` r
is.character(prices_raw)
```

```
[1] TRUE
```

If the data has been "cleaned-up" then you can coerce (i.e. convert) the vector into other types with the corresponding `as.numeric()`, `as.logical()`, `as.character()` functions. In this case however, the data is not yet "cleaned-up" so this coercion operation will give an error.


``` r
as.numeric(prices_raw)
```

``` warning
Warning: NAs introduced by coercion
```

```
[1] NA NA NA NA
```

In R, it's important to remember **not to reinvent the wheel**; most actions already have an associated package/function, and it's probably better than what you can write (if you're a beginner). Here, it may be tempting to write your own parsing function by using `sub()`/`gsub()` to replace the dollar and commas then coerce, but there's a better option.

[readr](https://readr.tidyverse.org/index.html) is another one of the [core Tidyverse](https://www.tidyverse.org/packages/#core-tidyverse) packages. It's designed to make ingesting data as easy as possible.

One set of readr functions useful here are the `parse_number()` and `parse_logical()` functions (converting to a string is trivial and can basically always be done using the `as.character()` function). These functions are quite smart and can ignore extra characters and just extract the relevant numerical info.


``` r
# since readr is also a "core" tidyverse package,
# you can use library(tidyverse) or library(readr)
library(readr)
```

``` r
prices <- parse_number(prices_raw)
prices
```

```
[1] 1000 1500  850 2000
```

``` r
is.numeric(prices)
```

```
[1] TRUE
```

This will also work with things like percent symbols, but note it simply ignores the symbol instead of treating it as dividing by 100.


``` r
# demonstrate parsing percentages
parse_number(c("30%", "100%", "1,500%"))
```

```
[1]   30  100 1500
```

See the help page for `parse_number()` for more examples and usage notes.



## Date vectors

Finally, let's talk about date vectors (note we are not talking about date+time values, just dates). In R, dates are actually stored as a number, representing the [number of days after January 1^st^ 1970](https://rdrr.io/r/base/Dates.html), which is used as a reference date called the [Epoch](https://en.wikipedia.org/wiki/Epoch_(computing)).

Before we run some examples, we're going to load in the [lubridate](https://lubridate.tidyverse.org/) package, which is designed to make working with dates super easy and is also a part of Tidyverse. However, it's not actually a core package, which means **it MUST be loaded in separately** each time you wish to use it!


``` r
library(lubridate)
```



Ok, let's start the demo by creating a date object. Let's use today's date (which is Nov 3, 2024 as of [last compile](https://github.com/bwu62/stat240-revamp/commits/master)) as an example. The `today()` function is handy here.


``` r
# create today as an example date object
date <- today()
date
```

```
[1] "2024-11-03"
```

We can see that even though our date object has `"Date"` class, it actually has `"double"` type, which means behind the scenes, it's secretly stored as a number.^[The distinction between class, type, and mode (which we haven't even mentioned and won't ever discuss) is highly technical to the mechanics of R and not worth concerning yourself over. If you're dying of curiosity, I recommend this excellent video on the matter: <https://youtu.be/RwEzWZA9uTw>.] If you `unclass()` the object, i.e. strip away the `"Date"` property, you can see it's just the number 20030 underneath, and you can check that in fact Nov 3, 2024 is indeed [20030 days after Jan 1 1970](https://www.wolframalpha.com/input?i=20030+days+after+Jan+1+1970).


``` r
# looks like a date
class(date)
```

```
[1] "Date"
```

``` r
is.Date(date) & !is.numeric(date)
```

```
[1] TRUE
```

``` r
# but it's secretly a number underneath!
unclass(date)
```

```
[1] 20030
```
``` r
# we can reverse this too, start with a number,
# then change the class to "Date", and voila!
x <- 20030
class(x) <- "Date"
x
```

```
[1] "2024-11-03"
```

:::{.note}
R conforms to [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601) standards, i.e. **dates ALWAYS show as `"YYYY-MM-DD"`** (even though they're stored numerically). This is arguably the best format for dates, because it's the unique format where [chronological order and lexicographical order are identical](https://en.wikipedia.org/wiki/ISO_8601#General_principles), which is an extremely useful property.

Also note despite `date` appearing to be a character, it is NOT a character. Using `identical()` (which compares if two objects are the same) will show this to be false. Furthermore, `as.numeric()` confirms `date` converts to 20030 as expected, whereas the string ``"2024-11-03"`` cannot be converted and returns `NA`.


``` r
date
```

```
[1] "2024-11-03"
```

``` r
is.character(date)
```

```
[1] FALSE
```
``` r
identical(date, "2024-11-03")
```

```
[1] FALSE
```
``` r
c(as.numeric(date), as.numeric("2024-11-03"))
```

``` warning
Warning: NAs introduced by coercion
```

```
[1] 20030    NA
```

This is just to warn you that **even though they may print similarly, date objects and date-like strings are *NOT* the same**, so to avoid errors and unexpected behavior, make sure you properly convert all date data to be true date objects.
:::



### Parsing dates

In some cases (specifically, if dates in a dataset are already represented in standard ISO-8601 format) R will automagically parse (i.e. convert) the dates for you. In other cases, you may need to manually parse them yourself. We will continue to use lubridate, since it has the most robust and user-friendly functions for working with dates.

In lubridate, the [parser functions](https://lubridate.tidyverse.org/reference/ymd.html) `mdy()`, `dmy()`, `ymd()` (as well as their rarer siblings `ydm()`, `myd()`, and `dym()`) are used to parse date data into proper date objects. The **only difference between these functions is the *order* they expect to see date components**, e.g. `mdy()` is used when the data is ordered month, day, then year (which is common in the US), and `dmy()` is used when the date data is data is ordered day, month, then year (which is generally preferred outside the US). These functions are **extremely robust and automagically recognize a wide range of formats**, and of course they're all vectorized! Here's a few examples:


``` r
mdy(c(
  "11/3/24, 11-03-2024, 110324, Nov 3 '24, Sunday, November 3rd, 2024"
))
```

```
[1] "2024-11-03" "2024-11-03" "2024-11-03" "2024-11-03" "2024-11-03"
```

``` r
dmy(c(
  "3/11/24, 03-11-2024, 031124, 3 Nov '24, Sunday, 3rd of November, 2024"
))
```

```
[1] "2024-11-03" "2024-11-03" "2024-11-03" "2024-11-03" "2024-11-03"
```

As you can see, you just need to tell R which order to expect the date components and it will handle the rest! We only demonstrated the `mdy()` and `dmy()` functions here since they are by far the most common formats, but the other functions all behave the same.

One last parser. Sometimes data gives dates as a decimal, e.g. `` 2024-11-03 `` would be `` 2024.839 `` since it's the 308th day of the year which means it's `` (308-1)/366*100%=83.9% `` of the way into the year.^[The -1 in the numerator is due to the date being treated as 12am midnight, hence the 308th day, `` 2024-11-03 `` is just about to start, so only 308 days have passed so far.] R also has a dedicated function for this. `date_decimal()` converts the decimal to a date+time object, which we can then round to the nearest date with [`round_date(...,unit="day")`{.R}](https://lubridate.tidyverse.org/reference/round_date.html) and drop the time component with `date()` which converts date+time objects to pure date objects (again, we are not covering date+time objects due to complexity & limited time).

``` r
# generate a vector of elapsed 21st century dates
# in decimal format for demo purposes
# (here, runif uniformly samples 4 numbers from 2000 to 2024.839)
dates2 <- runif(4, 2000, 2024.839)
dates2
```

```
[1] 2006.595 2009.243 2014.229 2022.559
```

``` r
# convert decimals to dates
dates2 <- date(round_date(date_decimal(dates2), unit = "day"))
dates2
```

```
[1] "2006-08-06" "2009-03-31" "2014-03-26" "2022-07-24"
```

There is also a reverse function `decimal_date()` that converts a date back into a decimal.


``` r
decimal_date(dates2)
```

```
[1] 2006.595 2009.244 2014.230 2022.559
```



### Aside: R's calendar

Quick aside. **R has an *extremely* robust calendar**, so you don't need to worry about "babysitting" R. Notably, R knows exactly [which years are leap and which aren't](https://www.mathsisfun.com/leap-years.html).


``` r
# the most recent leap year is 2024, since it's divisible by 4
mdy("Feb 29, 2024")
```

```
[1] "2024-02-29"
```

``` r
# however, years like 1900 or 2100 are not leap,
# since they're also divisible by 100
mdy(c("Feb 29, 1900", "Feb 29, 2100"))
```

``` warning
Warning: 2 failed to parse.
```

```
[1] NA NA
```

``` r
# but 2000 is leap, since it's also divisible by 400
mdy("Feb 29, 2000")
```

```
[1] "2000-02-29"
```

``` r
# you can also use the leap_year() function instead
# is the year that a given date is in leap?
leap_year(date)
```

```
[1] TRUE
```

``` r
# which of these given years are leap?
leap_year(c(1900, 2000, 2024, 2100))
```

```
[1] FALSE  TRUE  TRUE FALSE
```

Fun fact: R's calendar is more rigorous than Excel's calendar, since it correctly treats 1900 as non-leap, [unlike Excel](https://learn.microsoft.com/en-us/office/troubleshoot/excel/wrongly-assumes-1900-is-leap-year). This is of course probably immaterial in the 21^st^ century, I just think it's an amusing bit of trivia.




### Get/set components

Lubridate provides many get/set functions (often called getters and setters) for getting and setting different components (i.e. properties) associated with a date. Some common ones include `year()`, `month()`, `day()`, `wday()` (for day of the week), and `quarter()`.

Let's continue using the generated `dates2` object above, except I will add today `` 2024-11-03 `` into the vector as the first element.


``` r
# add in today, then print (to remind us what it contains)
dates2 <- c(date, dates2)
dates2
```

```
[1] "2024-11-03" "2006-08-06" "2009-03-31" "2014-03-26" "2022-07-24"
```

``` r
# extract the year, month, day, wday, quarter
year(dates2)
```

```
[1] 2024 2006 2009 2014 2022
```

``` r
month(dates2)
```

```
[1] 11  8  3  3  7
```

``` r
day(dates2)
```

```
[1]  3  6 31 26 24
```

``` r
# wday starts counting from Sunday, i.e. 1=Sunday, 2=Monday, etc.
wday(dates2)
```

```
[1] 1 1 3 4 1
```

``` r
quarter(dates2)
```

```
[1] 4 3 1 1 3
```

Some functions (where it makes sense) like `month()` and `wday()` have additional arguments like `label` and `abbr` to control the output format when you have the option to output names instead of numbers. Again, I recommend you briefly check the help page of every new function you learn for additional options.


``` r
# output month as abbreviated names instead (abbr = TRUE by default)
month(dates2, label = TRUE)
```

```
[1] Nov Aug Mar Mar Jul
12 Levels: Jan < Feb < Mar < Apr < May < Jun < Jul < Aug < Sep < Oct < ... < Dec
```

``` r
# output day of week as full, unabridged names
wday(dates2, label = TRUE, abbr = FALSE)
```

```
[1] Sunday    Sunday    Tuesday   Wednesday Sunday   
7 Levels: Sunday < Monday < Tuesday < Wednesday < Thursday < ... < Saturday
```


:::{.note}
If your system is in a different language, you may see the code above output non-English names for the months and days of the week. This is because R uses your [system's locale](https://en.wikipedia.org/wiki/Locale_(computer_software)) to determine how to output some values. This is extremely easy to fix; simply run the line of code below ONCE in your console, then close and restart Rstudio for the changes to permanently take effect.


``` r
write('\ninvisible(Sys.setlocale("LC_TIME","C"))\n',"~/.Rprofile",1,T)
```

How does this work? It adds the line `invisible(Sys.setlocale("LC_TIME","C"))` to your `"~/.Rprofile"` file, which is run every time R starts up. The added line invisibly sets the `"LC_TIME"` locale variable to `"C"`, which tells lubridate to use English for all outputs.
:::


The first line in each output above is the actual output names. The list of "levels" on each second line just shows the set of all possible values that could have been outputted. This return object is another example of an ["ordered factor"](https://r4ds.hadley.nz/factors). For our purposes this can mostly be treated as similar to a character/string vector. (If you want to do any string operations on the output, make sure to convert fully to character first with `as.character()`!)

These getters are extremely useful for both data cleaning as well as data visualization, since it can be much more pleasant to, for example, see a monthly breakdown as Jan, Feb, ..., Dec instead of 1, 2, ..., 12.

These same getters can also be used as "setters", i.e. used to set the components. For example:


``` r
# make a copy to use here, since this destroys the original vector
new_dates2 <- dates2
# change year of all dates to 2000
year(new_dates2) <- 2000
new_dates2
```

```
[1] "2000-11-03" "2000-08-06" "2000-03-31" "2000-03-26" "2000-07-24"
```

``` r
# of course this is also vectorized!
year(new_dates2) <- 2000:2004
new_dates2
```

```
[1] "2000-11-03" "2001-08-06" "2002-03-31" "2003-03-26" "2004-07-24"
```

This works with all the getters above, feel free to experiment more with this on your own. There are also several other getter/setter functions such as `qday()` for day of the quarter, `week()` for week number, and `semester()` for 1^st^ or 2^nd^ semester of the year.



### Date math

Since dates are represented internally as number of days since a reference point, doing math with dates turns out to be extremely easy. You can add/subtract days, make sequences, run logical comparisons, and even use some statistical summary functions.


``` r
# get tomorrow by adding +1 to today
date + 1
```

```
[1] "2024-11-04"
```

``` r
# what date was 1000 days ago?
date - 1000
```

```
[1] "2022-02-07"
```

``` r
# how many days has it been since y2k?
# note that subtracting dates gives a "difftime" class object
# you can convert this to a number using the familiar as.numeric()
as.numeric(date - mdy("1/1/00"))
```

```
[1] 9073
```
``` r
# make a sequence of dates from today to the end of the month
seq(date, mdy("11/30/24"), by = 1)
```

```
 [1] "2024-11-03" "2024-11-04" "2024-11-05" "2024-11-06" "2024-11-07" "2024-11-08"
 [7] "2024-11-09" "2024-11-10" "2024-11-11" "2024-11-12" "2024-11-13" "2024-11-14"
[13] "2024-11-15" "2024-11-16" "2024-11-17" "2024-11-18" "2024-11-19" "2024-11-20"
[19] "2024-11-21" "2024-11-22" "2024-11-23" "2024-11-24" "2024-11-25" "2024-11-26"
[25] "2024-11-27" "2024-11-28" "2024-11-29" "2024-11-30"
```
``` r
# make a sequence of every Sunday from today to the end of the year
seq(date, mdy("12/31/24"), by = 7)
```

```
[1] "2024-11-03" "2024-11-10" "2024-11-17" "2024-11-24" "2024-12-01" "2024-12-08"
[7] "2024-12-15" "2024-12-22" "2024-12-29"
```
``` r
# has independence day already happened this year?
mdy("7/4/24") <= date
```

```
[1] TRUE
```

``` r
# what is the earliest date in the dates2 vector?
min(dates2)
```

```
[1] "2006-08-06"
```

``` r
# organize dates2 in chronological order
sort(dates2)
```

```
[1] "2006-08-06" "2009-03-31" "2014-03-26" "2022-07-24" "2024-11-03"
```

``` r
# is today in dates2?
date %in% dates2
```

```
[1] TRUE
```

``` r
# some statistical functions can also be run on dates
# e.g. we can find the mean and median date of dates2
mean(dates2)
```

```
[1] "2015-06-30"
```

``` r
median(dates2)
```

```
[1] "2014-03-26"
```

``` r
# we can even find the standard deviation of dates,
# though this does NOT return a date itself but rather a number of days
sd(dates2)
```

```
[1] 2928.289
```



### Printing dates

As a final note, let's briefly discuss printing dates. You can use `format()` to print dates in a pretty way. Different ways of printing each component are represented using `%...` codes. Examples:


``` r
# print today as mm/dd/yy which is common in the US
format(date, "%m/%d/%y")
```

```
[1] "11/03/24"
```

``` r
# another way, slightly more written out
format(date, "%b %d, %Y")
```

```
[1] "Nov 03, 2024"
```

``` r
# fully written out, including weekday
format(date, "%A, %B %e, %Y")
```

```
[1] "Sunday, November  3, 2024"
```

A full list of these percent codes can be found in the help page of `strptime()`, a base R function for parsing date/time objects.
