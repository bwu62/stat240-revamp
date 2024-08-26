

# (APPENDIX) Appendix {.unnumbered}

# Datasets



This page contains updating/processing scripts and additional info on all datasets used for the course, as well as some brief discussions of why they were chosen. Datasets are ordered by order of appearance in the notes.

Also, since this is mostly for me to keep track of datasets and processing scripts, it's not as meticulously formatted like the rest of the notes, e.g. lines of code are not kept to ~80 characters, and comments may be brief, again they're for me not you. I may also use more advanced syntax or additional packages. Read at your own discretion.



``` r
library(tidyverse)
library(rvest)
library(lubridate)
library(xlsx)
```


## List of datasets {#datasets-list}

Here's a convenient list of all dataset files generated. Note that **not ALL files are used in the notes!**. These are primarily for my own record keeping purposes. Also note that some files may automatically open a download prompt while others may not. To force download, right click on a file link and choose "Save link as".

 - [`enrollment.csv`](data/enrollment.csv)
 - [`eruptions_recent.csv`](data/eruptions_recent.csv)
 - [`eruptions_recent.delim`](data/eruptions_recent.delim)
 - [`eruptions_recent.tsv`](data/eruptions_recent.tsv)
 - [`eruptions_recent.xlsx`](data/eruptions_recent.xlsx)
 - [`fertility_meta.csv`](data/fertility_meta.csv)
 - [`fertility_raw.csv`](data/fertility_raw.csv)
 - [`fertility.csv`](data/fertility.csv)
 - [`penguins.csv`](data/penguins.csv)

Alternatively, you can also run the following line, which will **download ALL files above to your current working directory**. It's recommended to first set your working directory to an appropriate place before running this, e.g. to the `data/` directory in your `STAT240/` course folder.


``` r
lapply(readLines("https://bwu62.github.io/stat240-revamp/data_list.txt"),
       \(.)download.file(.,basename(.)))
```



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
  set_names(c("volcano","start","stop","confirmed","vei"))
```

### Process data


``` r
eruptions <- eruptions_raw %>% 
  mutate(
    volcano = str_replace(volcano,"°","°"),
    # convert confirmed? column to logical
    confirmed = if_else(replace_na(confirmed,"NA")=="Confirmed",T,F),
    # replace continuing eruptions with today's date
    # (continuation last validated 7/23/24)
    stop = if_else(str_detect(stop,"continu"),format(today(),"%Y %b %e"),stop,missing=stop)
  ) %>% 
  # extract date error to new column
  separate(start,c("start","start_error"),"±") %>% 
  separate(stop,c("stop","stop_error"),"±") %>% 
  mutate(
    # fix a few names
    volcano = volcano %>% str_replace("Asuncion","Asunción") %>% str_replace("Pajaros","Pájaros") %>% str_replace("Kilauea","Kīlauea"),
    # parse error time string to number of days
    start_error = as.duration(start_error)/ddays(1),
    stop_error = as.duration(stop_error)/ddays(1),
    # extract start year since some earlier eruptions are missing month/day
    start_year = str_extract(start,"(\\d{4,5})"),
    stop_year = str_extract(stop,"(\\d{4,5})"),
    # parse start year, adding - if BCE
    start_year = as.numeric(start_year) * if_else(str_detect(start,"BCE"),-1,1),
    stop_year = as.numeric(stop_year) * if_else(str_detect(stop,"BCE"),-1,1),
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
  select(volcano,start,start_error,start_year,stop,stop_error,stop_year,duration,confirmed,vei)

# get just subset for demo
eruptions_recent <- eruptions %>% 
  filter(start_error <= 30, start_year > 2000, !is.na(stop)) %>% 
  select(-contains("_"))
```

### Write out data


``` r
# save complete file too
write_csv(eruptions,file="data/eruptions.csv")

# write out to different formats for reading
write_csv(eruptions_recent,file="data/eruptions_recent.csv")
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



### Inspect data


``` r
eruptions_recent
```

```
# A tibble: 73 × 6
   volcano               start      stop       duration confirmed   vei
   <chr>                 <date>     <date>        <dbl> <lgl>     <dbl>
 1 Kīlauea               2024-06-03 2024-06-03        0 TRUE         NA
 2 Atka Volcanic Complex 2024-03-27 2024-03-27        0 TRUE         NA
 3 Ahyi                  2024-01-01 2024-03-27       86 TRUE         NA
 4 Kanaga                2023-12-18 2023-12-18        0 TRUE          1
 5 Ruby                  2023-09-14 2023-09-15        1 TRUE          1
 6 Shishaldin            2023-07-11 2023-11-03      115 TRUE          3
 7 Mauna Loa             2022-11-27 2022-12-10       13 TRUE          0
 8 Ahyi                  2022-11-18 2023-06-11      205 TRUE          1
 9 Kīlauea               2021-09-29 2023-09-16      717 TRUE          0
10 Pavlof                2021-08-05 2022-12-07      489 TRUE          2
# ℹ 63 more rows
```

<!--

### Scrape volcanoes info


``` r
nums <- c(332010, 311160, 284141, 311110, 284202, 311360, 332020, 312030, 284170,
         311120, 312070, 311060, 311240, 311300, 284305, 284193, 313030, 311130,
         311290, 284200, 312260, 313010, 321050, 284211, 244000, 315020, 312110,
         311190, 311070, 331031, 332000, 311310, 311180, 311320, 313040, 311340,
         311020, 311230, 284210, 312060, 284133, 312131, 284134, 312160, 311270,
         332080, 313020, 312140, 284140, 312150, 314010, 312090, 311210, 311260,
         284150, 284160, 323080, 311080, 312170, 312180, 323020, 321030, 323110,
         284180, 321010, 284190, 322010, 244010, 312130, 311350, 311050, 332040,
         311390, 332060, 312200, 321020, 311090, 323120, 327050, 323150, 323010,
         313050, 329010, 329020, 327040, 321040, 322020, 315030, 322110, 322030,
         322060, 244020, 322070, 314060, 323200, 324020, 323160, 324030, 312100,
         322040, 315001, 311140, 327120, 322190, 311111, 312190, 312050, 312080,
         328010, 331040, 315040, 332030, 322100, 322160, 324040, 327110, 312250,
         322170, 321060, 322090, 321070, 311380, 324010, 327812, 323170)

get_volc_info <- function(num){

  source <- "https://volcano.si.edu/volcano.cfm?vn={num}&vtab=Eruptions" %>%
    str_glue() %>%
    read_html()

  name <- source %>%
    html_nodes(xpath="//div[@class='volcano-title-container']/h3/text()") %>%
    HTMLdecode()

  info <- source %>%
    html_nodes(xpath="//div[@class='volcano-info-table']//li//text()") %>%
    as.character() %>%
    {setNames(.[1:4],.[5:8])}

  subinfo <- source %>%
    html_nodes(xpath="//div[@class='volcano-subinfo-table']//li[position()<5]//text()") %>%
    as.character() %>%
    {setNames(.[1:4],.[5:8])}

  c(name=name,info,subinfo)
}

library(parallel)
cl <- makeCluster(detectCores()-1)
clusterExport(cl,c("nums","get_volc_info"))
volcanoes_raw <- mclapply(nums,get_volc_info) %>% as.data.frame %>% unname %>% t %>% as.data.frame
stopCluster(cl)
write_csv(volcanoes_raw,"data/volcanoes_raw.csv")
```

### Process volcano info


``` r
volcanoes <- volcanoes_raw %>% 
  # these are already only US volcanoes, and Summit is just Elevation in meters
  select(-Country,-Summit) %>% 
  set_names(c("volcano","region","landform_type","last_known_eruption","latitude","longitude","summit_ft")) %>% 
  mutate(landform_type = str_replace_all(landform_type,"\\(\\w+\\)|\\?",""),
         last_known_eruption = parse_number(last_known_eruption) * if_else(str_detect(last_known_eruption,"BCE"),-1,1),
         latitude = parse_number(latitude) * if_else(str_detect(latitude,"S"),-1,1),
         longitude = parse_number(longitude) * if_else(str_detect(longitude,"W"),-1,1),
         summit_ft = parse_number(summit_ft) * if_else(volcano=="Ruby",-1,1)) %>% 
  separate(landform_type,into=c("landform","type"),sep=" \\| ") %>% 
  mutate(underwater = summit_ft < -131)
```

### Write out volcanoes info


``` r
write_csv(volcanoes,"data/volcanoes.csv")
```



### Inspect volcanoes info


``` r
volcanoes
volcanoes_raw
```

### Augment eruptions


``` r
eruptions_recent2 <- volcanoes %>% 
  select(volcano, landform, type, summit_ft, underwater) %>% 
  right_join(eruptions_recent,.)

write_csv(eruptions_recent2, file="data/eruptions_recent2.csv")
```




``` r
# print all columns
options(width=93)
eruptions_recent2
options(width=80)
```

-->

## Palmer penguins

For the data visualization, I wanted a more feature rich dataset with a healthy combination of numerics and characters that is ready to go, easy to use, fun & interesting, and would make good looking plots for the demos. I spent too long brainstorming ideas, including scraping additional info on the volcanoes, but wasn't happy with the result. Then, while looking for inspiration, I found through Hadley Wickham's excellent [R4DS book](https://r4ds.hadley.nz/data-visualize) the [Palmer penguins](https://allisonhorst.github.io/palmerpenguins/) dataset, which is absolutely perfect.

Now, I want students to continue practicing reading datasets, so the following code simple extracts the dataset therein and rewrites it out.

### Write out data


``` r
library(palmerpenguins)
write_csv(penguins %>% drop_na,"data/penguins.csv")
```



### Inspect data


``` r
penguins
```

```
# A tibble: 333 × 8
   species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g sex  
   <chr>   <chr>              <dbl>         <dbl>             <dbl>       <dbl> <chr>
 1 Adelie  Torgersen           39.1          18.7               181        3750 male 
 2 Adelie  Torgersen           39.5          17.4               186        3800 fema…
 3 Adelie  Torgersen           40.3          18                 195        3250 fema…
 4 Adelie  Torgersen           36.7          19.3               193        3450 fema…
 5 Adelie  Torgersen           39.3          20.6               190        3650 male 
 6 Adelie  Torgersen           38.9          17.8               181        3625 fema…
 7 Adelie  Torgersen           39.2          19.6               195        4675 male 
 8 Adelie  Torgersen           41.1          17.6               182        3200 fema…
 9 Adelie  Torgersen           38.6          21.2               191        3800 male 
10 Adelie  Torgersen           34.6          21.1               198        4400 male 
# ℹ 323 more rows
# ℹ 1 more variable: year <dbl>
```


## College enrollment


``` r
last.yy <- tryCatch({
  rvest::read_html("https://nces.ed.gov/programs/digest/current_tables.asp") %>%
  rvest::html_nodes(xpath="//select[@name='quickjump']/option[2]/text()") %>% 
  as.character %>% as.numeric
},error = function(e){
  (lubridate::year(Sys.Date()-3*30)-1)
}) %% 100
```

I also briefly needed a nice time series dataset with more than 1 groups to demonstrate line plots. Eventually I settled on [table 303.10](https://nces.ed.gov/programs/digest/d23/tables/dt23_303.10.asp) of the National Center for Education Statistics (NCES) which contains historic college enrollment data, stratified by sex.

### Process data


``` r
enrollment <- "https://nces.ed.gov/programs/digest/d{last.yy}/tables/dt{last.yy}_303.10.asp" %>% 
  str_glue %>% 
  read_html %>% 
  html_nodes(xpath="//div[@class='nces']/table[1]") %>% 
  html_table %>% 
  {.[[1]][-3,]} %>% 
  t %>% as.data.frame %>% 
  rownames_to_column %>% 
  unite("name",1:3) %>% 
  column_to_rownames("name") %>% 
  t %>% as.data.frame %>% 
  select(matches("Year|(Sex.*(Male|Female))|Nonprofit",ignore.case=F)) %>% 
  set_names(c("year","male","female","nonprofit")) %>% 
  mutate(year = str_sub(year,1,4)) %>% 
  mutate_all(parse_number) %>% 
  filter(!(is.na(year)&is.na(male)&is.na(female))&year>20,
         year<year(today())-10|!is.na(nonprofit)) %>% 
  select(-nonprofit) %>% 
  mutate(male = male/1e6, female = female/1e6) %>% 
  pivot_longer(male:female,names_to="sex",values_to="enrolled_millions")
```

### Write out data


``` r
write_csv(enrollment, file="data/enrollment.csv")
```

### Inspect data




``` r
enrollment
```

```
# A tibble: 146 × 3
    year sex    enrolled_millions
   <dbl> <chr>              <dbl>
 1  1947 male               1.66 
 2  1947 female             0.679
 3  1948 male               1.71 
 4  1948 female             0.694
 5  1949 male               1.72 
 6  1949 female             0.723
 7  1950 male               1.56 
 8  1950 female             0.721
 9  1951 male               1.39 
10  1951 female             0.711
# ℹ 136 more rows
```



## Fertility rate

For the advanced data operations section I needed something that is suitable for demonstrating grouping, joining, and pivoting, and again hopefully interesting. I found the [World Bank fertility rate](https://data.worldbank.org/indicator/SP.DYN.TFRT.IN) dataset to be quite suitable for this purpose. This dataset will be presented in 2 ways, first a fully cleaned version for grouping, then a partially cleaned version for joining and pivoting.


### Process data


``` r
if(!dir.exists("temp")) dir.create("temp")
f <- "temp/fertility.zip"
download.file("https://api.worldbank.org/v2/en/indicator/SP.DYN.TFRT.IN?downloadformat=csv",f,mode="wb")
files = unzip(f, list=T)$Name %>% str_subset("Indicator",negate=T)
unzip(f,files,exdir="temp/")
fertility_meta <- str_subset(list.files("temp/",full=T),"^temp/Meta.*API_SP.DYN.TFRT") %>% read_csv
skip = str_subset(list.files("temp/",full=T),"^temp/API_SP.DYN.TFRT") %>% read_lines %>% 
  str_detect("Country Name") %>% which %>% min %>% subtract(1)
fertility_raw <- str_subset(list.files("temp/",full=T),"^temp/API_SP.DYN.TFRT") %>% read_csv(skip=skip)
```


``` r
# simplify/shorten some names for convenience
fertility_meta <- fertility_meta %>% mutate(
  TableName = TableName %>% 
    str_replace_all(c(
      " and the " = " & ",
      " and " = " & ",
      ", The" = "",
      "SAR, China" = "",
      "Korea, Rep." = "South Korea",
      "British Virgin Islands" = "Virgin Islands",
      "Russian Federation" = "Russia",
      " \\(.*" = "",
      "Slovak Republic" = "Slovakia",
      "Iran, Islamic Rep." = "Iran",
      "Brunei Darussalam" = "Brunei",
      "Korea, Dem. People's Rep." = "North Korea",
      "Cabo Verde" = "Cape Verde",
      "Türkiye" = "Turkey",
      "Viet Nam" = "Vietnam",
      "Lao PDR" = "Laos",
      "Micronesia, Fed. Sts." = "Micronesia",
      "Syrian Arab Republic" = "Syria",
      "Kyrgyz Republic" = "Kyrgyzstan",
      "Egypt, Arab Rep." = "Egypt",
      "Timor-Leste" = "East Timor",
      "Yemen, Rep." = "Yemen",
      "Côte d'Ivoire" = "Ivory Coast"
    ))
)

# remove some extra columns with only NAs?

fertility_meta <- fertility_meta %>% select(where(\(x)mean(is.na(x))<1))
fertility_raw <- fertility_raw %>% select(where(\(x)mean(is.na(x))<1))
```

### Write out raw data


``` r
write_csv(fertility_meta, file="data/fertility_meta.csv")
write_csv(fertility_raw, file="data/fertility_raw.csv")
```



### Process more <small>(tidy version)</small>


``` r
fertility_meta <- fertility_meta %>% filter(!is.na(IncomeGroup)) %>% 
  rename(code = "Country Code", country = "TableName", region = "Region", income_group = "IncomeGroup") %>% 
  select(code, country, region, income_group)

fertility <- fertility_raw %>% select(-matches("Indicator|Name|^\\.\\.")) %>% 
  rename(code = "Country Code") %>% inner_join(fertility_meta) %>%
  pivot_longer(matches("^\\d+"),names_to="year",values_to="rate") %>% 
  # mutate(income_group = factor(str_replace(income_group," income",""),ordered = T, levels=c(
  #   "Low", "Lower middle", "Upper middle", "High"))) %>%
  arrange(country,year)
```


``` r
# # show pct NA for each country with NAs
# fertility %>% group_by(country) %>% summarize(pctna = round(100*mean(is.na(rate)))) %>% filter(pctna>0) %>% arrange(-pctna)
# # show all years for these countries to see pattern of NAs
# fertility %>% group_by(country) %>% mutate(pctna = 100*mean(is.na(rate))) %>% ungroup %>% 
#   filter(pctna>0) %>% arrange(-pctna) %>% pivot_wider(names_from = year,values_from = rate) %>% View

# based on exploration, let's just drop the small number of country/year combos with NAs for simplicity
fertility <- fertility %>% drop_na()
```

### Write out tidy data


``` r
write_csv(fertility, "data/fertility.csv")
```



### Inspect data


``` r
fertility
```


