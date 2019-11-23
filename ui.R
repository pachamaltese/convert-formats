fluidPage(
  useShinyjs(),
  theme = shinytheme('flatly'),
  titlePanel('File Converter'),
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
      p(strong('Additional options')),
      checkboxInput('fixheader', 'Fix column names (don\'t change this if you are unsure)', TRUE),
      hr(),
      conditionalPanel(condition = '!output.preview', p('How this work?'), 
                       p('Upload your file and our server will convert it accordingly. We don\'t stores copies of your files.'), 
                       p('At the moment this tool supports csv, tsv, xls, xlsx, json, sav and dta.'),
                       p('Be wise and don\'t use this if doing so implies violating your company policies. We are not responsible for the use you give to this. Be warned.')),
      hr(),
      p('AGPL-3.0 license. See license and code at:'), a('https://github.com/pachamaltese/convert-formats')
    )),
    column(6,wellPanel(
      radioButtons(
        'fileout', 'Output format', c('csv','tsv','xlsx','json','sav','dta'), selected = NULL, inline = T
      ),
      conditionalPanel(condition = 'input.fileout == "csv" | input.fileout == "tsv"', p(strong('Advanced csv/tsv options'))),
      conditionalPanel(condition = 'input.fileout == "csv"', checkboxInput('csv_spanishseparator', 'Use semicolon as separator (mark this if you use non-English MS Excel version)', FALSE)),
      conditionalPanel(condition = 'input.fileout == "tsv"', checkboxInput('tsv_spaceseparator', 'Use space as separator (leave unmarked if unsure)', FALSE)),
      conditionalPanel(condition = 'input.fileout == "json"', p(strong('Advanced json options'))),
      conditionalPanel(condition = 'input.fileout == "json"', checkboxInput('minify', 'Minify the output (leave marked if unsure)', TRUE)),
      hidden(div(id = "loading_page",
                 div(img(src = "img/loading_icon.gif", width = "100"), p('') ,p('Processing, please wait...'), align = 'center')
      )),
      div(id = "show_preview", conditionalPanel(condition = 'output.preview', h4('Preview'), tableOutput('preview'), downloadButton('download_data', 'Download')))
    ))
  )
)
