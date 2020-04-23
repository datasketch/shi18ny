

#' Add images to dropdown options
#'
#' This function works only with bootstrap for now. Borrowed from
#' the package shinyinvoer.
#'
#' @param inputId The input slot that will be used to access the value.
#' @param choices List of values to select from, when named the names are
#'   appended to the right of the image.
#' @param images List of image location that can be put in a src attribute.
#' @param placeholder HTML to render as placeholder, defaults to empty div.
#' @param width width in of input.
#'
#' @export
selectLangInput <- function(inputId, label, langs,
                            flags = NULL,
                            show_flags = TRUE,
                            selected = 1,
                            placeholder = NULL,
                            width = 100) {
  if(show_flags){
    flags <- flags %||% get_flags_image(langs)
  }
  selectImageInput(inputId, label = label, choices = langs,
                   images = flags, selected = selected, placeholder = placeholder,
                   width = width)

}


get_flags_image <- function(langs){
  flags <- list.files(system.file("flags","png",package = "shi18ny"), full.names = TRUE)
  names(flags) <- basename(tools::file_path_sans_ext(flags))
  flags <- flags[langs]
  image_data <- unlist(lapply(flags, function(flag){
    knitr::image_uri(flag)
  }))
}

#' @export
updateSelectLangInput <- function(session, inputId, label = NULL, langs = NULL,
                                  flags = NULL,
                                  show_flags = TRUE,
                                  selected = NULL){
  if(show_flags){
    flags <- flags %||% get_flags_image(langs)
  }
  updateSelectImageInput(session, inputId, label = label, choices = langs,
                   images = flags, selected = selected)

}


