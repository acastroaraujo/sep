
library(tidyverse)
library(rvest)

d <- readRDS("data/entries.rds")
output <- vector("list", nrow(d))

for (i in seq_along(output)) {
  
  website <- read_html(str_glue("https://plato.stanford.edu/entries{d$slug[[i]]}"))
  
  preamble <- website |> 
    html_elements("#preamble") |> 
    html_text()
  
  main <- website |> 
    html_elements("#main-text") |> 
    html_text()
  
  bib <- website |> 
    html_elements("#bibliography .hanging") |> 
    html_text() |> 
    str_split("\n\n") |> 
    unlist() |> 
    str_squish()
  
  related <- website |> 
    html_elements("#related-entries a") |> 
    html_attr("href") |> 
    str_remove("\\.\\.")
  
  output[[i]] <- list(preamble = preamble, main = main, bib = bib, related = related)
  
  cat(i, "\r")
  Sys.sleep(runif(1, min = 1, max = 2))
  
}

write_rds(output, "data/raw.rds", compress = "xz")

