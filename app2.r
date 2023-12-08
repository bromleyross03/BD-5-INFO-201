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
    # Order data by Happiness Score
    ordered_data <- df_sorted[order(df_sorted$Happiness.score, decreasing = TRUE), ]
    ggplot(ordered_data, aes(x = gdp_fix, y = Happiness.score, color = Country)) +
      geom_point() +
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
  
  output$interactiveMap <- renderPlotly({
    # World map data
    world_map <- map_data("world")
    
    # Prepare the data for merging
    map_data <- world_map
    map_data$region <- as.character(map_data$region)
    
    # Merge the map data with your data frame
    for (i in 1:nrow(df_sorted)) {
      country_name <- df_sorted$Country[i]
      happiness_score <- df_sorted$Happiness.score[i]
      gdp_value <- df_sorted$gdp_fix[i]
      map_data$Happiness.score[map_data$region == country_name] <- happiness_score
      map_data$gdp_fix[map_data$region == country_name] <- gdp_value
    }
    
    # Create the plot
    p <- ggplot(map_data, aes(x = long, y = lat, group = group, fill = Happiness.score)) +
      geom_polygon() +
      scale_fill_viridis_c(option = "C") +
      labs(title = "Happiness Score by Country") +
      theme_void()  # Removes axes for a cleaner map
    
    ggplotly(p, tooltip = c("region", "Happiness.score", "gdp_fix"))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)