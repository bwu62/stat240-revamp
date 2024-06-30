

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

There are LOTS of types of data that vectors can hold, from real to complex numbers, characters to raw byte-data, and even dates and times.^[Technically, there are only 6 fundamental, or ["atomic"](https://cran.r-project.org/doc/manuals/r-release/R-lang.html#:~:text=R%20has,%20table){target="_blank"} types, but some of these can represent multiple "classes" of objects. See the section on [Vectors](https://adv-r.hadley.nz/vectors-chap.html){target="_blank"} from Hadley Wickham's excellent "*Advanced R*" book for the minutiae. I know this footnote is overly pedantic and technical, but I don't want to incur the wrath of CS nerds.] In this class, we will only deal with the following 4 types of vectors:

 - **Numeric** vectors, which contain real numbers. Generally, R functions don't distinguish between integers and decimal numbers (also called "doubles" or "floats") so treat all numbers as decimal-valued real numbers. ^[For the CS students, R represents all numbers by default as double-precision floating-point numbers as per [IEC 60559/IEEE 754](https://en.wikipedia.org/wiki/IEEE_754){target="_blank"} specifications. There are no single precision values in R. You can force a number to be a [32-bit signed integer](https://rdrr.io/r/base/integer.html){target="_blank"} by adding an `L` to the end, e.g. `1L`, but this is extremely rare in data science and generally offers no real, tangible advantages.]
 - **Logical** vectors, which contain only `TRUE`/`FALSE` values. Usually, these arise from logical comparison operators or other functions that check if some condition is satisfied. Remember that in computations, TRUE becomes 1 and FALSE becomes 0. ^[Again, for the CS nerds, 0 in R is considered "falsy" and all other numbers are considered "truthy". E.g. try running `x & TRUE` for zero and non-zero x and observe the output.]
 - **Character** vectors, which contain characters (often also called "strings"). These are basically categorical or text data. E.g. you may have groups "A" and "B", or sex "Male" and "Female". You can even have sentences, paragraphs, or entire bodies of text in a character. We will only briefly touch on processing text data in this class. ^[CS people, looking at you again. Some languages distinguish between "character" type, which can only be just a single character; and "string" type, which are sequences of characters. In R, there is no such distinction; characters and strings are synonymous. Note this means you cannot "slice" through a string as if it's just a list of characters in R like some other languages.]
 - Lastly, we will also discuss **date** vectors, which are actually closely related to numeric vectors (more on this later). These are ubiquitous in data science and thus deserving of inclusion. ^[I don't have anything pedantic to add here, but all the other vectors got footnotes so I didn't want dates to feel left out :( ... <br/><br/> ...well ok, since you bothered to click this, I'll give you something. Dates in R, like in many other languages, are stored as [number of days after Jan 1^st^ 1970](https://rdrr.io/r/base/Dates.html){target="_blank"}, which is often ominously referred to as the "Epoch". Why 1/1/70? Because reportedly it ["*seemed to be as good as any*"](https://retrocomputing.stackexchange.com/a/25599){target="_blank"}. <br/><br/> This is why dates are basically numeric vectors with extra steps. However, like with anything, the devil's in the details, and learning to work efficiently with dates is not trivial.]
   - Note: we only cover dates themselves, not date + time values (also called datetime) since these are actually quite different data types and we only have so many lectures. ^[Similar-ish to dates, datetimes are often stored as a (possibly decimal) [number of seconds after midnight of Jan 1^st^ 1970](https://rdrr.io/r/base/DateTimeClasses.html){target="_blank"} called a POSIXct object, although R confusingly also has a whole other type of datetime object called POSIXlt where each date/time component is stored as an element of a [list](https://jennybc.github.io/purrr-tutorial/bk00_vectors-and-lists.html) (which is a whole other giant beast we don't even remotely have time to get into). See Hadley Wickham's page on [datetime](https://r4ds.hadley.nz/datetimes.html){target="_blank"} from his book "*R for Data Science*" for more info on datetime objects.]




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

Remember from section \@ref(r-specials) how any **math turns `TRUE` into 1 and `FALSE` into 0**? This turns out to be extremely useful. For example, we can use `sum()` to count how many values are even:


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


So far, we've only learned how to construct vectors by using the `c()` function, for example `data<-c(3,6,6,2,4,1,5)`. There are a few other common ways to construct them.

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

The `seq()` function does something similar, except it also has additional arguments `by` to specify the step size and `length.out` which specifies how many numbers to have in total (note: only ONE of these arguments can be set at a time).


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

Note the difference between this and `z == x1`, which recycles `z`, *then* checks element-wise equality:


``` r
z == x1
```

```
## [1] FALSE  TRUE FALSE FALSE FALSE FALSE
```

This is another common point of confusion for first time R users. Make sure you understand the **difference between checking vector membership**, i.e. if each element of one vector is also contained *somewhere* in another vector, **vs checking element-by-element equality**, i.e. checking if the 1^st^ elements are the same, and the 2^nd^ elements are the same, and the 3^rd^ elements are the same, etc. (possibly with recycling). See [this StackOverflow page](https://stackoverflow.com/a/42637186/25278020) for more examples.


:::{.note}
Going forward, we will continue to use vectorized functions and vector recycling in code examples, sometimes without drawing attention to it, for sake of brevity. Pretty soon, these concepts should also feel like second nature to you!
:::




### Vector subsetting


Let's also quickly cover vector subsetting. In R, there are many ways to extract a subset (i.e. just a portion) of a vector. There are 2 important things to remember throughout R when subsetting objects:

 1. **R indexes from 1, not 0**. In other words, R starts counting the position of objects from 1.
 2. **Bounds are inclusive**. In other words, R generally includes both start and end bounds when subsetting.

Knowing this, let's learn subsetting with some examples. A pair of useful built-in objects are the vectors [`letters`{.R}](https://rdrr.io/r/base/Constants.html) and [`LETTERS`{.R}](https://rdrr.io/r/base/Constants.html), which contain respectively the 26 lowercase and uppercase letters of the English alphabet. These letters make up a character vector (which we will discuss in detail in the next section).


``` r
letters
```

```
##  [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o"
## [16] "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"
```

You can extract elements form a vector with the `[]` operator, giving either a vector of numeric positions, a vector of `TRUE`/`FALSE` values, or a negative vector for exclusions (i.e. anything *except*). Examples:


``` r
# giving numeric positions of desired elements
# remember numbers are numeric vectors of length-1
letters[1]
```

```
## [1] "a"
```

``` r
# of course this also works with longer vectors
letters[5:10]
```

```
## [1] "e" "f" "g" "h" "i" "j"
```

``` r
# naturally you can use more complex syntax if needed,
# as long as the result is a numeric vector,
# repeating indices give duplicate values
letters[c(1, 24:26, rep(5, 8))]
```

```
##  [1] "a" "x" "y" "z" "e" "e" "e" "e" "e" "e" "e" "e"
```

``` r
# you can also use a logical vector, here we check if
# each position is even, returning every second letter
letters[1:26 %% 2 == 0]
```

```
##  [1] "b" "d" "f" "h" "j" "l" "n" "p" "r" "t" "v" "x" "z"
```

``` r
# logical vectors will be recycled if necessary, so this also works
letters[c(FALSE, TRUE)]
```

```
##  [1] "b" "d" "f" "h" "j" "l" "n" "p" "r" "t" "v" "x" "z"
```

``` r
# using negative vectors is like saying "anything EXCEPT"
letters[-1]
```

```
##  [1] "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p"
## [16] "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"
```

``` r
# again, this also works with vectors of negatives
letters[-1:-10]
```

```
##  [1] "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y"
## [16] "z"
```

``` r
# of course this is equivalent to
letters[-(1:10)]
```

```
##  [1] "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y"
## [16] "z"
```

``` r
# note the parentheses there, without it you get -1,0,1,...,10
# which raises an error (what we want is -1,-2,...,-10)
# this is because positive and negative position syntax cannot be mixed
letters[-1:10]
```

```
## Error in letters[-1:10] : only 0's may be mixed with negative subscripts
```




### Character vectors

The [`letters`{.R}](https://rdrr.io/r/base/Constants.html) vector in the last section was one example of a **character vector**. You can create a character vector also with `c()` or `rep()` which we've seen before. When creating characters, you can use either the single [`'`]{.k} or double [`"`]{.k} quote character, no difference.


``` r
# creating a demo character vector, e.g. these are my friends!
friends <- c("Alice", "Bob", "Charlie", "Donny", "Emmy", "Francine", "Genevieve", "Heinemann")
friends
```

```
## [1] "Alice"     "Bob"       "Charlie"   "Donny"     "Emmy"     
## [6] "Francine"  "Genevieve" "Heinemann"
```

``` r
# you can also use rep, e.g. I can assign my friends into 2 groups
groups <- rep(LETTERS[1:2], time = 4)
groups
```

```
## [1] "A" "B" "A" "B" "A" "B" "A" "B"
```


#### Basic string functions

Base R has a number of common functions for working with strings: `nchar()` for getting the number of characters, `tolower()`/`toupper()` to convert case, `substr()` for extracting substrings, `paste()`/`paste0()` to concatenate (e.g. "glue" together) strings, and `strrep()` for repeating the characters in a string.


``` r
# get the number of characters in each name
nchar(friends)
```

```
## [1] 5 3 7 5 4 8 9 9
```

``` r
# convert names to all upper or all lower
toupper(friends)
```

```
## [1] "ALICE"     "BOB"       "CHARLIE"   "DONNY"     "EMMY"     
## [6] "FRANCINE"  "GENEVIEVE" "HEINEMANN"
```

``` r
tolower(friends)
```

```
## [1] "alice"     "bob"       "charlie"   "donny"     "emmy"     
## [6] "francine"  "genevieve" "heinemann"
```

``` r
# get the first 3 characters of each name
substr(friends, 1, 3)
```

```
## [1] "Ali" "Bob" "Cha" "Don" "Emm" "Fra" "Gen" "Hei"
```

``` r
# get the last 3 characters of each name;
# remember R always includes bounds, so to get the last three,
# we want to get n-2,n-1,n where n is the number of characters
# note this is done once again with our old friend, vectorization!
substr(friends, nchar(friends) - 2, nchar(friends))
```

```
## [1] "ice" "Bob" "lie" "nny" "mmy" "ine" "eve" "ann"
```

``` r
# remove the first and last characters of each name
substr(friends, 2, nchar(friends) - 1)
```

```
## [1] "lic"     "o"       "harli"   "onn"     "mm"      "rancin" 
## [7] "eneviev" "eineman"
```

``` r
# paste can "glue" on single or (recycled) vectors of strings
paste(friends, "is my friend")
```

```
## [1] "Alice is my friend"     "Bob is my friend"      
## [3] "Charlie is my friend"   "Donny is my friend"    
## [5] "Emmy is my friend"      "Francine is my friend" 
## [7] "Genevieve is my friend" "Heinemann is my friend"
```

``` r
paste("My friend", friends, "is in group", groups)
```

```
## [1] "My friend Alice is in group A"    
## [2] "My friend Bob is in group B"      
## [3] "My friend Charlie is in group A"  
## [4] "My friend Donny is in group B"    
## [5] "My friend Emmy is in group A"     
## [6] "My friend Francine is in group B" 
## [7] "My friend Genevieve is in group A"
## [8] "My friend Heinemann is in group B"
```

``` r
# paste0(...) is a shortcut for paste(..., sep="")
# sep sets the separator between each string (default: a single space " ")
paste0(friends, "123")
```

```
## [1] "Alice123"     "Bob123"       "Charlie123"   "Donny123"    
## [5] "Emmy123"      "Francine123"  "Genevieve123" "Heinemann123"
```

``` r
paste(friends, "123", sep = "_")
```

```
## [1] "Alice_123"     "Bob_123"       "Charlie_123"  
## [4] "Donny_123"     "Emmy_123"      "Francine_123" 
## [7] "Genevieve_123" "Heinemann_123"
```

``` r
# paste also has an argument called collapse, which sets a separator,
# then uses that separator to collapse the vector into a single string
paste(friends, collapse = ", ")
```

```
## [1] "Alice, Bob, Charlie, Donny, Emmy, Francine, Genevieve, Heinemann"
```

``` r
# repeat characters in each string a set number of times
strrep(friends, 3)
```

```
## [1] "AliceAliceAlice"             "BobBobBob"                  
## [3] "CharlieCharlieCharlie"       "DonnyDonnyDonny"            
## [5] "EmmyEmmyEmmy"                "FrancineFrancineFrancine"   
## [7] "GenevieveGenevieveGenevieve" "HeinemannHeinemannHeinemann"
```

``` r
# of course, this can also be vectorized!
strrep(friends, 1:8)
```

```
## [1] "Alice"                                                                   
## [2] "BobBob"                                                                  
## [3] "CharlieCharlieCharlie"                                                   
## [4] "DonnyDonnyDonnyDonny"                                                    
## [5] "EmmyEmmyEmmyEmmyEmmy"                                                    
## [6] "FrancineFrancineFrancineFrancineFrancineFrancine"                        
## [7] "GenevieveGenevieveGenevieveGenevieveGenevieveGenevieveGenevieve"         
## [8] "HeinemannHeinemannHeinemannHeinemannHeinemannHeinemannHeinemannHeinemann"
```



#### Pattern string functions

There are also functions for working with patterns. You don't need to master these functions, but a few basic demos of them may prove helpful. Primarily, we have `grep()`/`grepl()` for pattern matching, and `sub()`/`gsub()` for pattern replacing. The prefix/suffix matching `startsWith()`/`endsWith()` are also occasionally useful.

It should be noted the patterns below are all fairly short (mostly one single character) for simplicity of example, but patterns can be as many characters long as necessary.


``` r
# which friends (by position) have a lowercase "e" in their name?
grep("e", friends)
```

```
## [1] 1 3 6 7 8
```

``` r
# alternatively, return a TRUE/FALSE vector result instead for each element
grepl("e", friends)
```

```
## [1]  TRUE FALSE  TRUE FALSE FALSE  TRUE  TRUE  TRUE
```

``` r
# you can use either of these to subset the original vector to get actual names
friends[grep("e", friends)]
```

```
## [1] "Alice"     "Charlie"   "Francine"  "Genevieve" "Heinemann"
```

``` r
# you can disable case sensitivity, which adds Emmy to the results
friends[grep("e", friends, ignore.case = TRUE)]
```

```
## [1] "Alice"     "Charlie"   "Emmy"      "Francine"  "Genevieve"
## [6] "Heinemann"
```

``` r
# you can use sub() to replace patterns
# here we can create a set of variant spellings, changing -y to -ie
sub("y", "ie", friends)
```

```
## [1] "Alice"     "Bob"       "Charlie"   "Donnie"    "Emmie"    
## [6] "Francine"  "Genevieve" "Heinemann"
```

``` r
# sub() can only replace once (inside each element),
# but gsub() can replace ALL occurrences
sub("n", "m", friends)
```

```
## [1] "Alice"     "Bob"       "Charlie"   "Domny"     "Emmy"     
## [6] "Framcine"  "Gemevieve" "Heimemann"
```

``` r
gsub("n", "m", friends)
```

```
## [1] "Alice"     "Bob"       "Charlie"   "Dommy"     "Emmy"     
## [6] "Framcime"  "Gemevieve" "Heimemamm"
```

``` r
# check which string endsWith() a pattern (startsWith() does the opposite)
endsWith(friends, "y")
```

```
## [1] FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE FALSE
```

Each of these functions (as well as several more listed in the `grep()` help page), actually accept more complex pattern syntax for the search pattern. This advanced search pattern syntax is called "regular expressions" or "regex" for short. You can do things like match groups of characters, match repeated characters or groups, match to specific locations in words or sentences, and more.

In this class we will NOT cover regular expressions to any real detail again due to limited time, but feel free to explore [this cheat sheet](https://paulvanderlaken.com/wp-content/uploads/2017/08/r-regular-expression-cheetsheat.pdf) as well as [these](https://paulvanderlaken.com/2017/10/03/regular-expressions-in-r-part-1-introduction-and-base-r-functions/) [two](https://bookdown.org/rdpeng/rprogdatascience/regular-expressions.html) additional articles on the matter.



#### Additional stringr functions

The [stringr](https://stringr.tidyverse.org/) package (which is a subset of the [Tidyverse](https://www.tidyverse.org/)) contains an alternative set of functions for working with strings. Many of these are similar in purpose to base R versions (although some have subtle differences). E.g. `str_length()` is the same as `nchar()`, `str_to_lower()`/`str_to_upper()` replicate `tolower()`/`toupper()`, `str_replace()` is similar to `sub()`, `str_sub()` extends `substr()`, etc. Here's a full list of these [doppelgänger stringr functions](https://stringr.tidyverse.org/articles/from-base.html).

However, there are a few useful stringr functions that do not have counterparts in base R (or at least whose counterparts require much more complex expressions). Here is a *small* curation of them.


``` r
# you can import either all of tidyverse with library(tidyverse)
# or just stringr by itself if that's all you need
library(stringr)
```


``` r
# count how many times a pattern occurs
str_count(friends, "e")
```

```
## [1] 1 0 1 0 0 1 4 2
```

``` r
# change strings to title case, i.e. first letter uppercase, all else lower
str_to_title(toupper(friends))
```

```
## [1] "Alice"     "Bob"       "Charlie"   "Donny"     "Emmy"     
## [6] "Francine"  "Genevieve" "Heinemann"
```

``` r
# "pad" a vector of strings to a constant length
str_pad(friends, width = 12, side = "right", pad = ".")
```

```
## [1] "Alice......." "Bob........." "Charlie....." "Donny......."
## [5] "Emmy........" "Francine...." "Genevieve..." "Heinemann..."
```



#### Comparing strings


### Date vectors

 - parse, getters/setters, math, comparisons, etc.

### Sorting vectors

 - examples from all types


