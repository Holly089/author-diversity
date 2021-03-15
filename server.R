shinyServer(function(input, output, session) {
  
  
  authorsReact <- reactive({
    if (input$missingDatesG == TRUE){authors$date[is.na(authors$date)] <- input$DatesG[1]}
    authorRang = dplyr::filter(authors, authors$date >= input$DatesG[1] & authors$date <= input$DatesG[2])
    dplyr::distinct(authorRang, author_name, .keep_all = TRUE)
  })
  
  #gender_count <- length(unique(authorsReact()$gender))
  gender_count <- reactive({ 
    authorRang = dplyr::filter(authors, authors$date >= input$DatesG[1] & authors$date <= input$DatesG[2])
    #length(unique(authorRang$gender))
    dplyr::distinct(authorRang, gender, .keep_all = TRUE)
  
  })
  
 # print(length(gender_count()))
  
  output$bar <- renderPlot({
    #color <- c("blue", "red", 'green')
    ggplot(data = authorsReact(), 
           aes(y=gender)) +
      geom_bar(fill = 'green') +
      xlim(0,50) +
      geom_label(stat='count', aes(label=..count..))
    
  })
  
  output$mytable = DT::renderDataTable({
    authorsReact()
  })

  

  output$mymap <- renderLeaflet({
    
    # Add data to map
    #  to get the counts
    if (input$missingDatesL == TRUE){authors$date[is.na(authors$date)] <- input$DatesL[1]}
    datafiltered <- filter(authors, authors$date >= input$DatesL[1] & authors$date <= input$DatesL[2])
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
        weight = 3,
        label = labels
      ) %>%
      
      # # legend
      leaflet::addLegend(
        pal = pal, values = ~n,
        opacity = 0.7, title = NULL
      )
  })
  
  
  place_data <- reactive({
    counts = authorsReact() %>% count(country.1)
    data = left_join(world_spdf@data, counts,  by =  c('NAME' = "country.1"))
    data$n[is.na(data$n)] <- 0
    merge(world_spdf, data, by.x = "NAME", by.y = "NAME", all.x = TRUE)
  })

  
  output$placetable = DT::renderDataTable({
    as.data.frame(place_data())
  })
  
  
  output$missingInfo = DT::renderDataTable({
    dplyr::filter(authors,  is.na(authors$gender) | is.na(authors$country.1))
  })
  
})
