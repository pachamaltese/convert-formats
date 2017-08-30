if (!require('pacman')) install.packages('pacman')
p_load(shiny,shinyjs,tools)

fluidPage(
  useShinyjs(),
  title = 'Datawheel File Converter',
  tags$head(tags$link(rel='shortcut icon', href='http://pacha.datawheel.us/img/favicon.ico')),
  tags$head(includeScript('www/google-analytics.js')),
  #theme = shinytheme('flatly'),
  theme = 'theme.css',
  titlePanel(title = div('Datawheel File Converter', img(src='http://pacha.datawheel.us/img/datawheel_labs_small.png', align = 'right'))),
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
                       p('Be wise and don\'t use this if doing so implies violating your company policies. We are not responsible for the use you give to this. Be warned.')),
      hr(),
      print('\u00a9 Datawheel, 2017. Released under MIT License.'),
      print('License and code:'), a('https://github.com/pachamaltese/convert-formats')
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
                 div(img(src='http://pacha.datawheel.us/img/loading_small.gif'), p('') ,p('Datawheeling, please wait...'), align = 'center')
      )),
      div(id = "show_preview", conditionalPanel(condition = 'output.preview', h4('Preview'), tableOutput('preview'), downloadButton('download_data', 'Download')))
    ))
  )
)
