#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for the peakFinder application
shinyUI(fluidPage(
        # Application title
        titlePanel("peak finder"),
        
        # Sidebar
        sidebarLayout(
                sidebarPanel(
                        h3("E Danesh"),
                        tags$i("08 Sep 2018"),
                        br(),
                        sliderInput(
                                "w",
                                "w parameter:",
                                min = 1,
                                max = 50,
                                value = 50
                        ),
                        sliderInput("span", "span parameter:", 0.005, 1, 0.05),
                        checkboxInput("hide", "hide smooth line?", value = FALSE)
                        
                ),
                
                # Show the plot
                mainPanel(tabsetPanel(
                        type = "tabs",
                        tabPanel(
                                "Instructions",
                                br(),
                                
                                h3(tags$b("how to use peak finder:")),
                                h4("peak finder is a simple and fast Shiny application for deetcting peaks (local maxima) of a noisy data set."),
                                h4("to use this app, you need to adjust 2 parameters:"),
                                h4(tags$i("w")),
                                h5("w is the half-width of the window used to compute the local maximum. Its value should be substantially less than half the length of the array of data. Small values will pick up tiny local bumps whereas larger values will pass right over those."),
                                h4(tags$i("span")),
                                h5("span is an argument of the loess smoother. It is typically between zero and one; it reflects a window width as a proportion of the range of x values. Larger values will smooth the data more aggressively, making local bumps disappear altogether."),
                                h5("Note: you can show/hide the smooth line fitted to the data using the check box provided"),
                                h4("now, go to the Results tab and try it yourself!"),
                                br(),
                                h5("data used for this demo:"),
                                code("x <- 1:1000 / 100 - 5"),
                                br(),
                                code("y <- exp(abs(x) / 20) * sin(2 * x + (x / 5) ^ 2) + cos(10 * x) / 5 + 
                                     rnorm(length(x), sd = 0.05)")
                        ),
                        tabPanel(
                                "Results",
                                plotOutput("plot", brush = brushOpts(id = "brush1")),
                                h4(textOutput("npeaks"))
                        ),
                        tabPanel(
                                "References",
                                br(),
                                h5("[1] Algorithm and code originally from William A. Huber"),
                                a("https://stats.stackexchange.com/questions/36309/how-do-i-find-peaks-in-a-dataset"),
                                h5("[2] Nicely illustrated in rpubs by Meng Xu"),
                                a("https://rpubs.com/mengxu/peak_detection")
                        )
                ))
        )
))