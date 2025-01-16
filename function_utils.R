# Funzione per aggiungere trasparenza ad un colore di partenza----
alpha.func <- function(kolor, alpha.lvl) {
  if (kolor %in% c("#343434", "#d5d5d5", "#a2a2a2")) {
    return(kolor)
  } else {
    return(paste0(kolor, alpha.lvl))
  }
}

# Funzione per posizionare il logo correttamente sul grafico a barre----
logos.positioner <- function(data, pic_size=.15, ystart=1.17, xstart=-0.1) {
  
  out.list <- list()
  dist <- 1 / dim(data)[1]
  
  for (p in 1:dim(data)[1]) {
    out.list[[p]] <- list(source = base64enc::dataURI(file = data[p, dim(data)[2]]), 
                          xref = "x domain", yref = "y domain", 
                          xanchor = "left", yanchor = "top", 
                          sizex = pic_size, sizey = pic_size, 
                          x = xstart, y = ystart - dist*p)
  }
  return(out.list)
}

# Funzione per commento dinamico a risultato referendum----
ref.outcome <- function(x) {
  if (x == "REPUBBLICA") {
    return("la Repubblica.")
  } else if (x == "SI") {
    return("di approvare la proposta referendaria.")
  } else {
    return("di rigettare la proposta referendaria.")
  }
}

# Funzione per scegliere colonna corretta per tab storia partiti----
metric.map <- c(
  "Percentuale (su aventi diritto)" = "PERC_ASS",
  "Percentuale (su voti validi)" = "PERC_VAL",
  "Voti ottenuti" = "VOTI_OTTENUTI"
)