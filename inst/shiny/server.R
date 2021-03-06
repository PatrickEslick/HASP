library(shiny)
library(HASP)
options(shiny.maxRequestSize = 200 * 1024^2)
library(dplyr)
library(tidyr)
library(leaflet)

source("modules.R",local=TRUE)

shinyServer(function(input, output, session) {

  
  observe({
    if (input$close > 0) shiny::stopApp()    
  })

  source("get_data.R",local=TRUE)$value
  source("comp_plot.R",local=TRUE)$value
  source("norm_plot.R",local=TRUE)$value
  
  output$mymap <- leaflet::renderLeaflet({

    map <- leaflet::leaflet() %>%
      leaflet::addProviderTiles("CartoDB.Positron")     


  })
  
  observe({
    validate(
      need(!is.null(rawData_data$data), "Please select a data set")
    )
    
    aquifer_data <- rawData()
    
    shinyAce::updateAceEditor(session, editorId = "map_code", value = map_code() )
    
    x <- filter_sites(aquifer_data, "lev_va", 30)
    map_data <- prep_map_data(x, "lev_va")

    map <- leafletProxy("mymap", data = map_data) %>%
      clearMarkers() %>%
      addCircleMarkers(lat=~dec_lat_va, lng=~dec_long_va,
                       radius = 3,
                       fillOpacity = 1,
                       popup= ~popup,
                       stroke=FALSE) %>% 
      fitBounds(~min(dec_long_va), ~min(dec_lat_va),
                ~max(dec_long_va), ~max(dec_lat_va))
    
    map
    
   
    
  })

  callModule(graph_download_code, 'composite_graph', 
             plot_gg = comp_plot, 
             code_out = comp_plot_out, 
             raw_data = reactive({rawData_data$data}))
  
  callModule(graph_download_code, 'normalized_graph', 
             plot_gg = norm_plot, 
             code_out = norm_plot_out, 
             raw_data = reactive({rawData_data$data}))
 
  setup <- reactive({
    end_date <- Sys.Date()
    parts <- strsplit(as.character(end_date), split = "-")[[1]]
    parts[[1]] <- as.character(as.numeric(parts[[1]]) - 30)
    start_date <- paste(parts, collapse = "-")
    long_name <- input$aquiferCd
    aquiferCd <- summary_aquifers$nat_aqfr_cd[summary_aquifers$long_name == long_name]
    
    if(rawData_data$example_data){
      setup_code <- paste0('library(HASP)
aquifer_data <- aquifer_data')
    } else {
      setup_code <- paste0('library(HASP)
long_name <- "', input$aquiferCd ,'"
aquiferCd <- summary_aquifers$nat_aqfr_cd[summary_aquifers$long_name == long_name]
aquifer_data <- get_aquifer_data(aquiferCd = "',aquiferCd,'",
                           startDate = "', start_date,'",
                           endDate = "', end_date, '")
aquifer_data <- filter_sites(aquifer_data, sum_col = "lev_va",  num_years = 30)')      
    }
    
    setup_code
  })
  
  map_code <- reactive({
    paste0(setup(),'
map_data <- map_hydro_data(aquifer_data, 
                           sum_col = "lev_va", num_years = 30)
map_data')
           
  })
  


  session$onSessionEnded(stopApp)
  
})
