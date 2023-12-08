library(shiny)
library(ggplot2)
library(plotly)
library(dplyr)

source("C:/Users/mabse/Downloads/BD-5 Data Cleaning Project (1).R") 

ui <- fluidPage(
  titlePanel("GDP and Happiness Analysis"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("barCount", "Number of countries to display in bar chart:",
                  min = 5, max = nrow(df_sorted), value = 10)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Scatter Plot", plotOutput("scatterPlot")),
        tabPanel("Bar Chart", plotOutput("barChart")),
        tabPanel("Interactive Map", plotlyOutput("interactiveMap"))
      )
    )
  )
)

# Server logic
server <- function(input, output) {
  # Scatter Plot
  output$scatterPlot <- renderPlot({
    ggplot(df_sorted, aes(x = gdp_fix, y = Happiness.score)) +
      geom_point(aes(color = Country)) +
      labs(title = "GDP vs Happiness Score", x = "GDP", y = "Happiness Score")
  })
  
  # Bar Chart
  output$barChart <- renderPlot({
    top_countries <- head(df_sorted[order(df_sorted$Happiness.score, decreasing = TRUE), ], input$barCount)
    ggplot(top_countries, aes(x = reorder(Country, Happiness.score), y = Happiness.score)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "Top Countries by Happiness Score", x = "Country", y = "Happiness Score")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)