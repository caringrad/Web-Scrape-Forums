library(rvest)
library(stringr)

# INPUTS

# input the page number you want to count
page_num <- 20

# base URL of the phpBB thread without the 'start' parameter
base_url <- "INSERT HERE"

# -----------------------------------

# function to simplify getting thread URL
get_thread_url <- function(url) {
  
  thread_url <- paste0(
    url,
    "&start=",
    as.character((page_num - 1) * 15))

}

# function to count words in a string
count_words <- function(text) {
  word_list <- unlist(str_split(text, "\\W"))
  word_list <- word_list[word_list != ""]
  return(length(word_list))
}

# function to scrape and count words from a phpBB thread
scrape_phpbb_thread <- function(url) {
  
  # load the HTML content of page
  webpage <- read_html(url)
  
  # extract the text content of the posts
  posts_text <- webpage %>%
    html_nodes(".post-text") %>%
    html_text(trim = FALSE) %>%
    # replace newline characters with spaces
    sapply(function(x) gsub("\n", " ", x)) 
  
  # concatenate all posts into words
  all_posts_text <- paste(posts_text, collapse = " ")
  
  # count the words
  word_count <- count_words(all_posts_text)
  
  return(word_count)
}

# get URL
thread_url <- get_thread_url(base_url)

# Get the word count
word_count <- scrape_phpbb_thread(thread_url)

# Print the word count
print(paste("Word count:", word_count))
