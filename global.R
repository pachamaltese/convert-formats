if (!require('pacman')) install.packages('pacman')
p_load(shiny,shinyjs,rio,data.table,jsonlite,jsonlite,dplyr,stringr,shinythemes,tools)

# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 20MB.
options(shiny.maxRequestSize = 20*1024^2)
