

# Data Frames

Moving on from vectors, the next most important data structure in R is the data frame. Think of a data frame as similar to a matrix, but (ideally) **each column is a vector of a single type representing a variable or attribute, and each row is an observation in your sample**.

It's actually really helpful to think of a data frame as a collection of parallel vectors with the same length, each to a column with its own type. E.g. suppose you survey a sample of college students; maybe you'd have a sex column of character type, a GPA column of numeric type, a birthday column of date type, and a column for if they have declared a major with logical type.




## Creating data frames


There are 2 common ways of creating a new data frame manually: `data.frame()` from base R, or `tibble()` from the [tibble](https://tibble.tidyverse.org) package, another of the core Tidyverse packages. They are extremely similar, but we recommend `tibble()` due to some nice extra features such as better printing, referencing other columns during creation, and stricter subsetting rules. Example:


``` r
# import the tibble and lubridate libraries
# again, tibble is core tidyverse, so library(tidyverse) will also work
# but lubridate is not core so needs to be imported manually
library(tibble)
library(lubridate)
```
``` r
# manually create an example data frame
df <- tibble(
  name = c("Alice", "Bob", "Charlie"),
  sex = c("F", "M", "M"),
  date_of_birth = mdy(c("7/14/03", "7/4/99", "10/31/06")),
  age = floor(as.numeric(today() - birthday)/365.24),
  declared_major = c(TRUE, TRUE, FALSE),
  school = "UW-Madison"
)
# print df
df
```

```
## # A tibble: 3 × 6
##   name    sex   date_of_birth   age declared_major school    
##   <chr>   <chr> <date>        <dbl> <lgl>          <chr>     
## 1 Alice   F     2003-07-14       21 TRUE           UW-Madison
## 2 Bob     M     1999-07-04       25 TRUE           UW-Madison
## 3 Charlie M     2006-10-31       17 FALSE          UW-Madison
```

Note the following:

 - The syntax inside `tibble()` is always `column_name = vector_of_data, next_column_name = next_vector_of_data, ...` where each vector must be the same length.
 - The vectors do not have to be pre-created; you canc reate them as you go along.
 - You can reference another column immediately after creating it inside the function, e.g. `date_of_birth` was created, and then immediately used on the next line to help create `age` (by the way `age` here is approximately computed as number of days since birth divided by 365.24, the approximate number of days in a year, then rounded down following convention).
 - Data frames can, and almost always do contain many columns each with a different type. However, as usual a single column---which is still a vector!---can only contain a SINGLE type of data inside it, e.g. you cannot have a column with both numbers and characters simultaneously.
 - Printing the df by either just writing it on a new line, or with the `print()` function (same thing) will show not only the first few rows, but also other info like
   - column (and row) names,
   - number of rows and columns (displayed as rows x cols),
   - and the type of each column (dbl, chr, lgl, date, or others beyond our scope)
 - You can create a column of constants by recycling a single value
   - Note: by design, `tibble()` will ONLY recycle length-1 vectors. This is to help avoid errors and improve syntax legibility.




## Importing data frames


Of course, in practice you don't usually create data frames manually like this, but rather import them from data files. As always, there are base R ways for doing this, but we will continue to recommend Tidyverse syntax due to its better features and design.

There are a million different data formats, but we will only cover 3 of the most common basic ones: CSV, or comma separated value files; TSV, or tab separated files; and XLS(X), which are Excel (or similar spreadsheet software) data files. Notably, we do not cover databases (like SQL or its derivatives) or non-rectangular data formats (like JSON or XML), again due to limitations of time/space.




### Aside: file formats & extensions


First, a small aside. File formats (or types) and file extensions are commonly conflated, but the distinction is important.

 - File **format** refers to the internal structure of the contents. Common formats include simple text (which can be encoded using a variety of [different encodings](https://dsc.gmu.edu/tutorials-data/tutorial-character-encoding) with ASCII and Unicode UTF-8 being the most common), other more complex documents like PDFs or DOCs, images and videos, compressed archives, binary executables, or other specialized (often proprietary) formats.
 - File **extensions**, in contrast are just characters added to the end of the name of a file for our convenience and to hint to computers (and users) what you might expect to find inside the contents of the file. It has no bearing on the actual file format contained inside.

Many extensions may in fact be the same file format, e.g. .Rmd, .html, .csv, .txt, and many more are all examples of extensions that are actually just simple text files (under some encoding), which is why they can all be opened with any text editor. Conversely, some formats can be stored with a variety of different extensions, e.g. MPEG-4 is a versatile multimedia "container" format and may be stored not only as .mp4 but also .m4a, .m4b, .m4p, .m4r, or .m4v depending on context.

Again, the extension only exists to "hint" at the contents of a file. You can store a text file with a .mp4 extension if you want. Your computer will then suggest you open it with a video player which will fail, but you can force it to open in a text editor and it will work just fine. Remember **file names and file contents are totally separate things** and need not have any bearing on each other.

Some important takeaways from all this:

 - Some data "formats" (like CSV, TSV, JSON, or XML) are really just simple text files (similar to the .txt files often created by text editor programs). In this class, when we say "CSV" we generally refer to the specific way the text is formatted (i.e. values separated by commas) inside the file, not just the extension.
 - Some data formats (like XLS(X) or databases) are not simple text files but specialized formats, and often need different treatment.
 - Just changing the extension of a file does NOT change the contents. E.g. changing a .csv extension to .zip does NOT create a valid zip file, no more than painting stripes on a horse turns it into a zebra.

:::{.note}
Today, many systems by default hide file extensions, e.g. a file that's actually named `data.csv` may appear to the user as just named `data`. This can cause problems, because if a user isn't aware of this and tries to rename the file to `data.csv` it may actually become `data.csv.csv`. This is a common cause of knit-fail that we see.

We **highly recommended you force your device to always show extensions** which can help avoid these problems. Instructions [for Windows](https://www.howtogeek.com/205086/beginner-how-to-make-windows-show-file-extensions) and [for Macs](https://support.apple.com/guide/mac-help/show-or-hide-filename-extensions-on-mac-mchlp2304/mac).
:::




### Importing functions


For text-format data files, we once again turn to [readr](https://readr.tidyverse.org) which has a suite of functions for importing them, of which we will only focus on a few:

 - `read_csv()` is used to read in CSV files where columns of data are separated by commas,
 - `read_tsv()` is used to read in files where columns of data are separated by tabs,
 - `read_delim()` is the general form of these `read_...` functions and can be used to read in files with any other type of separator.

One additional non-text format will be covered in this course: XLS(X) spreadsheet data, commonly generated by Excel or similar spreadsheet software. For these, we have a different function from Tidyverse's non-core [readxl](https://readxl.tidyverse.org) package:

 - [`read_excel()`{.R}](https://rdrr.io/cran/readxl/man/read_excel.html) can be used to read in both XLS and XLSX spreadsheet data

:::{.note}
Note the underscores in the function names. E.g. `read_csv()` which is from readr is NOT the same as `read.csv()` which is a base R function. They are similar, but readr's `read_csv()` has some minor improvements in speed and consistency so is recommended by this class.

Also note that if you do not have readr (or tidyverse) loaded, attempting to [TAB]{.k} autocomplete the `read_csv()` function will instead give you `read.csv()` so again, remember to set your working directory and load necessary libraries whenever (re)opening Rstudio before starting/resuming your work.
:::




### Eruptions example


To demonstrate the basic functionality of these different functions, I've prepared and exported a dataset on 21^st^ century volcanic eruptions in the United States from the [Smithsonian](https://volcano.si.edu/volcanolist_countries.cfm?country=United%20States) to all the formats listed above so we can practice reading them in from any initial format:

 - [`eruptions_recent.csv`](data/eruptions_recent.csv)
 - [`eruptions_recent.tsv`](data/eruptions_recent.tsv)
 - [`eruptions_recent.delim`](data/eruptions_recent.delim)
 - [`eruptions_recent.xlsx`](data/eruptions_recent.xlsx)


#### CSV file

For example, here's the first few lines of the [`eruptions_recent.csv`](data/eruptions_recent.csv) CSV file (for each eruption, we have the volcano name, start and stop dates, duration in days, if its certainty is confirmed, and the VEI or volcano explosivity index).


``` csv
volcano,start,stop,duration,confirmed,vei
Kilauea,2024-06-03,2024-06-03,0,TRUE,NA
Atka Volcanic Complex,2024-03-27,2024-03-27,0,TRUE,NA
Ahyi,2024-01-01,2024-03-27,86,TRUE,NA
Kanaga,2023-12-18,2023-12-18,0,TRUE,1
Ruby,2023-09-14,2023-09-15,1,TRUE,1
```

If you have a link to a dataset, you can directly pass it into `read_csv()` and it will automagically download the file to your system's temp folder and read it in. Make sure to save it into a data frame with a sensible name. It's also usually a good idea to print out the first few lines to check the result and see if everything worked without error.


``` r
# import readr
library(readr)
```


``` r
# read in CSV file from link
eruptions_recent <- read_csv(
  "https://bwu62.github.io/stat240-revamp/data/eruptions_recent.csv"
)
```

``` message
## Rows: 71 Columns: 6
## ── Column specification ──────────────────────────────────────────────
## Delimiter: ","
## chr  (1): volcano
## dbl  (2): duration, vei
## lgl  (1): confirmed
## date (2): start, stop
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```


``` r
# print first few lines of result to check
eruptions_recent
```

```
## # A tibble: 71 × 6
##    volcano               start      stop       duration confirmed   vei
##    <chr>                 <date>     <date>        <dbl> <lgl>     <dbl>
##  1 Kilauea               2024-06-03 2024-06-03        0 TRUE         NA
##  2 Atka Volcanic Complex 2024-03-27 2024-03-27        0 TRUE         NA
##  3 Ahyi                  2024-01-01 2024-03-27       86 TRUE         NA
##  4 Kanaga                2023-12-18 2023-12-18        0 TRUE          1
##  5 Ruby                  2023-09-14 2023-09-15        1 TRUE          1
##  6 Shishaldin            2023-07-11 2023-11-03      115 TRUE          3
##  7 Mauna Loa             2022-11-27 2022-12-10       13 TRUE          0
##  8 Ahyi                  2022-11-18 2023-06-11      205 TRUE          1
##  9 Kilauea               2021-09-29 2023-09-16      717 TRUE          0
## 10 Pavlof                2021-08-05 2022-12-07      489 TRUE          2
## # ℹ 61 more rows
```

Several things to note here:

 - Some diagnostic messages will be printed while reading, as well as any warnings/errors if it encounters anything unsual (no errors/warnings are observed here).
 - While reading in, R will try to intelligently guess the data types of each column if they're in a standard format. You can see here that since all columns in the CSV were already very neat and written in a standard format (e.g. dates in YYYY-MM-DD, numbers and logicals written in common syntax, missing values written as NA), everything automagically converted: `name` is left as a character, `start` and `stop` parsed to dates, `duration` and `vei` parsed to numeric, and `confirmed` became logical.
   - If columns are not written in a standard format, this may not work as well (if at all) and you may need to do more data cleaning yourself, which we will touch on later.
 - You can run just the data frame name again to print the first few rows. This is equivalent to running `print(eruptions_recent)`.
   - Printing is often a useful way to double check for errors. By default, only the first 10 lines are printed to save space.
 - If you look in your [Environment tab](https://i.imgur.com/Xo5HE2U.png) now, you should see the loaded data frame.
   - Here, you can click on the arrow to see a list of all columns, as well as their names, types, and the first few values.
   - You can also click here on the object name itself here to open a new tab with a full spreadsheet-like view of the entire data frame, where you can inspect the data frame, and even search for values and sort by columns (note: sorting here is just for preview and does not affect the underlying object).


#### TSV file

The other functions are all similar. Here's the first few lines of the TSV-version of the same dataset, [`eruptions_recent.tsv`](data/eruptions_recent.tsv) (the way these notes are built doesn't diaplay tabs properly, but if you view the TSV file directly, you can see them).


``` tsv
volcano	start	stop	duration	confirmed	vei
Kilauea	2024-06-03	2024-06-03	0	TRUE	NA
Atka Volcanic Complex	2024-03-27	2024-03-27	0	TRUE	NA
Ahyi	2024-01-01	2024-03-27	86	TRUE	NA
Kanaga	2023-12-18	2023-12-18	0	TRUE	1
Ruby	2023-09-14	2023-09-15	1	TRUE	1
```

Here it is read in with the `read_tsv()` function. This time, to save space, I've disabled the diagnostic messages by setting `show_col_types = FALSE` and reduced the final print checking to 5 lines. Otherwise, you can see we have the exact same result.


``` r
# read in TSV file from link
eruptions_recent <- read_tsv(
  "https://bwu62.github.io/stat240-revamp/data/eruptions_recent.tsv",
  show_col_types = FALSE
)
# print first 5 lines instead of 10 to still check, but save space
print(eruptions_recent, n = 5)
```

```
## # A tibble: 71 × 6
##   volcano               start      stop       duration confirmed   vei
##   <chr>                 <date>     <date>        <dbl> <lgl>     <dbl>
## 1 Kilauea               2024-06-03 2024-06-03        0 TRUE         NA
## 2 Atka Volcanic Complex 2024-03-27 2024-03-27        0 TRUE         NA
## 3 Ahyi                  2024-01-01 2024-03-27       86 TRUE         NA
## 4 Kanaga                2023-12-18 2023-12-18        0 TRUE          1
## 5 Ruby                  2023-09-14 2023-09-15        1 TRUE          1
## # ℹ 66 more rows
```


#### Arbitrary delimited file

If your data file has columns delimited (i.e. separated) by other characters, you can use the `read_delim()` function, which is a generalization of the previous two to read it in. Just set the `delim` argument to whatever the delimiter is, and you're good to go. Here's the first few lines of [`eruptions_recent.delim`](data/eruptions_recent.delim) where the columns are separated by vertical bar `|` characters, followed by the line of code to import it and check the result.


``` delim
volcano|start|stop|duration|confirmed|vei
Kilauea|2024-06-03|2024-06-03|0|TRUE|
Atka Volcanic Complex|2024-03-27|2024-03-27|0|TRUE|
Ahyi|2024-01-01|2024-03-27|86|TRUE|
Kanaga|2023-12-18|2023-12-18|0|TRUE|1
Ruby|2023-09-14|2023-09-15|1|TRUE|1
```

``` r
# read in | delimited file from link
eruptions_recent <- read_delim(
  "https://bwu62.github.io/stat240-revamp/data/eruptions_recent.delim",
  delim = "|",
  show_col_types = FALSE
)
# print first 5 lines
print(eruptions_recent, n = 5)
```

```
## # A tibble: 71 × 6
##   volcano               start      stop       duration confirmed   vei
##   <chr>                 <date>     <date>        <dbl> <lgl>     <dbl>
## 1 Kilauea               2024-06-03 2024-06-03        0 TRUE         NA
## 2 Atka Volcanic Complex 2024-03-27 2024-03-27        0 TRUE         NA
## 3 Ahyi                  2024-01-01 2024-03-27       86 TRUE         NA
## 4 Kanaga                2023-12-18 2023-12-18        0 TRUE          1
## 5 Ruby                  2023-09-14 2023-09-15        1 TRUE          1
## # ℹ 66 more rows
```


#### XLS(X) file

Data is also commonly encountered as an XLS/XLSX spreadsheet file, which can be read by [`read_excel()`{.R}](https://rdrr.io/cran/readxl/man/read_excel.html), which remember is from [readxl](https://readxl.tidyverse.org) not [readr](https://readr.tidyverse.org). The [`eruptions_recent.xlsx`](data/eruptions_recent.xlsx) file again has the same dataset but exported to a XLSX. Since XLSX is not a text format, it can't be embedded here, but here's what the first few rows look like when opened in Excel:

![](https://i.imgur.com/lZbyh6Y.png)







<!--

data frame topics

 - dimensions
 - subsetting
 - missing

-->
