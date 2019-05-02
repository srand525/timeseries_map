source("~/gen_data.R")

library(shiny)
library(xts)
library(leaflet)
library(dplyr)
library(rgdal)


ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  fluidRow(align= "center",titlePanel(HTML("Tick Counts by NYC Zip"))),
  # titlePanel(HTML("<h4><center> Tick Counts by NYC Zip</center></h1>")),
  leafletOutput("mymap", width = "100%", height = "100%"),
  # fluidRow(align = "center",
                absolutePanel(top = 12, left = 10,
                sliderInput("time", "date",min(date), 
              max(date),
              value = max(date),
              step=1,
              animate=animationOptions(interval = 3000)))
)

server <- function(input, output, session) {
  
  
  tick_map<- reactive({
    sp::merge(nyc_zip_file,df[df$date == input$time,],by="ZIPCODE",duplicateGeoms = TRUE) 
  })
  
  
  output$mymap <- renderLeaflet({
    pal <- colorBin(palette = "Blues", domain = tick_map()@data$has_lyme,bins=4)
    
    leaflet() %>%
      addProviderTiles(providers$Esri.WorldGrayCanvas) %>% 
    setView(lng=-73.958925,lat=40.695857,zoom=11) %>% 
      htmlwidgets::onRender("function(el, x) {
        L.control.zoom({ position: 'topright' }).addTo(this)
    }") %>% 
    addPolygons(data = tick_map(),stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,color = ~pal(has_lyme)) 
  
    })
  
}

shinyApp(ui, server)
