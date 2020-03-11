
library(shiny)
library(shinyinvoer)
library(purrr)

selectImageInput <- function(inputId, label, choices, images, ...) {

  addResourcePath(
    prefix='buttonImage',
    directoryPath=system.file("lib/buttonImage",
                              package='shinyinvoer')
  )

  div(class = "btn-group",
      tags$button(type = "button", class = "btn btn-default dropdown-toggle",
                  `data-toggle`="dropdown", `aria-haspopup`="true",  `aria-expanded`="false",
                  img(src="https://via.placeholder.com/150x50/808080"),
                  "X",
                  span(class="glyphicon glyphicon-chevron-down")
      ),
      tags$ul( class="dropdown-menu",
               tags$li(
                 tags$a(href="#", title = "Select",
                        img(src="https://via.placeholder.com/150x50/A000FF")
                 )
               ),
               tags$li(
                 tags$a(href="#", title = "Select",
                        img(src="https://via.placeholder.com/150x50/0080A0")
                 )
               )
      )
  )
}


images <- c(
  'https://d9np3dj86nsu2.cloudfront.net/image/eaf97ff8dcbc7514d1c1cf055f2582ad',
  'https://www.color-hex.com/palettes/33187.png',
  'https://www.color-hex.com/palettes/16042.png'
)
choices <- c('a', 'b', 'c')

ui <- fluidPage(
  #suppressDependencies('bootstrap'),
  selectImageInput("dropdown", "Pick:", choices = choices,
                          images = images, options = list(render = 'a'),
                          width = "100px"),
  verbatimTextOutput('test')
)

server <- function(input, output, session) {

  output$test <- renderPrint({
    input$dropdown
  })

}

shinyApp(ui, server)
