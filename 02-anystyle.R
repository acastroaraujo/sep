
# setup -------------------------------------------------------------------

library(tidyverse)

entries <- readRDS("data/entries.rds")
entries$raw <- readRDS("data/raw.rds")

# anystyle ----------------------------------------------------------------

# https://github.com/inukshuk/anystyle
# https://github.com/inukshuk/anystyle-cli

# Type this into the terminal:
# gem install anystyle-cli --user-install

parse_bib <- function(x) {
  filename <- stringr::str_glue("{tempfile()}.txt")
  readr::write_file(paste(x, collapse = "\n\n"), filename)
  out <- system(
    command = stringr::str_glue("anystyle --stdout -f json parse {filename}"), 
    intern = TRUE
  ) |> 
  jsonlite::fromJSON() 
  out$auth_dash <- stringr::str_detect(x, "^–––")
  return(out)
}

output <- vector("list", nrow(entries))

for (i in seq_along(output)) {
  output[[i]] <- parse_bib(entries$raw[[i]][["bib"]])
  output[[i]]$slug <- entries$slug[[i]]
}

write_rds(list_rbind(output), "data/bib.rds", compress = "xz")
