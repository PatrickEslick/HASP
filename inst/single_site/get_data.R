rawData_data <- reactiveValues(daily_data = NULL,
                               example_data = FALSE, 
                               daily_data = NULL,
                               gwl_data = NULL,
                               qw_data = NULL,
                               p_code = "62610",
                               stat_cd = "00001")

observeEvent(input$example_data,{
  rawData_data$example_data <- TRUE
  rawData_data$daily_data <- HASP::L2701_example_data$Daily
  rawData_data$gwl_data <- HASP::L2701_example_data$Discrete
  rawData_data$qw_data <- HASP::L2701_example_data$QW
  rawData_data$p_code <- "62610"
  rawData_data$stat_cd <- "00001"

  shinyAce::updateAceEditor(session, 
                            editorId = "get_data_code", 
                            value = setup() )
  
})

observeEvent(input$get_data,{
  rawData_data$example_data <- FALSE
  
  site_id <- input$siteID
  parameter_cd <- input$pcode
  stat_cd <- input$statcd
  
  shinyAce::updateAceEditor(session, 
                            editorId = "get_data_code", 
                            value = setup() )
  
  showNotification("Loading Daily", 
                   duration = NULL, id = "load")

  rawData_data$daily_data <- dataRetrieval::readNWISdv(site_id, 
                                                       parameter_cd, 
                                                       statCd = stat_cd)

  
  removeNotification(id = "load")
  
  showNotification("Loading Discrete", 
                   duration = NULL, id = "load2")
  
  rawData_data$gwl_data <- dataRetrieval::readNWISgwl(site_id)
  
  removeNotification(id = "load2")
  
  showNotification("Loading QW", 
                   duration = NULL, id = "load3")
  
  rawData_data$qw_data <- dataRetrieval::readNWISqw(site_id, 
                                                     c("00095","90095","00940","99220"))
  
  removeNotification(id = "load3")
  
  rawData_data$p_code <- input$pcode
  rawData_data$stat_cd <- input$statcd
})


dvData <- reactive({
  
  return(rawData_data$daily_data)
  
})

qwData <- reactive({
  
  return(rawData_data$qw_data)
  
})

gwlData <- reactive({
  
  return(rawData_data$gwl_data)
  
})