

#' Add images to dropdown options
#'
#' This function works only with bootstrap for now
#'
#' @param inputId The input slot that will be used to access the value.
#' @param choices List of values to select from, when named the names are
#'   appended to the right of the image.
#' @param images List of image location that can be put in a src attribute.
#' @param selected Selected image, defaults to first one.
#' @param placeholder HTML to render as placeholder, overrides selected param.
#' @param width width in of input.
#'
#' Borrowed from the package shinyinvoer
#'
selectImageInput <- function(inputId, label, choices, images = NULL,
                             selected = 1,
                             placeholder = NULL,
                             width = 120) {

  shiny::addResourcePath(
    prefix='selectImage',
    directoryPath=system.file("lib/selectImage",
                              package='shinyinvoer')
  )

  choices_list <- lapply(seq_along(choices), function(x){
    list(id = choices[x],
         image = images[x],
         label = ifelse(is.null(names(choices[x])), 0, names(choices[x]))
    )
  })

  if(is.numeric(selected))
    selected <- choices[selected]
  if(is.null(placeholder)){
    x <- choices_list[[selected]]
    placeholder <- shiny::div(class = "selectImage", shiny::img(src=x$image), x$label)
  }

  input <- jsonlite::toJSON(choices_list, auto_unbox = TRUE)

  shiny::div(
    `data-options` = htmltools::HTML(input),
    `data-selected` = selected,
    id = inputId,
    class = "dropdown",
    style = paste0('width:', width, 'px;'),
    label,
    shiny::tagList(
      shiny::singleton(
        shiny::tags$head(
          shiny::tags$link(rel = 'stylesheet',
                           type = 'text/css',
                           href = 'selectImage/selectImage.css'),
          shiny::tags$script(src = 'selectImage/selectImage-bindings.js')
        )
      )
    ),
  )
}

#' Update select image input
#'
#' @param session Shiny session
#' @param inputId The input slot that will be used to access the value.
#' @param choices List of values to select from, when named the names are
#'   appended to the right of the image.
#' @param images List of image location that can be put in a src attribute.
#' @param selected Selected image, defaults to first one.
#' @param placeholder HTML to render as placeholder, overrides selected param.
#' @param width width in of input.
#'
#' @export
updateSelectImageInput <- function(session, inputId, label = NULL, choices = NULL,
                                    images = NULL, selected = NULL) {
  message <- dropNulls(
    list(
      label = label,
      choices = choices,
      images = images,
      selected = selected)
  )
  session$sendInputMessage(inputId, message)
}


# copied from shiny since it's not exported
dropNulls <- function(x) {
  x[!vapply(x, is.null, FUN.VALUE=logical(1))]
}
