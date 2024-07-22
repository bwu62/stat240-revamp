# https://stackoverflow.com/a/4090208/25278020
# ensure necessary packages are installed
list.of.packages = c(
  "devtools", "rmarkdown", "tidyverse",
  "downlit", "bookdown", "DescTools",
  "sn"
)
new.packages <- list.of.packages[!(
  list.of.packages %in% 
    installed.packages()[,"Package"]
)]
if(length(new.packages)) install.packages(new.packages)

tryCatch({
  invisible(grkmisc::pretty_num)
}, error = function(e) {
  devtools::install_github("gadenbuie/grkmisc")
})


# example chunk options set globally
knitr::opts_chunk$set(
  eval=T, echo=T, comment="##", 
  warning=F, message=F, 
  fig.dim=c(6,4), dev="svg"
)


# library(tidyverse)
# library(lubridate)
# library(rvest)
# library(downlit)

# import just the pipe
library(magrittr, include.only = c("%>%"))

# detect which semester we're headed into
# and fix an R-version to use

today = lubridate::today()

season = dplyr::case_when(
  lubridate::month(today)<5~"Spring",
  lubridate::month(today)<8~"Summer",
  TRUE~"Fall"
)

semester = stringr::str_c(
  lubridate::year(today),"-",season)

r.date = dplyr::case_when(
  season=="Spring"~"1-19",
  season=="Summer"~"6-14",
  TRUE~"9-2"
) %>% paste(lubridate::year(today)) %>% 
  lubridate::mdy() %>% min(today)

r.releases = 
  paste0("https://en.wikipedia.org/",
         "wiki/R_(programming_language)") %>% 
  rvest::read_html() %>% 
  rvest::html_nodes(
    xpath=
      "//table[contains(caption,'codenames')]"
    )%>%
  {rvest::html_table(.)[[1]][1:2]} %>% 
  setNames(c("version","date")) %>% 
  head(10) %>% 
  dplyr::mutate(date=lubridate::ymd(date))

r.latest = r.releases %>% 
  dplyr::filter(date<=r.date) %>% 
  dplyr::slice_max(date,n=1)

r.version = r.latest$version
r.date = r.latest$date

apache.find = function(url,pattern,n=1){
  matching = url %>% 
    rvest::read_html() %>% 
    rvest::html_nodes("a") %>% 
    rvest::html_attrs() %>% 
    unlist %>% 
    unname %>% 
    stringr::str_subset("^[:alnum:]") %>% 
    stringr::str_subset(pattern)
  if(length(matching)>n) stop("Wrong length!")
  paste0(url,matching)
}

page.find = function(url,pattern,md=F,n=1){
  matching = url %>% 
    rvest::read_html() %>% 
    rvest::html_nodes("a") %>% 
    rvest::html_attrs() %>% 
    unlist %>% 
    unname %>% 
    stringr::str_subset("\\.[:alnum:]+$") %>% 
    stringr::str_subset(pattern) %>% 
    {ifelse(stringr::str_starts(.,"http"),
            .,paste0(url,.))}
  if(length(matching)>n) stop("Wrong length!")
  if(!md){
    matching
  } else{
    paste0(
      "[",
      stringr::str_replace(matching,".*/",""),
      "](",matching,")")
  }
}


# ## make STAT240 folder for downloading
# dirs.vec = stringr::str_c(
#   "STAT240/",
#   c(
#     "","data/",
#     str_c(
#       "discussion/",
#       c("",
#         stringr::str_glue(
#           "ds{sprintf(1:12,fmt='%02d')}"
#         )
#       )
#     ),
#     str_c(
#       "homework/",
#       c("",
#         stringr::str_glue(
#           "hw{sprintf(1:12,fmt='%02d')}"
#         )
#       )
#     ),
#     "notes/","project/"
#   )
# )
# for(dir in dirs.vec){
#   if(!dir.exists(dir)){
#     dir.create(dir)
#   }
# }

# set a better width
options(width=80)

set.seed(1)
