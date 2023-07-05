library(shiny)

# Define UI
ui <- fluidPage(

    # App title
    titlePanel("Test UI")

    # Sidebar layout
    sidebarLayout(

        # Sidebar panels for inputs
        sidebarPanel(

            #Input slider
            sliderInput(inputId = "things",
                        label = "Number of things",
                        min = 1,
                        maax = 50,
                        value = 30)
        ),
    )
)
