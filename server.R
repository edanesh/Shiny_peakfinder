#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Create sample data
x <- 1:1000 / 100 - 5
y <-
        exp(abs(x) / 20) * sin(2 * x + (x / 5) ^ 2) + cos(10 * x) / 5 + rnorm(length(x), sd = 0.05)
data <- data.frame(x = x, y = y)

# peakR function
peakR <- function(x, y, w = 1, ...) {
        require(zoo)
        n <- length(y)
        y.smooth <- loess(y ~ x, ...)$fitted
        y.max <-
                rollapply(zoo(y.smooth), 2 * w + 1, max, align = "center")
        delta <- y.max - y.smooth[-c(1:w, n + 1 - 1:w)]
        i.max <- which(delta <= 0) + w
        list(x = x[i.max],
             i = i.max,
             y.hat = y.smooth)
}

# Define server logic required for the peakFinder application
shinyServer(function(input, output) {
        peaks <- reactive({
                peakR(data$x,
                       data$y,
                       w = input$w,
                       span = input$span)
        })
        
        output$plot <- renderPlot ({
                plot(
                        data$x,
                        data$y,
                        cex = 0.75,
                        col = "Gray",
                        main = paste("w = ", input$w, ", span = ", input$span, sep = "")
                )
                if (input$hide == FALSE) {
                        lines(data$x, peaks()$y.hat,  lwd = 2)
                }
                y.min <- min(y)
                sapply(peaks()$i, function(i)
                        lines(
                                c(data$x[i], data$x[i]),
                                c(y.min, peaks()$y.hat[i]),
                                col = "Red",
                                lty = 2
                        ))
                points(
                        data$x[peaks()$i],
                        peaks()$y.hat[peaks()$i],
                        col = "Red",
                        pch = 19,
                        cex = 1.25
                )
        })
        
        output$npeaks <- renderText({
                paste("No. of peaks found", length(peaks()$i))
        })
})
