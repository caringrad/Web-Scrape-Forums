library(rvest)
library(stringr)
library(purrr)

# INPUTS

# base URL of the phpBB thread without the 'start' parameter
base_url <- "INSERT HERE"

# parameters for the loop
start_page <- 0 # first page
end_page <- 285 # last page
page_step <- 15 # assuming each page has 15 posts (adjust as needed)

# -----------------------------------

# function to count words in a string
count_words <- function(text) {
  word_list <- unlist(str_split(text, "\\W"))
  word_list <- word_list[word_list != ""]
  return(length(word_list))
}

# function to scrape and count words from phpBB thread page
scrape_phpbb_thread_page <- function(url) {
  
  # load the HTML content of the webpage
  webpage <- read_html(url)
  
  # extract the text content of the posts
  posts_text <- webpage %>%
    html_nodes(".post-text") %>%
    map_chr(~html_text(.x, trim = TRUE)) %>%
    # replace line breaks with a space
    str_replace_all("\n", " ")
  
  # concatenate all posts into words
  all_posts_text <- paste(posts_text, collapse = " ")
  
  # count the words
  word_count <- count_words(all_posts_text)
  
  return(word_count)
}

# function to iterate over pages and sum word counts
scrape_phpbb_thread <- function(base_url, start, end, step) {
  
  # initializing
  total_word_count <- 0
  
  for (i in seq(start, end, by = step)) {
    # get URL for each page
    page_url <- paste0(base_url, "&start=", i)
    # sum word count for each page
    total_word_count <- total_word_count + scrape_phpbb_thread_page(page_url)
  }
  
  return(total_word_count)
}

# get the total word count for all pages
total_word_count <- scrape_phpbb_thread(base_url, start_page, end_page, page_step)

# print the total word count
print(paste("Total word count:", total_word_count))
