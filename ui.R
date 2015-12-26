library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Sparkling wine offer"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      uiOutput("slider")
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      h2("Sparkling wine prices"),
      p("This page contains an overview of sparkling wine prices in one big online retailer in Moscow"),
      p("My application allows to see, how many bottles is available for certain price range, in which color and the contries if origin."),
      p("Use the input slider to select price range"),
      br(),
      span("Data was grabbed using"),
      a(href = "https://www.kimonolabs.com/", style="color:blue", "Kimonolabs Firefox plugin"),
      span(", then parsed and finally gathered in a dataset, containing wine name, price, color, taste and year, where applicable."),
      span("On the below plot I show distribution of different sparkling wine varieties in a chosen price range."),
      br(),
      span(textOutput("console"), style = "color:black; font-weight:bold"),
      plotOutput("distPlot", height="800px")
      
     # textOutput("fast"),
     # textOutput("slow")
      
    )
  )
))
