if (!require('pacman')) install.packages('pacman')
p_load(shiny,shinyjs,rio,data.table,jsonlite,jsonlite,dplyr,stringr,tools)

# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 20MB.
options(shiny.maxRequestSize = 20*1024^2)

function(input, output, session) {
  input_data <- reactive({
    uploadedfile <- input$file
    
    if(is.null(uploadedfile)) {
      return(NULL)
    } else {
      hide('show_preview')
      show('loading_page')
      Sys.sleep(2)
      input_data <- as_tibble(import(file = uploadedfile$datapath, format = file_ext(uploadedfile$name)))
      show('show_preview')
      hide('loading_page')
      
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
  
  # output$file_uploaded <- reactive({
  #   return(is.null(input_data()))
  # })
  # outputOptions(output, 'file_uploaded', suspendWhenHidden=FALSE)
  
  output$preview <- renderTable({
    output_preview <- reactive({ input_data() })
    N <- min(ncol(output_preview()),5)
    output_preview <- tryCatch(head(output_preview()[,1:N]), 
                               warning = function(w) { 'Output obtained with warnings. Check your file extension and the selected options.' }, 
                               error   = function(e) { tibble(`Error message` = 'Its not possible to obtain the output. Check your file extension and the selected options. Probably your file is a csv and was renamed to xlsx or so.') })
    return(output_preview)}
    , striped = F, bordered = T, hover = T, digits = 3
  )
  outputOptions(output, 'preview', suspendWhenHidden = FALSE)
  
  output$download_data <- downloadHandler(
    filename = function() {
      paste0(basename(file_path_sans_ext(input$file$name)), '.', input$fileout)
    },
    content = function(filename) {
      if(input$fileout == 'csv' & input$csv_spanishseparator == F) { fwrite(input_data(), filename, sep = ",") } 
      if(input$fileout == 'csv' & input$csv_spanishseparator == T) { fwrite(input_data(), filename, sep = ";") } 
      if(input$fileout == 'tsv' & input$tsv_spaceseparator == F) { fwrite(input_data(), filename, sep = "\t") } 
      if(input$fileout == 'tsv' & input$tsv_spaceseparator == T) { fwrite(input_data(), filename, sep = " ") } 
      if(input$fileout == 'json' & input$minify == T) { write_json(input_data(), filename, pretty = T) } 
      if(input$fileout == 'json' & input$minify == F) { write_json(input_data(), filename, pretty = F) } 
      if(input$fileout == 'xlsx' | input$fileout == 'sav' | input$fileout == 'dta') { export(input_data(), filename) } 
    },
    contentType = "application/zip"
  )
  
}
