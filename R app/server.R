shinyServer(function(input, output, session) {
  
  Selected<-reactiveValues(dates=NULL)
  
  
  observeEvent(input$DatesL, Selected$dates<-(input$DatesL))
  observeEvent(input$DatesG, Selected$dates<-(input$DatesG))
  
  #observeEvent(Selected$dates, updateSelectInput(session, "DatesL", selected=Selected$dates), multiple = TRUE)
  #observeEvent(Selected$dates, updateSelectInput(session, "DatesG", selected=Selected$dates), multiple = TRUE)
  
  
  authorsReact <- reactive({ 
    authorRang = dplyr::filter(authors, authors$date >= Selected$dates[1] & authors$date <= Selected$dates[2])
    dplyr::distinct(authorRang, author_name, .keep_all = TRUE)
  })
  
  #gender_count <- length(unique(authorsReact()$gender))
  gender_count <- reactive({ 
    authorRang = dplyr::filter(authors, authors$date >= Selected$dates[1] & authors$date <= Selected$dates[2])
    #length(unique(authorRang$gender))
    dplyr::distinct(authorRang, gender, .keep_all = TRUE)
  
  })
  
 # print(length(gender_count()))
  
  output$bar <- renderPlot({
    #color <- c("blue", "red", 'green')
    ggplot(data = authorsReact(), 
           aes(y=gender)) +
      geom_bar(fill = 'green') +
      xlim(0,40) +
      geom_label(stat='count', aes(label=..count..))
    
  })
  
  output$mytable = DT::renderDataTable({
    authorsReact()
  })

 # country_counts <- reactive({counts = authorsReact() %>% count(country.1) 
  #})
  
  # place_data <- reactive({ 
  #   counts = authorsReact() %>% count(country.1)
  #   data = left_join(world_spdf@data, counts,  by =  c('NAME' = "country.1"))
  #   data$n[is.na(data$n)] <- 0
  #   merge(world_spdf, data, by.x = "NAME", by.y = "NAME", all.x = TRUE)
  #   
  #   
  # })
  

  output$mymap <- renderLeaflet({
    
    # Add data to map
    # fikter to get the counts
    datafiltered <- filter(authors, authors$date >= Selected$dates[1] & authors$date <= Selected$dates[2])
    datafiltered <- datafiltered %>% count(country.1)
    
    #add the zeros back on
    results1 = setdiff(world_spdf@data$NAME,datafiltered$country.1)
    results1 = data.frame(results1)
    results1$n = 0
    names(results1)[1] <- "country.1"
    
    #add back on to spacial data
    datafiltered = rbind(datafiltered, results1)
    ordercounties <- match(world_spdf@data$NAME, datafiltered$country.1)
    #ordercounties <- merge(world_spdf, datafiltered, by.x = "NAME", by.y = "country.1", all.x = TRUE)
    world_spdf@data <- datafiltered[ordercounties, ]
  
    
  
    pal <- colorBin("YlOrRd", domain = world_spdf$n, bins = c(0,1, 2, 4, 6, 8, 10, 12, Inf))
    
    # # labels
     labels <- sprintf("%s: %g", world_spdf$country.1, world_spdf$n) %>%
       lapply(htmltools::HTML)
     
   
     # Create leaflet
    l <- leaflet(world_spdf) %>%
      addTiles() %>%
      setView(lat = 10, lng = 8, zoom=1)%>%
      addPolygons(
        fillColor = ~ pal(n),
        fillOpacity  = 0.8,
        color = "black",
        label = labels
      ) %>%
      
      # # legend
      leaflet::addLegend(
        pal = pal, values = ~n,
        opacity = 0.7, title = NULL
      )
  })
  
  output$placetable = DT::renderDataTable({
    as.data.frame(place_data())
  })
  
  
  output$missingInfo = DT::renderDataTable({
    dplyr::filter(authors,  is.na(authors$gender) | is.na(authors$country.1))
  })
  
})
