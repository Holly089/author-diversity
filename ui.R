
shinyUI(
  fluidPage(
    useShinyjs(),
    titlePanel("Author Diversity"),
    
    tabsetPanel(
      tabPanel("Gender",
               h3("Gender Of Authors"),
               
               plotOutput(outputId = "bar"),
               
               
               sliderInput(inputId = "DatesG", 
                           label = "Dates:",
                           min = startdate,
                           max = enddate ,
                           value = c(startdate, enddate), timeFormat="%d-%m-%Y", 
                           step = 1,
                           animate = animationOptions(interval = 1800)),
               
               prettyCheckbox(inputId = "missingDatesG",
                              label = "Include Missing Dates?",
                              value = FALSE,
                              outline = TRUE,
                              fill = TRUE,
                              bigger = TRUE,
                              status = 'success',width = NULL),
        
               

      ),
      
     
      tabPanel("Location",
               h3("Country Of Authors"),
               leafletOutput("mymap"),
               p(),
               #selectInput("provider","Provider", choices=providers, selected="OpenStreetMap")
               
               sliderInput(inputId = "DatesL", 
                           label = "Dates:",
                           min = startdate,
                           max = enddate ,
                           value = c(startdate, enddate), timeFormat="%d-%m-%Y", 
                           step = 1,
                           animate = animationOptions(interval = 1800)),
               
               prettyCheckbox(inputId = "missingDatesL",
                              label = "Include Missing Dates?",
                              value = FALSE,
                              outline = TRUE,
                              fill = TRUE,
                              bigger = TRUE,
                              status = 'success',width = NULL),
    
      ),
      
      tabPanel("Data Sets",
               h3("The Data Being Used"),
               DT::dataTableOutput("mytable"),
               DT::dataTableOutput("placetable")
      ),
      tabPanel("Missing Info",
               h3("Authors With Missing Diversity Info"),
               DT::dataTableOutput("missingInfo")
      )
  
  
  
)))
