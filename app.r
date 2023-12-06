# Load necessary libraries
library(shiny)
library(ggplot2)
library(maps)
library(dplyr)

source("C:/Users/mabse/Downloads/BD-5 Data Cleaning Project.R")

# Define UI
ui <- fluidPage(
  titlePanel("Global Happiness and GDP Analysis"),
  
  # Layout for the choropleth map
  fluidRow(
    column(12, plotOutput("choroplethMap"))
  ),
  
  # Layout for the scatter plot
  fluidRow(
    column(12, plotOutput("scatterPlot"))
  ),
  
  # Layout for the bar graph
  fluidRow(
    column(12, plotOutput("barGraph"))
  )
)

# Define server logic
server <- function(input, output) {

  # Render choropleth map
  output$choroplethMap <- renderPlot({
    world_map <- map_data("world")
    merged_data <- merge(world_map, df_sorted, by.x = "region", by.y = "Country", all.x = TRUE)
    
    ggplot(merged_data, aes(x = long, y = lat, group = group, fill = Explained.by..GDP.per.capita)) +
      geom_polygon(color = "black") +
      scale_fill_gradient(low = "lightblue", high = "darkblue") +
      theme_minimal() +
      coord_fixed(1.3) +
      theme(legend.position = "bottom")
  })
  
  # Render scatter plot
  output$scatterPlot <- renderPlot({
    ggplot(df_sorted, aes(x = log(Explained.by..GDP.per.capita), y = Happiness.score)) +
      geom_point(aes(color = Country)) +
      theme_minimal() +
      xlab("Log of GDP per Capita") +
      ylab("Happiness Score")
  })
  
  # Render bar graph
  output$barGraph <- renderPlot({
    selected_countries <- c("Country1", "Country2", "Country3") # Replace with actual country names
    selected_indices <- which(df_sorted$Country == selected_countries[1] |
                                df_sorted$Country == selected_countries[2] |
                                df_sorted$Country == selected_countries[3])
    selected_data <- df_sorted[selected_indices, ]
    
    ggplot(selected_data, aes(x = Country, y = Happiness.score, fill = Country)) +
      geom_bar(stat = "identity", position = "dodge") +
      scale_y_continuous(labels = scales::comma) +
      theme_minimal()
  })
}

# Run the application
shinyApp(ui = ui, server = server)
