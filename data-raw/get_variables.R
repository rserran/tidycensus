library(xml2)
library(jsonlite)
library(rvest)
library(tidyverse)
library(stringr)

require_census_api_key <- function() {
  key <- Sys.getenv("CENSUS_API_KEY")

  if (!nzchar(key)) {
    stop("Set CENSUS_API_KEY before running this data-raw script.", call. = FALSE)
  }

  key
}

census_api_url <- function(path) {
  paste0(
    "https://api.census.gov/data/",
    path,
    "?key=",
    URLencode(require_census_api_key(), reserved = TRUE)
  )
}

fetch_sfvars <- function(year) {

  url <- census_api_url(paste0(as.character(year), "/acs/acs5/variables.html"))

  dat <- url %>%
    html() %>%
    html_nodes("table") %>%
    html_table(fill = TRUE)

  out <- paste0("data/sf_",
                as.character(year),
                ".rds")

  write_rds(dat, out)

}

walk(2009:2015, fetch_sfvars)


fetch_censusvars <- function(dataset) {

  url <- census_api_url(paste0(dataset, "/variables.html"))

  dat <- url %>%
    html() %>%
    html_nodes("table") %>%
    html_table(fill = TRUE)

  year <- str_sub(dataset, 1, 4)

  sf <- str_sub(dataset, -3)

  out <- paste0("data/",
                sf, "_", year,
                ".rds")

  write_rds(dat, out)

}

sets <- c("2010/sf1", "2000/sf1", "2000/sf3",
          "1990/sf1", "1990/sf3")


walk(sets, fetch_censusvars)





j <- fromJSON(census_api_url("2015/acs/acs5/variables.json"))


url <- census_api_url("2009/acs/acs5/variables.html")

f15 <- url %>%
  html() %>%
  html_nodes("table") %>%
  html_table(fill = TRUE)

b <- f15[[1]]


x <- read_xml(census_api_url("2015/acs/acs5/variables.xml"))
