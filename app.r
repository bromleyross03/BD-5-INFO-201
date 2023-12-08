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
  
  country_list <- c("Albania", "Algeria", "Argentina", "Armenia", "Australia", "Austria", "Bahrain",
                    "Bangladesh", "Belgium", "Benin", "Bolivia", "Bosnia and Herzegovina", "Brazil",
                    "Bulgaria", "Burkina Faso", "Cambodia", "Cameroon", "Canada", "Chile", "China",
                    "Colombia", "Costa Rica", "Croatia", "Cyprus", "Denmark", "Dominican Republic",
                    "Ecuador", "Egypt", "El Salvador", "Estonia", "Ethiopia", "Finland", "France",
                    "Gabon", "Georgia", "Germany", "Ghana", "Greece", "Guinea", "Mali", "Peru",
                    "Philippines", "Hungary", "Iceland", "India", "Indonesia", "Ireland", "Israel",
                    "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Latvia", "Lebanon",
                    "Lithuania", "Malawi", "Malaysia", "Mauritius", "Mexico", "Moldova", "Mongolia",
                    "Morocco", "Mozambique", "Myanmar", "Namibia", "Nepal", "Netherlands", "New Zealand",
                    "Nicaragua", "Nigeria", "Norway", "Pakistan", "Panama", "Paraguay", "Tajikistan",
                    "Romania", "Russia", "Saudi Arabia", "Senegal", "Serbia", "Sierra Leone", "Singapore",
                    "Slovenia", "South Africa", "Spain", "Sri Lanka", "Sweden", "Switzerland", "Taiwan Province of China",
                    "Thailand", "Togo", "Tunisia", "Turkey", "Uganda", "Ukraine", "United Arab Emirates",
                    "United Kingdom", "United States", "Uruguay", "Uzbekistan", "Venezuela", "Vietnam",
                    "Zambia", "Zimbabwe")
  
  # Render map with happiness data
  output$choroplethMap <- renderPlot({
    # Load the world map data
    world_map <- map_data("world")
    
    # Filter out the regions based on the country_list
    world_map_filtered <- subset(world_map, region %in% country_list)
    
    # Assuming df_sorted has 'Country' and 'Explained.by..GDP.per.capita'
    # Merge world_map with df_sorted data
    merged_data <- merge(world_map_filtered, df_sorted, by.x = "region", by.y = "Country", all.x = TRUE)
    
    # Base world map plot with happiness data
    ggplot(data = merged_data, aes(x = long, y = lat, group = group, fill = Explained.by..GDP.per.capita)) +
      geom_polygon(color = "black") +
      scale_fill_gradient(low = "lightblue", high = "darkblue") +
      theme_minimal() +
      coord_fixed(1.3) +
      theme(legend.position = "bottom")
  })
  
  output$scatterPlot <- renderPlot({
    # Your scatter plot code here
  })
  
  output$barGraph <- renderPlot({
    # Your bar graph code here
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
