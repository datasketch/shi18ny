

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
selectLangInput <- function(inputId, label, choices,
                            selected = 1,
                            placeholder = NULL,
                            width = 120, img_width = 20) {

  addResourcePath(
    prefix='selectLang',
    directoryPath=system.file("lib/selectLang",
                              package='shi18ny')
  )

  images <- list.files(system.file("flags", package = "shi18ny"), full.names = TRUE)
  imagesNames <- basename(file_path_sans_ext(images))
  names(images) <- imagesNames
  choices_list <- lapply(seq_along(choices), function(x){
    choice <- choices[x]
    list(id = choices[x],
         image = paste0("data:image/svg+xml;utf8,",paste0(readLines(images[[choice]]),collapse="")),
         label = names(choices[x])
    )
  })
  names(choices_list) <- choices

  if(is.numeric(selected))
    selected <- choices[selected]
  if(is.null(placeholder) && !is.null(choices)){
    x <- choices_list[[selected]]
    placeholder <- div(class = "selectLang", img(src=x$image, width = img_width), x$label)
  }

  l <- lapply(choices_list, function(x){
    tags$li(class = "selectLang",
            tags$a(href="#", title = "Select", class = "selectLang", id = x$id,
                   img(src=x$image, width = img_width), x$label
            )
    )
  })

  shiny::div(
    label,
    shiny::div(
      `data-shiny-input-type` = "selectLang",
      shiny::tagList(
        shiny::singleton(
          shiny::tags$head(
            shiny::tags$link(rel = 'stylesheet',
                             type = 'text/css',
                             href = 'selectLang/selectLang.css'),
            shiny::tags$script(src = 'selectLang/selectLang-bindings.js')
          ))
      ),
      div(class = "btn-group", id = inputId, `data-init-value` = selected,
          tags$button(type = "button", class = "btn btn-default dropdown-toggle selectLang",
                      style = "display: flex;align-items: center;",
                      `data-toggle`="dropdown", `aria-haspopup`="true",  `aria-expanded`="false",
                      div(class = "buttonInner selectLang",
                          placeholder
                      ),
                      span(class="glyphicon glyphicon-chevron-down", style = "padding-left: 10px;")
          ),
          tags$ul( class="dropdown-menu",
                   l
          )
      )
    )
  )
}


updateSelectLangInput <- function (session, inputId, label = NULL, choices = NULL, selected = NULL) {
  # # Only updates selected for now
  # choices <- if (!is.null(choices))
  #   choicesWithNames(choices)
  # if (!is.null(selected))
  #   selected <- as.character(selected)
  # options <- if (!is.null(choices))
  #   selectOptions(choices, selected)
  message <- dropNulls(
    list(
      label = label,
      choices = choices,
      selected = selected)
  )
  session$sendInputMessage(inputId, message)
}


# copied from shiny since it's not exported
dropNulls <- function(x) {
  x[!vapply(x, is.null, FUN.VALUE=logical(1))]
}

