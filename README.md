# Forum Thread to Book Converter

This project offers a script for converting phpBB forum threads into a structured book format, where each post is treated as a distinct chapter. Additionally, the script is capable of calculating both the word count per page and the total word count across all pages, providing metrics about the thread's content.

### Features
- **Chapter Formatting:** Transforms each post into a chapter within a "book."
- **Word Count Metrics**: Calculates word count for each page and provides a total word count for all pages.

### Prerequisites
Ensure you have the following installed:
- R programming environment
- RStudio (recommended)

## How to Run the Code

1. **Clone the Repository**: Use Git to clone the repository to your local machine.
2. **Navigate to Project Directory**: Change to the directory where the project is cloned.
3. **Package Management**: Run `renv::init()` in the R console. `renv` will automatically install the required packages (`rvest`, `stringr`, `xml2`) as specified in the renv.lock file, ensuring a consistent environment.
4. **Executing Scripts**:
   - Adjust the input parameters (base_url, start_page, end_page, page_step) at the top of the script to target the specific forum thread you wish to convert.
   - Execute the script. The output includes a text file with the forum content formatted into chapters, a word count per page, and a total word count.
