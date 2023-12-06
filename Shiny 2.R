library(shiny)
source("C:/Users/mabse/Downloads/LECT11/DPLYR/lect11.R")

ui <- fluidPage(
  titlePanel("SNAP Data for 2016"),
  p("the avg poverty % for all ages was: "),
  p(round(mean(combo_df$Poverty.Estimate..All.Ages, na.rm = TRUE))),
  h1("Plots"),
  sidebarLayout(
    sidebarPanel(
      h3("controls"),
      sliderInput(
        inputId = "pov_per",
        label = "Filter by poverty percent per state",
        min = 0,
        max = 25,
        value = 25
      ),
      checkboxInput(
        inputId = "incl_ca",
        label = "Include California?",
        value = TRUE
      )
      
    ),
    mainPanel(
      plotOutput(outputId = "scatter"),
    )
  ),
  h3("histogram"),
  plotOutput(outputId = "hist"),
)

server <- function(input, output){
  output$scatter <- renderPlot({
    #plot(scatter)
    filt_df <- filter(combo_df, Poverty.Percent..All.Ages <= input$pov_per)
    
    if(input$incl_ca == FALSE){
      filt_df <- filter(filt_df, Name != "California")
    }
    
    scatter <- ggplot(data = filt_df, aes(x = Poverty.Percent..All.Ages, y = yr_cost )) + 
      geom_point(aes(col = Region.Name)) + 
      geom_text(aes(label = ifelse( yr_cost >= 200000000 | Name == "Washington", Name, ""), hjust = -0.1, vjust = -0.3 )) +
      ggtitle("Poverty % versus Yearly Food Cost") + 
      labs(y = "Yearly Cost in USD", x = " Percetn Poverty (as measured by the census)", color = "US Regions")
  })
  
  output$hist <- renderPlot({
    plot(hist)
  })
}

shinyApp(ui = ui, server = server)
