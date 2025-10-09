

# Data Frames

Moving on from vectors, the next most important data structure in R is the data frame. Think of a data frame as similar to a matrix, but (ideally) **each column is a vector of a single type representing a variable or attribute, and each row is an observation in your sample**.

It's actually really helpful to think of a data frame as a collection of parallel vectors with the same length, each to a column with its own type. E.g. suppose you survey a sample of college students; maybe you'd have a sex column of character type, a GPA column of numeric type, a birthday column of date type, and a column for if they have declared a major with logical type.




## Creating data frames {#creating-dfs}


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
  date_of_birth = mdy(c("1/8/04", "7/4/99", "10/31/06")),
  age = floor(as.numeric(today() - date_of_birth) / 365.24),
  declared_major = c(TRUE, TRUE, FALSE),
  school = "UW-Madison"
)
# print df
df
```

```
# A tibble: 3 × 6
  name    sex   date_of_birth   age declared_major school    
  <chr>   <chr> <date>        <dbl> <lgl>          <chr>     
1 Alice   F     2004-10-08       21 TRUE           UW-Madison
2 Bob     M     1999-07-04       26 TRUE           UW-Madison
3 Charlie M     2006-10-31       18 FALSE          UW-Madison
```

Note the following:

 - The syntax inside `tibble()` is always `column_name = vector_of_data, next_column_name = next_vector_of_data, ...` where each vector must be the same length.
 - The vectors do not have to be pre-created; you can create them as you go along.
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




### Example: US Eruptions {#eruptions-example}


To demonstrate the basic functionality of these different functions, I've prepared and exported a dataset on 21^st^ century volcanic eruptions (with a recorded start and end date prior to 2025) in the United States from the [Smithsonian](https://volcano.si.edu/volcanolist_countries.cfm?country=United%20States) to all the formats listed above so we can practice reading them in from any initial format:

 - [`eruptions_recent.csv`](data/eruptions_recent.csv)
 - [`eruptions_recent.tsv`](data/eruptions_recent.tsv)
 - [`eruptions_recent.delim`](data/eruptions_recent.delim)
 - [`eruptions_recent.xlsx`](data/eruptions_recent.xlsx)

[![](https://volcano.si.edu/gallery/photos/GVP-05273.jpg){.i6}](https://volcano.si.edu/gallery/ShowImage.cfm?photo=GVP-05273)


### CSV file

For example, here's the first few lines of the [`eruptions_recent.csv`](data/eruptions_recent.csv) CSV file (for each eruption, we have the volcano name, start and stop dates, duration in days, if its certainty is confirmed, and the VEI or volcano explosivity index).


``` csv
volcano,start,stop,duration,confirmed,vei
Kīlauea,2024-09-15,2024-09-20,5,TRUE,NA
Kīlauea,2024-06-03,2024-06-03,0,TRUE,NA
Atka Volcanic Complex,2024-03-27,2024-03-27,0,TRUE,NA
Ahyi,2024-01-01,2024-03-27,86,TRUE,NA
Kanaga,2023-12-18,2023-12-18,0,TRUE,1
Ruby,2023-09-14,2023-09-15,1,TRUE,1
```

If you have a link to a dataset, you can directly pass it into `read_csv()` and it will automagically download the file to your system's temp directory and read it in. Make sure to save it into a data frame with a sensible name. It's also usually a good idea to print out the first few lines to check the result and see if everything worked without error.


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
Rows: 75 Columns: 6
── Column specification ──────────────────────────────────────────────
Delimiter: ","
chr  (1): volcano
dbl  (2): duration, vei
lgl  (1): confirmed
date (2): start, stop

ℹ Use `spec()` to retrieve the full column specification for this data.
ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```


``` r
# print first few lines of result to check
eruptions_recent
```

```
# A tibble: 75 × 6
   volcano               start      stop       duration confirmed   vei
   <chr>                 <date>     <date>        <dbl> <lgl>     <dbl>
 1 Kīlauea               2024-09-15 2024-09-20        5 TRUE         NA
 2 Kīlauea               2024-06-03 2024-06-03        0 TRUE         NA
 3 Atka Volcanic Complex 2024-03-27 2024-03-27        0 TRUE         NA
 4 Ahyi                  2024-01-01 2024-03-27       86 TRUE         NA
 5 Kanaga                2023-12-18 2023-12-18        0 TRUE          1
 6 Ruby                  2023-09-14 2023-09-15        1 TRUE          1
 7 Shishaldin            2023-07-11 2023-11-03      115 TRUE          3
 8 Mauna Loa             2022-11-27 2022-12-10       13 TRUE          0
 9 Ahyi                  2022-11-18 2023-06-11      205 TRUE          1
10 Kīlauea               2021-09-29 2023-09-16      717 TRUE          0
# ℹ 65 more rows
```

Several things to note here:

 - Some diagnostic messages will be printed while reading, as well as any warnings/errors if it encounters anything unusual (no errors/warnings are observed here).
 - While reading in, R will try to intelligently guess the data types of each column if they're in a standard format. You can see here that since all columns in the CSV were already very neat and written in a standard format (e.g. dates in `YYYY-MM-DD`, numbers and logicals written in common syntax, missing values written as NA), everything automagically converted: `name` is left as a character, `start` and `stop` parsed to dates, `duration` and `vei` parsed to numeric, and `confirmed` became logical.
   - If columns are not written in a standard format, this may not work as well (if at all) and you may need to do more data cleaning yourself, which we will touch on later.
 - You can run just the data frame name again to print the first few rows. This is equivalent to running `print(eruptions_recent)`.
   - Printing is often a useful way to double check for errors. By default, only the first 10 lines are printed to save space.
 - If you look in your [Environment tab](https://i.imgur.com/Xo5HE2U.png) now, you should see the loaded data frame.
   - Here, you can click on the arrow to see a list of all columns, as well as their names, types, and the first few values.
   - You can also click here on the object name itself here to open a new tab with a full spreadsheet-like view of the entire data frame, where you can inspect the data frame, and even search for values and sort by columns (note: sorting here is just for preview and does not affect the underlying object).



### TSV file

The other functions are all similar. Here's the first few lines of the TSV-version of the same dataset, [`eruptions_recent.tsv`](data/eruptions_recent.tsv) (the way these notes are built doesn't display tabs properly, but if you view the TSV file directly, you can see them).


``` tsv
volcano	start	stop	duration	confirmed	vei
Kīlauea	2024-09-15	2024-09-20	5	TRUE	NA
Kīlauea	2024-06-03	2024-06-03	0	TRUE	NA
Atka Volcanic Complex	2024-03-27	2024-03-27	0	TRUE	NA
Ahyi	2024-01-01	2024-03-27	86	TRUE	NA
Kanaga	2023-12-18	2023-12-18	0	TRUE	1
Ruby	2023-09-14	2023-09-15	1	TRUE	1
```

Here it is read in with the `read_tsv()` function. This time, to save space, I've disabled the diagnostic messages by setting `show_col_types = FALSE` and reduced the final print checking to 6 lines. Otherwise, you can see we have the exact same result.


``` r
# read in TSV file from link
eruptions_recent <- read_tsv(
  "https://bwu62.github.io/stat240-revamp/data/eruptions_recent.tsv",
  show_col_types = FALSE
)
# print first 6 lines instead of 10 to still check, but save space
print(eruptions_recent, n = 6)
```

```
# A tibble: 75 × 6
  volcano               start      stop       duration confirmed   vei
  <chr>                 <date>     <date>        <dbl> <lgl>     <dbl>
1 Kīlauea               2024-09-15 2024-09-20        5 TRUE         NA
2 Kīlauea               2024-06-03 2024-06-03        0 TRUE         NA
3 Atka Volcanic Complex 2024-03-27 2024-03-27        0 TRUE         NA
4 Ahyi                  2024-01-01 2024-03-27       86 TRUE         NA
5 Kanaga                2023-12-18 2023-12-18        0 TRUE          1
6 Ruby                  2023-09-14 2023-09-15        1 TRUE          1
# ℹ 69 more rows
```



### Arbitrary delimited file

If your data file has columns delimited (i.e. separated) by other characters, you can use the `read_delim()` function, which is a generalization of the previous two to read it in. Just set the `delim` argument to whatever the delimiter is, and you're good to go. Here's the first few lines of [`eruptions_recent.delim`](data/eruptions_recent.delim) where the columns are separated by vertical bar `|` characters, followed by the line of code to import it and check the result.


``` delim
volcano|start|stop|duration|confirmed|vei
Kīlauea|2024-09-15|2024-09-20|5|TRUE|
Kīlauea|2024-06-03|2024-06-03|0|TRUE|
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
# print first 6 lines
print(eruptions_recent, n = 6)
```

```
# A tibble: 75 × 6
  volcano               start      stop       duration confirmed   vei
  <chr>                 <date>     <date>        <dbl> <lgl>     <dbl>
1 Kīlauea               2024-09-15 2024-09-20        5 TRUE         NA
2 Kīlauea               2024-06-03 2024-06-03        0 TRUE         NA
3 Atka Volcanic Complex 2024-03-27 2024-03-27        0 TRUE         NA
4 Ahyi                  2024-01-01 2024-03-27       86 TRUE         NA
5 Kanaga                2023-12-18 2023-12-18        0 TRUE          1
6 Ruby                  2023-09-14 2023-09-15        1 TRUE          1
# ℹ 69 more rows
```



### XLS(X) file

Data is also commonly encountered as an XLS/XLSX spreadsheet file, which can be read with readxl's [`read_excel()`{.R}](https://rdrr.io/cran/readxl/man/read_excel.html) function. The [`eruptions_recent.xlsx`](data/eruptions_recent.xlsx) file again has the same dataset but exported to XLSX. Since XLSX is not a text format, it can't be embedded here, but here's what the first few rows look like when opened in Excel:

![](https://i.imgur.com/lZbyh6Y.png){.i6}

Unfortunately, [readxl does not support URLs](https://github.com/tidyverse/readxl/issues/278) so the data must be downloaded before loading.


``` r
# load readxl, which is NOT core tidyverse, so must be imported explicitly
library(readxl)
```

``` r
# I already have the file downloaded to data/
# inside my current working directory
dir.exists("data/")
```

```
[1] TRUE
```

``` r
file.exists("data/eruptions_recent.xlsx")
```

```
[1] TRUE
```

``` r
eruptions_recent <- read_xlsx("data/eruptions_recent.xlsx")
# print first 6 lines
print(eruptions_recent, n = 6)
```

```
# A tibble: 75 × 6
  volcano            start               stop                duration confirmed   vei
  <chr>              <dttm>              <dttm>                 <dbl> <chr>     <dbl>
1 Kīlauea            2024-09-15 00:00:00 2024-09-20 00:00:00        5 TRUE         NA
2 Kīlauea            2024-06-03 00:00:00 2024-06-03 00:00:00        0 TRUE         NA
3 Atka Volcanic Com… 2024-03-27 00:00:00 2024-03-27 00:00:00        0 TRUE         NA
4 Ahyi               2024-01-01 00:00:00 2024-03-27 00:00:00       86 TRUE         NA
5 Kanaga             2023-12-18 00:00:00 2023-12-18 00:00:00        0 TRUE          1
6 Ruby               2023-09-14 00:00:00 2023-09-15 00:00:00        1 TRUE          1
# ℹ 69 more rows
```

Oops, looks like start/stop was read as a datetime instead of a date. We'll learn later how to fix this, but for now we're moving on.



### Extra arguments

The files above have been prepared to be easily imported without needing additional arguments, but in general it's common to need to set other arguments in the functions to get them to import properly. Below is a BRIEF selection of some of the most useful arguments available, loosely ordered by order of importance.

:::{.note}
Some arguments below can be used in several ways, e.g. they may accept either a TRUE/FALSE or a vector of numbers or strings, etc. and may have different behavior depending on the input. We will highlight the most common usages here, but as always see help page for more details!
:::

The `read_csv()`, `read_tsv()`, and `read_delim()` functions from readr share a single help page, and have many arguments in common (but not all, again see help page). Some useful additional arguments include:

 - `col_names` controls handling of column names.
   - Under the default value `TRUE`, first row of file will be used as column names,
   - If set to `FALSE`, placeholder names will be used, and the first line of the file will be treated as data,
   - If set to a character vector, that vector will be used as the column names, and again first row of file will be treated as data.
 - `col_types` controls handling of column types.
   - The best way to set this is with a compact, single-word string where each letter represents in order from left to right the column type to use:
     - `d` = double (i.e. a "normal" numeric value)
     - `n` = number, which is a special readr format that parses "human readable" non-standard numbers such as "$1,000" or "150%" (closely related to the `parse_number()` function from section \@ref(coercion))
     - `l` = logical, i.e. TRUE/FALSE
     - `D` = date, but this only works if dates are in a standard format like `"YYYY-MM-DD"`; it will NOT parse non-standard formats
     - `c` = character, for both text data as well as data in a non-standard format, to be parsed later
     - `_` or `-` will skip a column
       
   For example, suppose a data frame had in order from left to right a numeric column, a date column, a character column, a column you want to skip, and a non-standard column that needs to be parsed later; you would set `col_types = "dDc_c"` to specify this.
 - `na` sets a vector of values to be treated as missing, which by default is `c("", "NA")`, i.e. empty strings and `"NA"` will be treated as missing.
 - `comment` is for some data files that have comment lines, usually (but not always) beginning with a hashtag `#` character. These lines can be ignored by setting `comment = "#"` for example.
 - `skip` let's you skip a set number of lines at the beginning of the file.
 - `n_max` allows setting the maximum number of lines read in the file.
 - `id` is useful when the filename contains important information (common when importing data split into many files). Setting `id = TRUE` saves the name in an `id` column.
 - `show_col_types` can be set to `FALSE` to silence diagnostic messages shown after importing.


The `read_excel()` function from readxl also has some useful extra arguments. Some of are the same as above, some are similar but slightly different, and some are unique to it (again, see help page). Brief selection of the most important arguments:

 - `sheet` and `range` are unique to `read_excel()` and you control which sheet (i.e. the tabs at the bottom) and what range (i.e. rectangular region of the spreadsheet) to read the data from.
    - `sheet` (defaults to the first sheet) can be either a name, a number indicating the position, or even included in the `range` specification.
    - `range` (defaults to the entire range) can be specified a variety of different ways, but most commonly might be something like `"A2:D6"` which includes the cells between columns A-D and rows 2-6. See [this page](https://readxl.tidyverse.org/reference/cell-specification.html) for examples of other syntax.
 - `col_names` behaves exactly the same as above: the default `TRUE` uses first row as names, `FALSE` uses generic placeholder names, but you can also directly set the names with a character vector
 - `col_types` is similar, but instead of a compact string notation, you must use a character vector to specify each column type, with "numeric", "logical", "date", "text", or "skip" as the possible values
 - `na`: also behaves the same above and accepts a vector of values that represent missing data; the only difference is it defaults to `""`
 - `skip` behaves the same as above, and let's you skip lines at the beginning.
 - `n_max` also behaves the same and sets the maximum number of lines read.



### Paths & file management

We also need to briefly discuss paths and revisit file management. Previously, we had to download a data file and import it from our local storage. For many first time R users, this is a nontrivial task.

In R, to import a downloaded file, you must provide a valid **file path, which is just a reference to a file's location** on your system. **Paths are always relative to the current working directory**. If you remembered to set your working directory correctly, so that your Rstudio session runs from the same place as your current Rmd file (which is where it knits from), and your path is also correct, then everything should work all the time, no errors.

If your data file is in the same directory as your Rmd file, you can reference it by just using the name. For example, suppose you're working on `hw01.Rmd` and your directories look like this:

:::{.paths}
    ..
    └── STAT240/
        └── homework/
            └── hw01/
                ├── hw01.Rmd
                └── hw01_data.csv
:::

Since `hw01_data.csv` is in the same directory as `hw01.Rmd`, you can import it by simply doing `read_csv("hw01_data.csv")`, again assuming you have your working directory set correctly. However, if your data file is in a subdirectory called `data/`, i.e. like this:

:::{.paths}
    ..
    └── STAT240/
        └── homework/
            └── hw01/
                ├── hw01.Rmd
                └── data/
                     └── hw01_data.csv
:::

Then, to import it you would need to write `read_csv("data/hw01_data.csv")` so that R will know first to go into the `data/` directory before searching for `hw01_data.csv` to load. If instead, you had your data file one level up, like this:

:::{.paths}
    └── STAT240/
        └── homework/
            ├── hw01_data.csv
            └── hw01/
                └── hw01.Rmd
:::

Then, to import it you would need to write `read_csv("../hw01_data.csv")` where the `../` means to go up a directory level (i.e. exit out of the current folder) before searching for `hw01_data.csv` to load.

It's important to note here **there is no single correct way to manage your files**, as long as they are organized and you can easily find what you need. However, if you have no strong preference, we recommend you follow our file organization structure introduced in section \@ref(setup-files), i.e. setup your directories like this:

:::{.paths}
    ..
    └── STAT240/
        │
        ├── data/
        │   ├── data_A.csv
        │   ├── data_B.tsv
        │   ├── data_C.xlsx
        │   :    :
        │
        ├── discussion/
        │   │
        │   ├── ds01/
        │   │   └── ds01.Rmd
        │   │
        │   ├── ds02/
        │   :   └── ds02.Rmd
        │
        ├── homework/
        │   │
        │   ├── hw01/
        │   │   └── hw01.Rmd
        │   │
        │   ├── hw02/
        │   :   └── hw02.Rmd
        │
        ├── notes/
        ├── project/
        ├── other/
        :
:::

Then, as long as you always do the following, things should always just work:

 1. Always put your homework/discussion Rmd files in `homework/hw##/` or `discussion/ds##/` where `##` is the assignment number.
 2. Always put ALL data in the `data/` directory, which is exactly 2 levels up from all `hw##` and `ds##` directories.
 3. Always reference your data files like `"../../data/data_file.csv"` which will tell R to go up 2 levels from the current directory, which will take you to the main `STAT240/` directory, then descend into `data/` to search for `data_file.csv`.

:::{.tip}
If you're having trouble finding and importing your file, these additional tips may help:

 - In R, **you can also [TAB]{.k} autocomplete paths**. Make sure your working directory is set, then start a path with `""`, place your cursor between the quotes, and hit [TAB]{.k}. You will see a popup menu showing files in your current directory. From here, either select a subdirectory to [TAB]{.k} into again, or type [.]{.k}[.]{.k}[/]{.k} to go up a directory level, repeat these steps as necessary until you find your file, then hit [ENTER]{.k} to confirm the selection.
 - If you're desperate, you can also use the graphical [readr import tool](https://i.imgur.com/EBpswIS.png) found in the Environment tab, which opens a [dialog box](https://i.imgur.com/2fc4kQa.png) where you can browse to a file, set arguments with convenient dropdown menus, see a preview of what the data would look like with those settings, and best of all: in the corner you can see **what code is generated that can do all this** which you can copy into your Rmd file. As always, make sure your working directory is set beforehand!
:::

:::{.note}
Paths in R **always use forward [/]{.k} slashes**, NEVER back [\\]{.k} slashes, even though back slashes are used by Windows file systems. This is just R's syntax.
:::




## Working with data frames

We will be using data frames extensively throughout this class. Let's start by learning some basic manipulations with them. First, I'm going to reload the `eruptions_recent` dataset using the CSV file, so that we have the correct `start`/`stop` columns.


``` r
# set R to print fewer rows by default, to save space in demos below
options(pillar.print_min = 6)

# reload dataset
eruptions_recent <- read_csv(
  "https://bwu62.github.io/stat240-revamp/data/eruptions_recent.csv",
  show_col_types = FALSE
)
# print first few rows
eruptions_recent
```

```
# A tibble: 75 × 6
  volcano               start      stop       duration confirmed   vei
  <chr>                 <date>     <date>        <dbl> <lgl>     <dbl>
1 Kīlauea               2024-09-15 2024-09-20        5 TRUE         NA
2 Kīlauea               2024-06-03 2024-06-03        0 TRUE         NA
3 Atka Volcanic Complex 2024-03-27 2024-03-27        0 TRUE         NA
4 Ahyi                  2024-01-01 2024-03-27       86 TRUE         NA
5 Kanaga                2023-12-18 2023-12-18        0 TRUE          1
6 Ruby                  2023-09-14 2023-09-15        1 TRUE          1
# ℹ 69 more rows
```



### Basic operations {#basic-df}

Here are a few basic operations for working with data frames: `nrow()`, `ncol()`, and `dim()` can show the number of rows and/or columns; `summary()` can show a quick summary of each column; `names()`/`colnames()` can both get and set column names; `rownames()` can both get and set row names.


``` r
# get number of rows and columns
nrow(eruptions_recent)
```

```
[1] 75
```

``` r
ncol(eruptions_recent)
```

```
[1] 6
```

``` r
# get both together using dim()
dim(eruptions_recent)
```

```
[1] 75  6
```

``` r
# show different summary of each column, depending on the column type
summary(eruptions_recent)
```

```
   volcano              start                 stop               duration     
 Length:75          Min.   :2001-02-02   Min.   :2001-04-15   Min.   :   0.0  
 Class :character   1st Qu.:2006-06-18   1st Qu.:2006-11-17   1st Qu.:   5.5  
 Mode  :character   Median :2011-04-23   Median :2011-09-01   Median :  62.0  
                    Mean   :2012-08-24   Mean   :2013-02-12   Mean   : 172.0  
                    3rd Qu.:2019-07-19   3rd Qu.:2019-10-15   3rd Qu.: 184.0  
                    Max.   :2024-09-15   Max.   :2024-09-20   Max.   :1491.0  
                                                                              
 confirmed            vei       
 Mode :logical   Min.   :0.000  
 FALSE:4         1st Qu.:1.000  
 TRUE :71        Median :2.000  
                 Mean   :1.881  
                 3rd Qu.:3.000  
                 Max.   :4.000  
                 NA's   :8      
```

``` r
# show names of the variable columns
# note names() and colnames() are completely identical for data frames
names(eruptions_recent)
```

```
[1] "volcano"   "start"     "stop"      "duration"  "confirmed" "vei"      
```

``` r
# you can also set individual, specific, or even all names
names(eruptions_recent)[2] <- "START"
names(eruptions_recent)[c(1, 4:6)] <- c("VOLCANO", "DURATION", "CONFIRMED", "VEI")
names(eruptions_recent)
```

```
[1] "VOLCANO"   "START"     "stop"      "DURATION"  "CONFIRMED" "VEI"      
```

``` r
# let's reset the names back to their original values
names(eruptions_recent) <- c(
  "volcano", "start", "stop", "duration", "confirmed", "vei"
)
# data frames may also have row names, though most don't
# if there are no row names, they just show as numbers
# (this is not generally a commonly used feature)
rownames(eruptions_recent)
```

```
 [1] "1"  "2"  "3"  "4"  "5"  "6"  "7"  "8"  "9"  "10" "11" "12" "13" "14" "15" "16"
[17] "17" "18" "19" "20" "21" "22" "23" "24" "25" "26" "27" "28" "29" "30" "31" "32"
[33] "33" "34" "35" "36" "37" "38" "39" "40" "41" "42" "43" "44" "45" "46" "47" "48"
[49] "49" "50" "51" "52" "53" "54" "55" "56" "57" "58" "59" "60" "61" "62" "63" "64"
[65] "65" "66" "67" "68" "69" "70" "71" "72" "73" "74" "75"
```



### Subsetting data frames

You can extract and manipulate subsets of a data frame along either dimension. Most commonly, you may want to use `$` to either pull out a single column as a vector, modify an existing column in-place, or even create a new column.


``` r
# extract the duration column
eruptions_recent$duration
```

```
 [1]    5    0    0   86    0    1  115   13  205  717  489   39   36  822  154    0
[17]  195   30  286   39    6   53  110   62  253 1009  125    3    6   23  519  121
[33]   44 1021    0    0 1491  131    1    3    2  100   71    0  108   19    2   38
[49]    8    0  256   29  422    4   98    0   98  188  264  139   58  259   71   41
[65] 1213   11  509  150  202   63  180    1   11    1   72
```

``` r
# change the confirmed column to 1s and 0s in-place
eruptions_recent$confirmed <- as.numeric(eruptions_recent$confirmed)
eruptions_recent
```

```
# A tibble: 75 × 6
  volcano               start      stop       duration confirmed   vei
  <chr>                 <date>     <date>        <dbl>     <dbl> <dbl>
1 Kīlauea               2024-09-15 2024-09-20        5         1    NA
2 Kīlauea               2024-06-03 2024-06-03        0         1    NA
3 Atka Volcanic Complex 2024-03-27 2024-03-27        0         1    NA
4 Ahyi                  2024-01-01 2024-03-27       86         1    NA
5 Kanaga                2023-12-18 2023-12-18        0         1     1
6 Ruby                  2023-09-14 2023-09-15        1         1     1
# ℹ 69 more rows
```

``` r
# add a new column giving just the year the eruption started in
eruptions_recent$start_year <- year(eruptions_recent$start)
eruptions_recent
```

```
# A tibble: 75 × 7
  volcano               start      stop       duration confirmed   vei start_year
  <chr>                 <date>     <date>        <dbl>     <dbl> <dbl>      <dbl>
1 Kīlauea               2024-09-15 2024-09-20        5         1    NA       2024
2 Kīlauea               2024-06-03 2024-06-03        0         1    NA       2024
3 Atka Volcanic Complex 2024-03-27 2024-03-27        0         1    NA       2024
4 Ahyi                  2024-01-01 2024-03-27       86         1    NA       2024
5 Kanaga                2023-12-18 2023-12-18        0         1     1       2023
6 Ruby                  2023-09-14 2023-09-15        1         1     1       2023
# ℹ 69 more rows
```

You can also use `[]` and `[[]]` to subset columns by name or position, the difference being `[]` returns a data frame and `[[]]` returns the vector directly.


``` r
# extract the vei column, keeping the result as a data frame
eruptions_recent["vei"]
```

```
# A tibble: 75 × 1
    vei
  <dbl>
1    NA
2    NA
3    NA
4    NA
5     1
6     1
# ℹ 69 more rows
```

``` r
# extract the same column but by position and directly as a vector
eruptions_recent[[6]]
```

```
 [1] NA NA NA NA  1  1  3  0  1  0  2  2  1  2  0  3  1 NA  3  1  1  2  2  1  3  3  3
[28]  3  3  2  1  3  3  0  2  2  2  2 NA  2  3  1  2  2  3  2  4  4  1 NA  2  2  2  1
[55]  1  2  2  1  3  3  1  2  1  2  2  1  3  2  2  3  1 NA  1  0  3
```

The `[]` operator has an additional usage of `[rows,cols]` where `rows`, `cols` can both be vectors specifying subsets by name or by position. Leaving one of them empty means return all of them.


``` r
# extract just the first 5 start/stop times
eruptions_recent[1:5, c("start", "stop")]
```

```
# A tibble: 5 × 2
  start      stop      
  <date>     <date>    
1 2024-09-15 2024-09-20
2 2024-06-03 2024-06-03
3 2024-03-27 2024-03-27
4 2024-01-01 2024-03-27
5 2023-12-18 2023-12-18
```

``` r
# extract the entire 10th row
eruptions_recent[10, ]
```

```
# A tibble: 1 × 7
  volcano start      stop       duration confirmed   vei start_year
  <chr>   <date>     <date>        <dbl>     <dbl> <dbl>      <dbl>
1 Kīlauea 2021-09-29 2023-09-16      717         1     0       2021
```

``` r
# you can also use negative indices to remove specific items
# e.g. this removes rows 1-10 and also removes the 7th column (start_year)
eruptions_recent[-(1:10), -7]
```

```
# A tibble: 65 × 6
  volcano       start      stop       duration confirmed   vei
  <chr>         <date>     <date>        <dbl>     <dbl> <dbl>
1 Pavlof        2021-08-05 2022-12-07      489         1     2
2 Pagan         2021-07-29 2021-09-06       39         1     2
3 Veniaminof    2021-02-28 2021-04-05       36         1     1
4 Semisopochnoi 2021-02-02 2023-05-05      822         1     2
5 Kīlauea       2020-12-20 2021-05-23      154         1     0
6 Cleveland     2020-06-01 2020-06-01        0         1     3
# ℹ 59 more rows
```

This is commonly used in data science to split up a dataset. For example, suppose you wanted to randomly partition your data into an 80% training and 20% testing set. You can first use [`sample(n,x)`{.R}](https://rdrr.io/r/base/sample.html) to randomly select `x` rows out of `n`, then use both positive and negative row subsetting syntax to get both partitions:


``` r
# define n as total number of rows
n <- nrow(eruptions_recent)
# randomly sample 20% of numbers from 1 to n as test rows
# (sample auto-rounds inputs down to integers if they're not whole)
test_rows <- sample(n, 0.2*n)
test_rows
```

```
 [1] 68 39  1 34 43 14 59 51 21 54  7  9 15 67 37
```

``` r
# split dataset using the subsetting syntax we just learned
eruptions_recent_test  <- eruptions_recent[ test_rows, ]
eruptions_recent_train <- eruptions_recent[-test_rows, ]
eruptions_recent_test
```

```
# A tibble: 15 × 7
   volcano                  start      stop       duration confirmed   vei start_year
   <chr>                    <date>     <date>        <dbl>     <dbl> <dbl>      <dbl>
 1 Shishaldin               2004-02-17 2004-07-16      150         1     2       2004
 2 Cleveland                2010-09-11 2010-09-12        1         0    NA       2010
 3 Kīlauea                  2024-09-15 2024-09-20        5         1    NA       2024
 4 Mariana Back-Arc Segmen… 2013-02-13 2015-12-01     1021         1     0       2013
 5 Cleveland                2009-10-02 2009-12-12       71         1     2       2009
 6 Semisopochnoi            2021-02-02 2023-05-05      822         1     2       2021
 7 Cleveland                2006-02-06 2006-10-28      264         1     3       2006
 8 Anatahan                 2007-11-27 2008-08-09      256         1     2       2007
 9 Great Sitkin             2019-06-01 2019-06-07        6         1     1       2019
10 Pagan                    2006-12-04 2006-12-08        4         1     1       2006
11 Shishaldin               2023-07-11 2023-11-03      115         1     3       2023
12 Ahyi                     2022-11-18 2023-06-11      205         1     1       2022
13 Kīlauea                  2020-12-20 2021-05-23      154         1     0       2020
14 Anatahan                 2004-04-12 2005-09-03      509         1     3       2004
15 Cleveland                2011-07-19 2015-08-18     1491         1     2       2011
```

``` r
eruptions_recent_train
```

```
# A tibble: 60 × 7
  volcano               start      stop       duration confirmed   vei start_year
  <chr>                 <date>     <date>        <dbl>     <dbl> <dbl>      <dbl>
1 Kīlauea               2024-06-03 2024-06-03        0         1    NA       2024
2 Atka Volcanic Complex 2024-03-27 2024-03-27        0         1    NA       2024
3 Ahyi                  2024-01-01 2024-03-27       86         1    NA       2024
4 Kanaga                2023-12-18 2023-12-18        0         1     1       2023
5 Ruby                  2023-09-14 2023-09-15        1         1     1       2023
6 Mauna Loa             2022-11-27 2022-12-10       13         1     0       2022
# ℹ 54 more rows
```

If you ever need to recombine them, just use `rbind()` which will bind rows together from multiple data frames, as long as they have the exact same columns (both name and type).


``` r
# note the resulting rows will be in a different order,
# but it's the same data frame we started out with
eruptions_recent_recombined <- rbind(eruptions_recent_test, eruptions_recent_train)
eruptions_recent_recombined
```

```
# A tibble: 75 × 7
  volcano                   start      stop       duration confirmed   vei start_year
  <chr>                     <date>     <date>        <dbl>     <dbl> <dbl>      <dbl>
1 Shishaldin                2004-02-17 2004-07-16      150         1     2       2004
2 Cleveland                 2010-09-11 2010-09-12        1         0    NA       2010
3 Kīlauea                   2024-09-15 2024-09-20        5         1    NA       2024
4 Mariana Back-Arc Segment… 2013-02-13 2015-12-01     1021         1     0       2013
5 Cleveland                 2009-10-02 2009-12-12       71         1     2       2009
6 Semisopochnoi             2021-02-02 2023-05-05      822         1     2       2021
# ℹ 69 more rows
```
