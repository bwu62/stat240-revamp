# example R options set globally
options(width = 60)

# example chunk options set globally
knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE
  )

library(tidyverse)
library(lubridate)
library(rvest)

# detect which semester we're headed into
# and fix an R-version to use

today = today()

season = case_when(
  month(today)<5~"Spring",
  month(today)<8~"Summer",
  TRUE~"Fall"
)

semester = str_c(year(today),"-",season)

r.date = case_when(
  season=="Spring"~"1-19",
  season=="Summer"~"6-14",
  TRUE~"9-2"
) %>% paste(year(today)) %>% 
  mdy %>% min(today)

r.releases = 
  "https://en.wikipedia.org/wiki/R_(programming_language)" %>% 
  read_html %>% 
  html_nodes(xpath="//table[contains(caption,'codenames')]") %>%
  {html_table(.)[[1]][1:2]} %>% 
  setNames(c("version","date")) %>% 
  head(10) %>% mutate(date=ymd(date))

r.latest = r.releases %>% 
  filter(date<=r.date) %>% slice_max(date,n=1)

r.version = r.latest$version
r.date = r.latest$date

apache.find = function(url,pattern,n=1){
  matching = url %>% 
    read_html() %>% 
    html_nodes("a") %>% 
    html_attrs %>% 
    unlist %>% 
    unname %>% 
    str_subset("^[:alnum:]") %>% 
    str_subset(pattern)
  if(length(matching)>n) stop("Wrong match length!")
  paste0(url,matching)
}

page.find = function(url,pattern,md=F,n=1){
  matching = url %>% 
    read_html() %>% 
    html_nodes("a") %>% 
    html_attrs %>% 
    unlist %>% 
    unname %>% 
    str_subset("\\.[:alnum:]+$") %>% 
    str_subset(pattern) %>% 
    {ifelse(str_starts(.,"http"),.,paste0(url,.))}
  if(length(matching)>n) stop("Wrong match length!")
  if(!md){
    matching
  } else{
    paste0("[",str_replace(matching,".*/",""),"](",matching,")")
  }
}
