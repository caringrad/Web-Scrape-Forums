library(rvest)
library(stringr)
library(xml2)
library(rmarkdown)

# INPUTS

# base URL of the phpBB thread without the 'start' parameter
base_url <- "INSERT HERE"

# parameters for the loop
start_page <- 0 # first page
end_page <- 285 # last page
page_step <- 15 # assuming each page has 15 posts (adjust as needed)

# output file path - make it a ".txt" document
output_path <- "INSERT HERE"

# example for output path, assuming an output folder:
# "outputs/Book Name.txt"

# -----------------------------------

# function to format each post as a chapter
format_chapter <- function(post, chapter_number) {
  chapter_header <- paste("\n\n\n--- CHAPTER (", chapter_number, ") ---\n\n", sep = "")
  return(paste(chapter_header, post))
}

# function to scrape and format posts from phpBB thread page
scrape_and_format_phpbb_thread_page <- function(url, chapter_counter) {
  
  # load the HTML content of the page
  webpage <- read_html(url)
  
  # get HTML content of the posts, preserve line breaks
  posts_html <- webpage %>%
    html_nodes(".post-text")
  
  # use html_text2 to preserve whitespace
  posts_text <- sapply(posts_html, html_text2)
  
  # format each post as a chapter
  chapters <- mapply(
    format_chapter,
    posts_text,
    chapter_counter + seq_along(posts_text) - 1
  )
  
  return(list(chapters = chapters, next_chapter_number = max(chapter_counter + length(posts_text))))
}

# function to iterate over pages, concatenate chapters
scrape_and_format_phpbb_thread <- function(base_url, start, end, step) {
  
  all_chapters <- c()
  chapter_counter <- 0
  
  # process and update the chapter counter
  for (i in seq(start, end, by = step)) {
    
    page_url <- paste0(base_url, "&start=", i)
    
    result <- scrape_and_format_phpbb_thread_page(page_url, chapter_counter)
    all_chapters <- c(all_chapters, result$chapters)
    chapter_counter <- result$next_chapter_number
  }
  
  return(paste(all_chapters, collapse = ""))
}

# create the book
book <- scrape_and_format_phpbb_thread(base_url, start_page, end_page, page_step)

# write the book to a text file
output_file_path <- file.path(output_path)
writeLines(book, output_file_path)

# print the first few lines of the book to confirm
cat(substr(book, 1, 1000))