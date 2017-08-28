if (!require('pacman')) install.packages('pacman')
p_load(data.table,dplyr,readr,readxl,openxlsx,stringr,jsonlite,haven,shiny)

# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 20MB.
options(shiny.maxRequestSize = 20*1024^2)

function(input, output, session) {
  
  input_data <- reactive({
    uploadedfile <- input$file
    
    if(is.null(uploadedfile)) {
      return(NULL)
    } else {
      if(input$filein == 'csv') {
        input_data <- as_tibble(fread(uploadedfile$datapath, header = input$header, sep = input$sep_csv, quote = input$quote_csv))
      }
      if(input$filein == 'tsv') {
        input_data <- as_tibble(fread(uploadedfile$datapath, header = input$header, sep = input$sep_tsv, quote = input$quote_tsv))
      }
      if(input$filein == 'xlsx') {
        # if(input$sheet_xlsx == '' & input$range_xlsx == '') { input_data <- read_xlsx(uploadedfile$datapath, col_names = input$header, sheet = NULL, range = NULL) }
        # if(input$sheet_xlsx != '' & input$range_xlsx == '') { input_data <- read_xlsx(uploadedfile$datapath, col_names = input$header, sheet = input$sheet_xlsx, range = NULL) }
        # if(input$sheet_xlsx == '' & input$range_xlsx != '') { input_data <- read_xlsx(uploadedfile$datapath, col_names = input$header, sheet = NULL, range = input$range_xlsx) }
        # if(input$sheet_xlsx != '' & input$range_xlsx != '') { input_data <- read_xlsx(uploadedfile$datapath, col_names = input$header, sheet = input$sheet_xlsx, range = input$range_xlsx) }
        input_data <- read_xlsx(uploadedfile$datapath, col_names = input$header, sheet = NULL, range = NULL)
      }
      if(input$filein == 'json') {
        input_data <- as_tibble(fromJSON(uploadedfile$datapath))
      }
      if(input$filein == 'sav') {
        input_data <- as_tibble(read_sav(uploadedfile$datapath))
      }
      if(input$filein == 'dta') {
        input_data <- as_tibble(read_dta(uploadedfile$datapath))
      }
      if(input$fixheader == T) {
        input_data <- input_data %>% 
          rename_all(
            funs(
              iconv(., from = '', to = 'ASCII', sub = '') %>% 
                gsub('[^A-Za-z0-9]', '', .) %>% 
                stringr::str_to_lower(.)
            )
          )
      }
    }
    
    return(input_data)
  })
  
  #output$templocation <- reactive({as.character(input$file$datapath)})
  #output$text_input <- reactive(c(input$sheet_xlsx,input$range_xlsx))
  
  output$preview <- renderTable({
    output_preview <- reactive({ input_data() })
    output_preview <- tryCatch(head(output_preview()[,1:5]), 
                               warning = function(w) { 'Output obtained with warnings. Check your file extension and the selected options.' }, 
                               error   = function(e) { tibble(`Error message` = 'Its not possible to obtain the output. Check your file extension and the selected options. Probably your file is a csv and was renamed to xlsx or so.') })
    return(output_preview)}
    , striped = F, bordered = T, hover = T, digits = 3
  )
  outputOptions(output, 'preview', suspendWhenHidden = FALSE)
  
  output$download_data <- downloadHandler(
    filename = function() { 
      paste0("exported_file_", gsub('[^A-Za-z0-9]', '_', Sys.time()), '.', input$fileout)
    },
    content = function(filename) {
      if(input$fileout == 'csv' & input$csv_spanishseparator == F) { fwrite(input_data(), filename, sep = ",") } 
      if(input$fileout == 'csv' & input$csv_spanishseparator == T) { fwrite(input_data(), filename, sep = ";") } 
      if(input$fileout == 'tsv' & input$tsv_spaceseparator == F) { fwrite(input_data(), filename, sep = "\t") } 
      if(input$fileout == 'tsv' & input$tsv_spaceseparator == T) { fwrite(input_data(), filename, sep = " ") } 
      if(input$fileout == 'xlsx') { write.xlsx(input_data(), filename) } 
      if(input$fileout == 'json' & input$minify == T) { write_json(input_data(), filename, pretty = T) } 
      if(input$fileout == 'json' & input$minify == F) { write_json(input_data(), filename, pretty = F) } 
      if(input$fileout == 'sav') { write_sav(input_data(), filename) } 
      if(input$fileout == 'dta') { write_dta(input_data(), filename) } 
    }
  )
  
}
