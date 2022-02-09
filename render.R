library(tidyverse)
library(lubridate)
library(here)
library(rmarkdown)
library(pagedown)
library(fs)
library(gmailr)
library(janitor)
library(googlesheets4)
library(googledrive)


# Auth --------------------------------------------------------------------

options(gargle_oauth_email = "david@rfortherestofus.com")

# Render report -----------------------------------------------------

render(input = "report.Rmd")

# Render slides -----------------------------------------------------

render(input = "slides.Rmd",
       output_file = "index.html")

render(input = "slides.Rmd",
       output_file = "slides.html")

# Email -------------------------------------------------------------------

emails <- read_sheet("https://docs.google.com/spreadsheets/d/1TcMCV2BuiBI_svmpFIAk0LTqBXNbXsrxZakYG8dG9dY/edit#gid=1229185329",
                     sheet = "Responses") %>%
  # Make the variable names easy to work with
  clean_names() %>%
  drop_na(please_enter_your_email_if_you_want_to_receive_a_copy_of_the_survey_report) %>%
  pull(please_enter_your_email_if_you_want_to_receive_a_copy_of_the_survey_report) %>%
  unique()

gm_auth_configure()

send_report <- function(email) {

  gm_mime() %>%
    gm_to(email) %>%
    gm_from("David Keyes <david@rfortherestofus.com>") %>%
    gm_subject("Why R is Magic") %>%
    gm_text_body("Please find the report attached. You can find the slides from today's talk at https://rfor.us/magicslides\n\nCheers,\n\nDavid\n\n* * *\n\nLearn more about R for the Rest of Us at https://rfortherestofus.com") %>%
    gm_attach_file("report.html") %>%
    gm_send_message()

}

emails %>%
  walk(send_report)





