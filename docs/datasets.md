

# (APPENDIX) Appendix {.unnumbered}

# Datasets



This page contains updating/processing scripts and additional info on all datasets used for the course, as well as some brief discussions of why they were chosen. Datasets are ordered by order of appearance in the notes.

Also, since this is mostly for me to keep track of datasets and processing scripts, it's not as meticulously formatted like the rest of the notes, e.g. lines of code are not kept to ~80 characters, and comments may be brief, again they're for me not you. I may also use more advanced syntax or additional packages. Read at your own discretion.



``` r
library(tidyverse)
library(rvest)
library(lubridate)
library(xlsx)
options(pillar.print_min=20)
options(width=75)
if(!dir.exists("data/")) dir.create("data/")
```


## List of datasets

Here's a convenient list of all dataset files generated.

 - [`eruptions_recent.csv`](data/eruptions_recent.csv)
 - [`eruptions_recent.delim`](data/eruptions_recent.delim)
 - [`eruptions_recent.tsv`](data/eruptions_recent.tsv)
 - [`eruptions_recent.xlsx`](data/eruptions_recent.xlsx)
 - [`eruptions_recent2.csv`](data/eruptions_recent2.csv)



## Eruptions

For introducing reading CSVs, I wanted a dataset with all 4 data types we discussed (numeric, logical, character, and date) and was interesting enough, but without too many columns or rows, and without any problems that would add to complexity since we're just starting out. The [volcanic eruptions](https://volcano.si.edu/volcanolist_countries.cfm?country=United%20States) dataset (specifically the "Holocene Eruptions") table seemed to fit the bill nicely.


### Load raw data


``` r
# load html source code
eruptions_raw <- read_html("https://volcano.si.edu/volcanolist_countries.cfm?country=United%20States") %>% 
  # extract table code
  html_nodes(xpath="//table[@title='Holocene Eruptions']") %>% 
  # convert to data frame
  html_table(header=T,na.strings=c("Uncertain","Unknown","[Unknown]")) %>% 
  # remove list wrapper
  .[[1]] %>% 
  # remove unnecessary evidence column
  select(-Evidence) %>% 
  # make names nice
  set_names(c("name","start","stop","confirmed","vei"))
```


``` r
eruptions <- eruptions_raw %>% 
  mutate(
    name = str_replace(name,"°","°"),
    # convert confirmed? column to logical
    confirmed = if_else(replace_na(confirmed,"NA")=="Confirmed",T,F),
    # replace continuing eruptions with today's date
    # (continuation last validated 7/11/24)
    stop = if_else(str_detect(stop,"continu"),format(today(),"%Y %b %e"),stop,missing=stop)
  ) %>% 
  # extract date error to new column
  separate(start,c("start","start_error"),"±") %>% 
  separate(stop,c("stop","stop_error"),"±") %>% 
  mutate(
    # parse error time string to number of days
    start_error = as.duration(start_error)/ddays(1),
    stop_error = as.duration(stop_error)/ddays(1),
    # extract start year since some earlier eruptions are missing month/day
    start_year = str_extract(start,"(\\d{4,5})"),
    stop_year = str_extract(stop,"(\\d{4,5})"),
    # check if bce
    start_bce = str_detect(start,"BCE"),
    stop_bce = str_detect(stop,"BCE"),
    # parse start year, adding - if bce
    start_year = if_else(start_bce,-as.numeric(start_year),as.numeric(start_year)),
    stop_year = if_else(stop_bce,-as.numeric(stop_year),as.numeric(stop_year)),
    # extract start month
    start_month = str_replace(start,".*\\d{4}\\s([:alpha:]{3}).*","\\1"),
    stop_month = str_replace(stop,".*\\d{4}\\s([:alpha:]{3}).*","\\1"),
    start = start %>% str_replace_all("\\[|\\]|\\(.*?\\)","") %>% str_extract("^\\s?\\d+\\s\\w+\\s\\d+") %>% ymd,
    stop = stop %>% str_replace_all("\\[|\\]|\\(.*?\\)","") %>% str_extract("^\\s?\\d+\\s\\w+\\s\\d+") %>% ymd,
    # if missing date but has month, use middle day +- half-month error
    # first, compute number of days in each month
    start_mdays = days_in_month(ymd(str_c(start_year,start_month,"1"))),
    stop_mdays = days_in_month(ymd(str_c(stop_year,stop_month,"1"))),
    # next, if start/stop NA but month exists, set error as half of number of days in month rounded up, then set no error (NA) as 0
    start_error = if_else(is.na(start) & !is.na(start_month) & is.na(start_error),ceiling(start_mdays/2),start_error) %>% replace_na(0),
    stop_error = if_else(is.na(stop) & !is.na(stop_month) & is.na(stop_error),ceiling(stop_mdays/2),stop_error) %>% replace_na(0),
    # finally, if start/stop NA but month exists, set start/stop as middle day of month rounded down
    start = if_else(is.na(start) & !is.na(start_month),ymd(str_c(start_year,start_month,floor(start_mdays/2))),start),
    stop = if_else(is.na(stop) & !is.na(stop_month),ymd(str_c(stop_year,stop_month,floor(stop_mdays/2))),stop),
    duration = (stop-start)/ddays(1)
  ) %>% 
  # remove intermediate rows
  select(name,start,start_error,start_year,stop,stop_error,stop_year,duration,confirmed,vei)

# get just subset for demo
eruptions_recent <- eruptions %>% 
  filter(start_error <= 30, start_year > 2000, confirmed) %>% 
  select(-contains("_"))

eruptions_recent
```

```
## # A tibble: 71 × 6
##    name                  start      stop       duration confirmed   vei
##    <chr>                 <date>     <date>        <dbl> <lgl>     <int>
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


``` r
# write out to different formats for reading
write_csv(eruptions_recent,file="data/eruptions_recent.csv")
write_csv2(eruptions_recent,file="data/eruptions_recent2.csv")
write_tsv(eruptions_recent,file="data/eruptions_recent.tsv")
write_delim(eruptions_recent,file="data/eruptions_recent.delim",delim="|",na="")
eruptions_recent %>% as.data.frame %>% write.xlsx(file="data/eruptions_recent.xlsx",row.names=F,showNA=F)

# originally line below was b/c I wanted to prep example for read_table but turns out
# its behavior changed recentlyish https://www.tidyverse.org/blog/2021/07/readr-2-0-0/
# it no longer works well here, and read.table needs to be used instead
# (alternatively read_fwf from readr also works but that seems beyond scope)
# but I don't want to confuse students by introducing a mix of readr + base R
# so quitting this example, need to reevaluate in the future importance
# of reading whitespace aligned table formats

# eruptions_recent %>% as.data.frame %>% print(print.gap=2,width=1000,row.names=F,right=F) %>% capture.output() %>% 
#   str_replace("<NA>","NA  ") %>% str_replace("^ *",'"') %>% str_replace("( {2,})",'"\\1') %>% str_replace('"name"',"name  ") %>% write_lines(file="data/eruptions_recent.txt")
```

