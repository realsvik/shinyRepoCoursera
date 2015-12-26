library(shiny)
library(ggplot2)
library(dplyr)
source(file="multiplot.R")
options(scipen=999)
#Load data
wineDataDF<-read.csv("data/wineStyleData2312.csv", stringsAsFactors = FALSE, header = TRUE, sep=";", quote = "",)
#Calculate quantiles for price ranges
range<-quantile(wineDataDF$usdPrice, probs = seq(0, 1, by=0.1), na.rm = FALSE, names = FALSE)
minR<-min(range)
maxR<-max(range)
medianR<-median(range)
rangeD<-minR
rangeU<-maxR
#Sys.sleep(1)
#wineDataRange<-filter(wineDataDF, usdPrice>=rangeD, usdPrice<=rangeU)
# Define server logic required to draw plot
shinyServer(function(input, output, session) {
  values <- reactiveValues(starting = TRUE)
  session$onFlushed(function() {
    values$starting <- FALSE
  })
  
  output$slider <- renderUI({
    sliderInput("inSlider", "Price range, USD", min=minR, max=maxR, value=c(minR, maxR))
    #sliderInput("inSlider", "Price range, USD", min=2, max=573, value=c(2, 573))
  })
  
 
  output$distPlot <- renderPlot({
    
  
    rangeD<-input$inSlider[1]
    rangeU<-input$inSlider[2]
    
    
    
    wineDataRange<-filter(wineDataDF, usdPrice>=rangeD, usdPrice<=rangeU)
    #wineDataRange<-subset(wineDataDF, wineDataDF$usdPrice>=rangeD, wineDataDF$usdPrice<=rangeU, select=c("usdPrice", "colorFac", "country"))
    if (is.na(wineDataRange$usdPrice[1])){}
    else{
    wineDataCountry<-as.data.frame(x=wineDataRange$country, stringsAsFactors=FALSE)
    
    
    
    names(wineDataCountry)<-c("Country")
    wineDataCountry<-group_by(wineDataCountry, Country)
    wineDataCountry<-summarise(wineDataCountry, count=n())
    countryPlot<-ggplot(wineDataCountry, aes(x=Country, y=1, size=count, label=as.character(count)))
    countryPlot<-countryPlot+geom_point(colour="white", fill="blue", shape=21)+scale_size_area("Counts per country",max_size = 30)+geom_text(size=4, hjust=0.5, vjust=5)+theme_bw()+ theme(legend.position="none")+theme(axis.text.x = element_text(angle = 45, hjust = 1))+theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())+ ggtitle("Producing countries")
    
    hist_col <- ggplot(wineDataRange, aes(x=usdPrice, fill=colorFac))
    hist_col<-hist_col + geom_bar() +
      
      scale_fill_manual(values=c("not assigned"="#cccccc", "red"="#cc0000","rose" = "#ff1fb1", "white"="#edf93c"))+
      
      ggtitle("Sparkling wine prices") + 
      labs(x="Price USD", y="Count")+
      theme_bw()+
      scale_x_continuous(breaks = round(seq(min(wineDataRange$usdPrice), max(wineDataRange$usdPrice), by = 50),1)) +
      guides(fill=guide_legend(title='color'))
    
    multiplot(hist_col, countryPlot, rows=2)
    }
  
  })
  
  output$console <- renderText({
    rangeD<-input$inSlider[1]
    rangeU<-input$inSlider[2]
    wineDataRange<-filter(wineDataDF, usdPrice>=rangeD, usdPrice<=rangeU)
    countBott<-length(wineDataRange$usdPrice)
    paste("Available varieties:", countBott, "")
     
  })
  
})
#https://realsvik.shinyapps.io/app1
#https://realsvik.shinyapps.io/app1