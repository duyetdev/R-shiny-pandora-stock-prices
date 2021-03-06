
if (!require(quantmod)) {
  stop("This app requires the quantmod package. To install it, run 'install.packages(\"quantmod\")'.\n")
}

# Download data for a stock if needed, and return the data
require_symbol <- function(symbol, envir = parent.frame()) {
  if (is.null(envir[[symbol]])) {
    envir[[symbol]] <- getSymbols(symbol, auto.assign = FALSE)
  }
  
  envir[[symbol]]
}

shinyServer(function(input, output) {
  
  # Create an environment for storing data
  symbol_env <- new.env()
  
  pandora_stocks <- read.csv('./data/pandora_stock.csv')
  pandora_news <- read.csv('./data/pandora_news.csv')
  
  pandora_stocks$symbol <- NULL
  
  # Make a chart for a symbol, with the settings from the inputs
  make_pandora_chart <- function() {
    pandora_stock_data <- require_symbol('P', symbol_env)
    
    chartSeries(pandora_stock_data,
                name      = 'Pandora',
                type      = input$chart_type,
                subset    = paste(input$daterange, collapse = "::"),
                log.scale = input$log_y,
                theme     = "white")
  }
  
  output$plot_pandora <- renderPlot({
    make_pandora_chart()
  })

})