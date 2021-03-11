shinyServer(function(input, output, session) {
  
  authorsReact <- reactive({ 
    authorRang = dplyr::filter(authors, authors$date >= input$Dates[1] & authors$date <= input$Dates[2])
    dplyr::distinct(authorRang, author_name, .keep_all = TRUE)
  })
  
  
  output$bar <- renderPlot({
    color <- c("blue", "red", 'green')
    ggplot(data = authorsReact(), 
           aes(y=gender)) +
      geom_bar(fill = color) +
      #coord_flip() +
      xlim(0,40) +
      geom_label(stat='count', aes(label=..count..))
    
  })
  
  output$mytable = DT::renderDataTable({
    authorsReact()
  })

  
  place_data <- reactive({ 
    counts = authorsReact() %>% count(country.1)
    data = left_join(counts, world_spdf@data, by =  c("country.1" = 'NAME'))
    merge(world_spdf, data, by.x = "NAME", by.y = "country.1")
    
    
  })
    
  #country
  output$mymap <- renderLeaflet({
    leaflet(place_data()) %>%
      addProviderTiles(provider = input$provider, options = providerTileOptions(noWrap = FALSE)) %>%
      addPolygons() %>%
      # addPolygons(weight=1, opacity = 1.0,color = 'white',
      #             fillOpacity = 0.9, smoothFactor = 0.5,
      #             fillColor = ~colorBin('RdBu',n)(n),
      #             label = ~n) %>%
      # addLegend(
      #   "topright",
      #   pal = colorBin('RdBu', place_data@data$n),
      #   values = place_data@data$n, 
      #   opacity = 0.9
      # ) %>%
      addEasyButton(easyButton(icon="fa-globe", title="Zoom to high level", onClick=JS("function(btn, map){ map.setZoom(1.5); }")))
  })
  
})
