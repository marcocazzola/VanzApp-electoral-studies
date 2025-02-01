# Dipendenze----
pkg.lst <- c("shiny", "shinydashboard", "shinyjs", "tidyverse", 
             "scales", "ggtext", "plotly", "openxlsx", "webshot")

# Funzione per assicurarsi che tutti i pacchetti necessari siano installati----
load.packages <- function(pkg.lst) {
  # Identifica i pacchetti che non sono installati
  to.be.installed <- pkg.lst[!(pkg.lst %in% installed.packages()[, "Package"])]
  
  # Installa i pacchetti mancanti
  if (length(to.be.installed) > 0) {
    install.packages(to.be.installed)
  } else {
    message("All packages already installed, proceeding to load them.")
  }
  
  # Carica tutti i pacchetti richiesti
  for (p in pkg.lst) {
    library(p, character.only = TRUE)
  }
  
}