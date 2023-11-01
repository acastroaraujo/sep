
library(rvest)
library(tibble)
library(dplyr)

entries <- read_html("https://plato.stanford.edu/published.html")

entries <- entries |> 
  html_elements(css = "#content li") 

href <- entries |> 
  html_elements("a") |> 
  html_attr("href")

title <- entries |> 
  html_elements("strong") |> 
  html_text()

date <- entries |> 
  html_elements("a+ em") |> 
  html_text()

d <- tibble(title, date, href) |> 
  mutate(date = lubridate::mdy(date)) |> 
  mutate(slug = str_remove(href, "https://plato.stanford.edu/entries")) |> 
  select(!href)

readr::write_rds(d, "data/entries.rds")
