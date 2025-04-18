#' Return Chrome CLI arguments
#'
#' This is a helper function which returns arguments to be passed to Chrome.
#' This function tests whether the code is running on shinyapps and returns the
#' appropriate Chrome extra arguments.
#'
#' @param default_args Arguments to be used in any circumstances.
#'
#' @return A character vector with CLI arguments to be passed to Chrome.
chrome_extra_args <- function(default_args = c("--disable-gpu")) {
  args <- default_args
  # Test whether we are in a shinyapps container
  if (identical(Sys.getenv("R_CONFIG_ACTIVE"), "shinyapps")) {
    args <- c(args,
              "--no-sandbox", # required because we are in a container
              "--disable-dev-shm-usage") # in case of low available memory
  }
  args
}


#' render short pdf document
#' @param name_input Name of the CV
#' @param path_input Path to the excel file with the CV data
#' @param eval_***   Sections to include into the CV

render_cv_short <- function(name_input,
                            path_input,
                            eval_text,
                            eval_ski,
                            eval_lan,
                            eval_edu,
                            eval_emp,
                            eval_tea,
                            eval_pub,
                            eval_pck,
                            eval_app) {
  
  input <- rmarkdown::render("cv_short.rmd",
                             params = list(cv_name = name_input,
                                           data_path = path_input,
                                           summary = eval_text,
                                           skills = eval_ski,
                                           languages = eval_lan,
                                           education = eval_edu,
                                           employment = eval_emp,
                                           teaching = eval_tea,
                                           publications = eval_pub,
                                           packages = eval_pck,
                                           apps = eval_app),
                             encoding = "UTF-8")
  pagedown::chrome_print(input = input,
                         output = tempfile(fileext = ".pdf"),
                         extra_args = chrome_extra_args(),
                         # options = list(scale = 0.7, preferCSSPageSize = FALSE)
                         verbose = 1,
                         async = TRUE # returns a promise
  )
}
