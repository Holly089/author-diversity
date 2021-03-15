
shinyUI(
  fluidPage(
    useShinyjs(),
    titlePanel("author diversity"),
    
    tabsetPanel(
      tabPanel("Gender",
               h3("gender of authors"),
             
               plotOutput(outputId = "bar"),
              
              
              sliderInput(inputId = "Dates", 
                          label = "Dates:",
                          min = startdate,
                          max = enddate ,
                          value = c(startdate, enddate), timeFormat="%Y-%m-%d", 
                          step = 1,
                          animate = animationOptions(interval = 1800)),
              
              verbatimTextOutput(outputId = "Summary")
               ),
              
      tabPanel("Data Set",
               DT::dataTableOutput("table"),
                          verbatimTextOutput(outputId = "Summary"),
                          DT::dataTableOutput("mytable")
                          #DT::dataTableOutput("Data_set")
               #DT::dataTableOutput(outputId = "Data_set")
               
               )
      
            

)
)
)
