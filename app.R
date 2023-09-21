# Install and load necessary packages
if (!requireNamespace("shiny", quietly = TRUE)) install.packages("shiny")
if (!requireNamespace("readr", quietly = TRUE)) install.packages("readr")
if (!requireNamespace("readxl", quietly = TRUE)) install.packages("readxl")
if (!requireNamespace("writexl", quietly = TRUE)) install.packages("writexl")

library(shiny)
library(readr)
library(readxl)
library(writexl)

ui <- fluidPage(
    titlePanel("Gene Subset Extraction"),
    
    sidebarLayout(
        sidebarPanel(
            fileInput("tabFile", "Choose Tab-separated File",
                      accept = c(".txt", ".tsv")),
            fileInput("excelFile", "Choose Excel File",
                      accept = c(".xlsx")),
            downloadButton("downloadData", "Get sliced file")
        ),
        mainPanel(
            tableOutput("geneDataHead"),
            tableOutput("geneListsHead")
        )
    )
)

server <- function(input, output) {
    
    # Read the tab-separated file
    get_gene_data <- reactive({
        inFile <- input$tabFile
        if (is.null(inFile))
            return(NULL)
        read_delim(inFile$datapath, delim = "\t")
    })
    
    # Read the excel file
    get_gene_lists <- reactive({
        inFile <- input$excelFile
        if (is.null(inFile))
            return(NULL)
        read_excel(inFile$datapath)
    })
    
    output$geneDataHead <- renderTable({
        if (!is.null(get_gene_data())) head(get_gene_data())
    })
    
    output$geneListsHead <- renderTable({
        if (!is.null(get_gene_lists())) head(get_gene_lists())
    })
    
    # Extract subsets and download Excel
    output$downloadData <- downloadHandler(
        filename = function() {
            paste("subset_data_", Sys.Date(), ".xlsx", sep="")
        },
        content = function(file) {
            head(df)
            gene_id_col<-colnames(df)[1]
            gene_lists<-get_gene_lists()
            
            subsets <- list()
            for (i in 1:ncol(gene_lists)) {
                list_name <- colnames(gene_lists)[i]
                gene_subset <- df[df[[gene_id_col]] %in% gene_lists[[i]], ]
                subsets[[list_name]] <- gene_subset
            }
            write_xlsx(subsets, file)
        }
    )
}

shinyApp(ui, server)
