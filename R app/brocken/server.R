shinyServer(function(input, output, session) {
  
  
  #######
  #authors plot
  #######
  

  
  authorsReact <- reactive({ 
    dplyr::filter(authors, authors$date >= input$Dates[1] & authors$date <= input$Dates[2])
  })
  
  output$Summary <- renderPrint({
    dfSummary(authorsReact)
  })
  
  output$bar <- renderPlot({
    color <- c("blue", "red", 'green')
    #authors %>% filter(date >= input$Dates[1] & date <= input$Dates[2])
    ggplot(data = authors, 
           aes(x=gender)) +
      geom_bar(fill = color) +
    coord_flip() +
    geom_label(stat='count', aes(label=..count..))
    
  })
  
  output$catagirical <- DT::renderDataTable({
    DT::datatable(data = cat_data)
  })
  output$Mosaic <- renderPlot({
    formula <- as.formula(paste("~",paste(input$VariablesA, collapse = " + ")))
    vcd::mosaic(formula, data = cat_data,
           main = "Mosaic of catagorical variables", shade = TRUE, legend = TRUE)
  })

  output$Plot <- renderPlot({
    plot(cat_data)
  })
  
  
  output$SummaryA1 <- renderPrint({
    summary(cat_data)
  })
  
  output$SummaryA2 <- renderPrint({
    summary(as.data.frame(cat_data))
  })
  
  #######
  #data set
  ######
  
  # output$Summary <- renderPrint({
  #   dfSummary(mtcars)
  # })
  
  # output$Data_set = DT::renderDataTable({authors
  # })
  # output$Data_set = DT::renderDataTable({
  #   authors
  # })
 
  output$mytable = DT::renderDataTable({
    mtcars
  })
  output$Summary <- renderPrint({
    summary(as.data.frame(authors))
  })
  output$table <- DT::renderDataTable(DT::datatable({
    data <- authors 
  }))
  
})

#runApp(appDir = ".", display.mode = "showcase")
