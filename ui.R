if (!require('pacman')) install.packages('pacman')
p_load(shiny)

fluidPage(
  title = "Datawheel File Converter",
  tags$head(tags$link(rel='shortcut icon', href='http://pacha.datawheel.us/img/favicon.ico')),     
  #theme = shinytheme('flatly'),
  theme = 'theme.css',
  titlePanel(title = div("Datawheel File Converter", img(src='http://pacha.datawheel.us/img/datawheel_labs_small.png', align = 'right'))),
  fluidRow(
    column(6, h3('Input')),
    column(6, h3('Output'))
  ),
  fluidRow(
    column(6,wellPanel(
      fileInput('file', 'Upload your file (max size 20MB)',
                accept = c(
                  'text/csv',
                  'text/comma-separated-values',
                  'text/tab-separated-values',
                  'text/plain',
                  'application/json',
                  '.csv',
                  '.tsv',
                  '.json',
                  '.xlsx',
                  '.sav',
                  '.dta'
                )
      ),
      radioButtons(
        'filein', 'Input format', c('csv','tsv','xlsx','json','sav','dta'), selected = NULL, inline = T
      ),
      tags$hr(),
      conditionalPanel(condition = 'input.filein == "csv" | input.filein == "tsv"', p(strong('Advanced csv/tsv options'))),
      conditionalPanel(condition = 'input.filein == "xlsx"', p(strong('Advanced xlsx options'))),
      conditionalPanel(condition = 'input.filein == "csv" | input.filein == "tsv" | input.filein == "xlsx"', checkboxInput('header', 'My file has column names (leave marked if unsure)', TRUE)),
      conditionalPanel(condition = 'input.filein == "csv" | input.filein == "tsv" | input.filein == "xlsx"', checkboxInput('fixheader', 'Fix column names (leave marked if unsure)', TRUE)),
      conditionalPanel(condition = 'input.filein == "csv"', radioButtons('sep_csv', 'Separator',
                                                                         c('Comma' = ',', 'Semicolon' = ';'),
                                                                         selected = ',')),
      conditionalPanel(condition = 'input.filein == "csv"', radioButtons('quote_csv', 'Strings',
                                                                         c('Automatic detection' = '', 'Double quotes' = '\"', 'Single quotes' = '\''),
                                                                         selected = '')),
      conditionalPanel(condition = 'input.filein == "tsv"', radioButtons('sep_tsv', 'Separator', 
                                                                         c('Tabulation' = '\t', 'Space' = ' '), 
                                                                         selected = '\t')),
      conditionalPanel(condition = 'input.filein == "tsv"', radioButtons('quote_tsv', 'Strings',
                                                                         c('Automatic detection' = '', 'Double quotes' = '\"', 'Single quotes' = '\''),
                                                                         selected = ''))
      #conditionalPanel(condition = 'input.filein == "xlsx"',  textAreaInput('sheet_xlsx', 'Specify sheet (i.e. "Sheet1", optional)', '')),
      #conditionalPanel(condition = 'input.filein == "xlsx"',  textAreaInput('range_xlsx', 'Specify range (i.e. "A1:D40", optional)', ''))
    )),
    column(6,wellPanel(
      #verbatimTextOutput('templocation'),
      radioButtons(
        'fileout', 'Output format', c('csv','tsv','xlsx','json','sav','dta'), selected = NULL, inline = T
      ),
      conditionalPanel(condition = 'input.fileout == "csv" | input.fileout == "tsv"', p(strong('Advanced csv/tsv options'))),
      conditionalPanel(condition = 'input.fileout == "csv"', checkboxInput('csv_spanishseparator', 'Use semicolon as separator (mark this if you use non-English MS Excel version)', FALSE)),
      conditionalPanel(condition = 'input.fileout == "tsv"', checkboxInput('tsv_spaceseparator', 'Use space as separator (leave unmarked if unsure)', FALSE)),
      conditionalPanel(condition = 'input.fileout == "json"', p(strong('Advanced json options'))),
      conditionalPanel(condition = 'input.fileout == "json"', checkboxInput('minify', 'Minify the output (leave marked if unsure)', TRUE)),
      conditionalPanel(condition = '!output.preview', p('How it works? 
                                                        Upload your file and our R server will convert it accordingly. We don\'t stores copies of your files.'), 
                                                      p('Be wise and don\'t use this if doing so implies violating your company policies. We are not responsible for the use you give to this. Be warned.')), 
      conditionalPanel(condition = 'output.preview', 
                       h4('Preview'),
                       p(strong('This shows at most 10 rows and 5 columns to show you what your selected parameters turn into. The download button returns the complete file after conversion.')),
                       #conditionalPanel(condition = 'input.fileout == "xlsx"', verbatimTextOutput('text_input')),
                       tableOutput('preview'),
                       downloadButton('download_data', 'Download')),
      hr(),
      print('\u00a9 Datawheel, 2017. Released under MIT License.'),
      print('License and code:'), a('https://github.com/pachamaltese/convert-formats')
    ))
  )
  # fluidRow(column(12, 
  #   hr(), 
  #   print("\u00a9 Datawheel, 2017. Released under MIT License."))
  # )
)
