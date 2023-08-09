library(shiny)
library(ggplot2)
load()
# Define UI
ui <- fluidPage(

    # App title
    titlePanel("Test UI"),

    # Sidebar layout
    sidebarLayout(

        # Sidebar panels for inputs
        sidebarPanel(

            #Input slider
            sliderInput(inputId = "things",
                        label = "Number of things",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

    # Main panel for displaying output
    mainPanel(

        # Output: Histogram
        plotOutput(outputId = "distPlot")
        )
    )
)

server <- function(input, output) {
    output$distPlot <- renderPlot({

        x_vals <- faithful$waiting
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        geom_histogram(mapping = aes(x=x_vals))
    })
}

shinyApp(ui, server)