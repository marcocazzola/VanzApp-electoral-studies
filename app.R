# Libraries----
library(shiny)
library(shinydashboard)
library(shinyjs)
library(tidyverse)
library(scales)
library(ggtext)
library(plotly)

# UDF ----
source("function_utils.R")

# DICT UTILS (per loghi e colori)----
source("dict_utils.R")

# DATA INPUT----
com.dta <- read.csv("SHINY_INPUT_DATA/COMUNALI.csv")
naz.dta <- read.csv("SHINY_INPUT_DATA/NAZIONALI.csv")
eu.dta <- read.csv("SHINY_INPUT_DATA/EUROPEE.csv")
ref.dta <- read.csv("SHINY_INPUT_DATA/REFERENDUM.csv")
reg.dta <- read.csv("SHINY_INPUT_DATA/REGIONALI.csv")
part.dta <- read.csv("SHINY_INPUT_DATA/PARTITI.csv")

# UI ----
ui <- dashboardPage(
  
  ## DashboardHeader----
  dashboardHeader(
    # Set height of dashboardHeader
    tags$li(class = "dropdown",
            tags$style(".main-header {max-height: 100px}"),
            tags$style(".main-header .logo {height: 100px}")
            ),
    
    # title = "Portale dei risultati elettorali di Vanzaghello",
    titleWidth = 1000,
    title = div(
      img(src="Stemma_Comune.svg", #src="https://comune.vanzaghello.mi.it/wp-content/uploads/2022/03/Stemma_Comune.svg", 
          height="8%", width="8%")
       , em("Portale dei risultati elettorali di Vanzaghello", style="padding-bottom: 15px; padding-left: 20px;"), 
      align = "left"
    )
  ), 
  
  ## DashboardSidebar----
  dashboardSidebar(
    disable=TRUE,
    collapsed=TRUE
  ),
  
  ## dashboardBody----
  dashboardBody(
    tabsetPanel(
      type = "tabs",
      id = "tab_selected",
      selected = "Comunali",
      
      ### Europee----
      tabPanel(
        title = "Europee",
        sidebarLayout(
          sidebarPanel(
            br(),
            h4("Imposta i parametri per il grafico"),
            selectInput(
              inputId = "ANNO_EU",
              label = "Seleziona un anno",
              choices = sort(unique(eu.dta$ANNO), decreasing=TRUE),
              selected = max(eu.dta$ANNO)
            ),
            
            selectInput(
              inputId = "TIPO_VIZ_EU",
              label = "Seleziona come visualizzare i risultati", 
              choices = c("Percentuale",
                          "Voti ottenuti"),
              selected = "Percentuale"
            ),
            
            checkboxInput(
              inputId = "SHOW_ALL_EU",
              label = HTML("Mostra astenuti"),
              value = FALSE
            ),
            
            br(),
            h4("Risultati in breve"),
            p(textOutput("euResume_pt1")),
            p(textOutput("euResume_pt2"))
          ), 
          mainPanel(
            br(),
            h4(textOutput("euTitle")),
            plotlyOutput("euPlot", height = "500px"),
          )
        )
      ), 
      
      ### Nazionali----
      tabPanel(
        title = "Nazionali",
        sidebarLayout(
          sidebarPanel(
            br(),
            h4("Imposta i parametri per il grafico"),
            selectInput(
              inputId = "ANNO_NAZ",
              label = "Seleziona un anno*",
              choices = sort(unique(naz.dta$ANNO), decreasing=TRUE),
              selected = max(naz.dta$ANNO)
            ),
            
            selectInput(
              inputId = "TIPO_VIZ_NAZ",
              label = "Seleziona come visualizzare i risultati",
              choices = c("Percentuale",
                          "Voti ottenuti"),
              selected = "Percentuale"
            ),
            
            checkboxInput(
              inputId = "SHOW_ALL_NAZ",
              label = HTML("Mostra astenuti"),
              value = FALSE
            ),
            
            br(), 
            h4("Risultati in breve"),
            p(textOutput("nazResume_pt1")),
            p(textOutput("nazResume_pt2")),
            HTML("<font size='2'><b>*</b> <i>I dati relativi alle elezioni prima del 1968 includono anche 
                    il Comune di Magnago, di cui all'epoca Vanzaghello faceva parte
                    come frazione. Inoltre, nelle elezioni successive al 2006, la Valle d'Aosta non è 
                   inclusa nei risultati nazionali.</i></font>")
          ),
          mainPanel(
            br(),
            h4(textOutput("nazTitle")),
            plotlyOutput("nazPlot", height = "500px"),
          )
        )
      ),
      
      ### Regionali----
      tabPanel(
        title = "Regionali",
        sidebarLayout(
          sidebarPanel(
            br(),
            h4("Imposta i parametri per il grafico"),
            selectInput(
              inputId = "ANNO_REG",
              label = "Seleziona un anno",
              choices = sort(unique(reg.dta$ANNO), decreasing=TRUE),
              selected = max(reg.dta$ANNO)
            ),
            
            selectInput(
              inputId = "TIPO_VIZ_REG",
              label = "Seleziona come visualizzare i risultati",
              choices = c("Percentuale", "Voti ottenuti"),
              selected = "Percentuale"
            ),
            
            checkboxInput(
              inputId = "SHOW_ALL_REG",
              label = "Mostra astenuti",
              value = FALSE
            ),
            
            br(),
            h4("Risultati in breve"),
            p(textOutput("regResume_pt1")),
            p(textOutput("regResume_pt2"))
          ),
          mainPanel(
            br(),
            h4(textOutput("regTitle")),
            plotlyOutput("regPlot", height = "500px")
          )
        )
      ),
      
      ### Comunali-----
      tabPanel(
        title = "Comunali",
        sidebarLayout(
          sidebarPanel(
            br(),
            h4("Imposta i parametri per il grafico"),
            selectInput(
              inputId = "ANNO_COM",
              label = "Seleziona un anno",
              choices = sort(unique(com.dta$ANNO), decreasing=TRUE),
              selected = max(com.dta$ANNO)
            ),
            
            selectInput(
              inputId = "TIPO_VIZ_COM",
              label = "Seleziona come visualizzare i risultati",
              choices = c("Percentuale" , 
                          "Voti ottenuti"),
              selected = "Percentuale"
            ), 
            
            checkboxInput(
              inputId = "SHOW_ALL_COM", 
              label = HTML("Mostra astenuti e voti non validi"),
              value = FALSE
            ),
            br(),
            h4("Risultati in breve"),
            p(textOutput("comResume_pt1")),
            p(textOutput("comResume_pt2")),
            p(textOutput("comResume_pt3")),
            br()

          ),
          mainPanel(
            br(),
            h4(textOutput("comTitle")),
            plotlyOutput("comPlot", height = "500px")
          )
        )
      ),
      
      ### Referendum----
      tabPanel(
        title = "Referendum",
        sidebarLayout(
          sidebarPanel(
            br(),
            h4("Imposta i parametri per il grafico"),
            selectInput(
              inputId = "ANNO_REF",
              label = "Seleziona un quesito*",
              choices = sort(unique(ref.dta$SIMPLIFIED_Q), decreasing = TRUE),
              selected = max(ref.dta$SIMPLIFIED_Q)
            ),
            
            selectInput(
              inputId = "TIPO_VIZ_REF",
              label = "Seleziona come visualizzare i risultati",
              choices = c("Percentuale" , 
                          "Voti ottenuti"),
              selected = "Percentuale"
            ),
            
            checkboxInput(
              inputId = "SHOW_ALL_REF", 
              label = HTML("Mostra astenuti e voti non validi"),
              value = FALSE
            ),
            
            br(),
            h4("Risultati in breve"),
            p(textOutput("refResume_pt1")),
            p(textOutput("refResume_pt2")),
            p(textOutput("refResume_pt3")),
            HTML("<font size='2'><b>*</b> <i>I dati relativi al referendum del 1946 includono anche 
            il Comune di Magnago, di cui all'epoca Vanzaghello faceva parte come frazione. 
            Inoltre, non è stato possibile reperire online l'esito dei referendum a livello comunale 
            per gli anni dal 1987 al 2006.</i></font>")
          ),
          mainPanel(
            br(),
            h4(textOutput("refTitle")),
            plotlyOutput("refPlot", height = "500px")
          )
        )
      ), 
      
      ### Partiti----
      tabPanel(
        title = "Partiti",
        sidebarLayout(
          sidebarPanel(
            br(),
            # h4("Imposta i parametri per il grafico"),
            radioButtons(
              inputId = "N_PARTITI",
              label = h4("Visualizza i dati relativi a"),
              choices = list("Un singolo partito" = 1, "Più partiti" = 2),
              selected = 1
            ),
            
            ##### MULTIPARTY----
            conditionalPanel(
              condition = "input.N_PARTITI == 2",
              
              selectInput(
                inputId = "PARTITI",
                label = "Seleziona i partiti", 
                choices = sort(unique(part.dta$LISTA)),
                selected = c("DC", "PCI"),
                multiple = TRUE
              ),
              
              selectInput(
                inputId = "TIPO_VIZ_PART",
                label = "Seleziona come visualizzare i risultati",
                choices = c("Percentuale (su voti validi)", 
                            "Percentuale (su aventi diritto)",
                            "Voti ottenuti"),
                selected = "Percentuale (su voti validi)"
              )
            ),
            
            ##### SINGLEPARTY----
            conditionalPanel(
              condition = "input.N_PARTITI == 1",
              
              selectInput(
                inputId = "PARTITO",
                label = "Seleziona il partito", 
                choices = sort(unique(part.dta$LISTA)),
                selected = "DC"
              ),
              
              checkboxInput(
                inputId = "SHOW_ALL_PART", 
                label = HTML("Mostra percentuale su aventi diritto"),
                value = FALSE
              ),
            ), 
            
            br(),
            HTML("<b><u>N.B.</u></b>: si ricorda che i dati antecedenti al 1968 riguardano il comune di Magnago, 
            di cui all'epoca Vanzaghello faceva parte come frazione.")
            
          ),
          mainPanel(
            br(),
            h4(textOutput("partTitle")),
            plotlyOutput("partPlot", height = "500px")
          )
        )
      )
    )
  )
)

# SERVER ----
server <- function(input, output) {
  ## COMUNALI----
  
  ### DATA ----
  CLEAN.comData <- reactive({
    if (input$SHOW_ALL_COM & input$TIPO_VIZ_COM == "Percentuale") {
      CLEAN_df <- filter(com.dta, ANNO == input$ANNO_COM 
                         & LBL_TIPO_METRICA == "Percentuale (su aventi diritto)") 
    
    } else if (input$SHOW_ALL_COM & input$TIPO_VIZ_COM == "Voti ottenuti") {
      CLEAN_df <- filter(com.dta, ANNO == input$ANNO_COM 
                         & LBL_TIPO_METRICA == input$TIPO_VIZ_COM) 
      
    } else if (!input$SHOW_ALL_COM & input$TIPO_VIZ_COM == "Percentuale") {
      CLEAN_df <- filter(com.dta, ANNO == input$ANNO_COM 
                         & LBL_TIPO_METRICA == "Percentuale (su voti validi)"
                         & CANDIDATO != "ASTENUTI"
                         & CANDIDATO != "BIANCHE"
                         & CANDIDATO != "NULLE") 
    
    } else if (!input$SHOW_ALL_COM & input$TIPO_VIZ_COM == "Voti ottenuti") {
      CLEAN_df <- filter(com.dta, ANNO == input$ANNO_COM 
                         & LBL_TIPO_METRICA == input$TIPO_VIZ_COM
                         & CANDIDATO != "ASTENUTI"
                         & CANDIDATO != "BIANCHE"
                         & CANDIDATO != "NULLE") 
    
    }
    
    TXT_df <- filter(com.dta, ANNO == input$ANNO_COM & LBL_TIPO_METRICA == "Voti ottenuti")
    
    return(list("CLEAN_df" = CLEAN_df, "TXT_df" = TXT_df))
  }) 
  
  TXT.comData <- reactive({
    winner <- filter(com.dta, ANNO == input$ANNO_COM & LBL_TIPO_METRICA == "Percentuale (su voti validi)") %>% 
      select(CANDIDATO) %>% 
      first() %>% 
      pull()
    perc.winner <- filter(com.dta, ANNO == input$ANNO_COM & LBL_TIPO_METRICA == "Percentuale (su voti validi)") %>% 
      select(VOTI) %>% 
      first() %>% 
      pull()
    
    elettori <- sum(
      filter(com.dta, ANNO == input$ANNO_COM & LBL_TIPO_METRICA == "Voti ottenuti") %>% 
        select(VOTI) %>% 
        pull()
      )
    votanti <- sum(
      filter(com.dta, ANNO == input$ANNO_COM & LBL_TIPO_METRICA == "Voti ottenuti" & CANDIDATO != "ASTENUTI") %>% 
        select(VOTI) %>% 
        pull()
    )
    validi <- sum(
      filter(com.dta, ANNO == input$ANNO_COM & LBL_TIPO_METRICA == "Voti ottenuti" 
             & CANDIDATO != "ASTENUTI"
             & CANDIDATO != "BIANCHE"
             & CANDIDATO != "NULLE") %>% 
        select(VOTI) %>% 
        pull()
    )
    
    return(list("WINNER_NAME" = winner, "WINNER_PERC" = perc.winner,
                "ELETTORI" = elettori, "VOTANTI" = votanti, "VALIDI" = validi))
  })
  
  ### COLORS ----
  CLEAN.comColors <- reactive({
    com.kolors[CLEAN.comData()[["CLEAN_df"]] %>% 
                                  arrange(ABS_RANK) %>% 
                                  distinct(CANDIDATO_LISTA) %>% 
                                  pull()]
  })

  ### PLOT ----
  output$comPlot <- renderPlotly({
    
    if(input$TIPO_VIZ_COM == "Voti ottenuti") {
      
      plot_ly(CLEAN.comData()[["CLEAN_df"]], y = ~CANDIDATO_LISTA, x = ~VOTI,
              type = 'bar', name = 'Voti assoluti', 
              hovertext = ~paste0('<b>', CANDIDATO_LISTA, '</b> <br>', LBL_TIPO_METRICA, ": ", formatC(VOTI, big.mark = ".", decimal.mark=",")),
              hoverinfo="text",
              marker = list(color=CLEAN.comColors())) %>% 
        
        layout(yaxis=list(categoryorder='array', categoryarray=rev(names(CLEAN.comColors())),  
                          title='', tickfont=list(size=12)),
               xaxis=list(title='', tickfont=list(size=15)), 
               showlegend=FALSE,
               margin = list(pad = 4))
      
    } else {
      plot_ly(CLEAN.comData()[["CLEAN_df"]], y = ~CANDIDATO_LISTA, x = ~VOTI,
              type = 'bar', name = 'Voti assoluti', 
              hovertext = ~paste0('<b>', CANDIDATO_LISTA, '</b> <br>', LBL_TIPO_METRICA, ": ", formatC(VOTI, big.mark=".", decimal.mark=","), "%"),
              hoverinfo="text",
              marker = list(color=CLEAN.comColors())) %>% 
        
        layout(yaxis=list(categoryorder='array', categoryarray=rev(names(CLEAN.comColors())),  
                          title='', zeroline=FALSE, tickfont=list(size=12)),
               xaxis=list(ticksuffix="%", title='', tickfont=list(size=15)),
               
               showlegend=FALSE,
               margin = list(pad = 4))
    }
  })
  
  ### TEXT----
  output$comTitle <- renderText({paste("Risultati delle elezioni comunali di Vanzaghello del", input$ANNO_COM)})
  output$comResume_pt1 <- renderText({
    paste0("Le elezioni comunali del ", input$ANNO_COM, " di Vanzaghello hanno avuto luogo il ", 
          unique(CLEAN.comData()[["TXT_df"]]$GIORNO), " ", unique(CLEAN.comData()[["TXT_df"]]$MESE),".")
  })
  
  output$comResume_pt2 <- renderText({
    paste0("È stato eletto sindaco ", TXT.comData()[["WINNER_NAME"]], ", con il ", 
           formatC(TXT.comData()[["WINNER_PERC"]], decimal.mark=",", big.mark = "."), 
          "% delle preferenze validamente espresse.")
  })
  
  output$comResume_pt3 <- renderText({
    paste0("Su un totale di ", formatC(TXT.comData()[["ELETTORI"]], decimal.mark = ",", big.mark="."), 
           " aventi diritto, i votanti sono stati ", 
          formatC(TXT.comData()[["VOTANTI"]], decimal.mark = ",", big.mark="."),
          ", con ", formatC(TXT.comData()[["VALIDI"]], decimal.mark = ",", big.mark="."), 
          " voti validi, ", formatC(CLEAN.comData()[["TXT_df"]][CLEAN.comData()[["TXT_df"]]$CANDIDATO_LISTA == "BIANCHE", "VOTI"], big.mark=".", decimal.mark = ","), 
          " schede bianche e ", formatC(CLEAN.comData()[["TXT_df"]][CLEAN.comData()[["TXT_df"]]$CANDIDATO_LISTA == "NULLE", "VOTI"], big.mark=".", decimal.mark = ","), 
          " schede nulle.\n", 
          formatC(CLEAN.comData()[["TXT_df"]][CLEAN.comData()[["TXT_df"]]$CANDIDATO_LISTA == "ASTENUTI", "VOTI"], decimal.mark = ",", big.mark="."), 
          " cittadini si sono astenuti, determinando un'affluenza pari a ", formatC(
          TXT.comData()[["VOTANTI"]] * 100 / TXT.comData()[["ELETTORI"]],
          decimal.mark = ",", big.mark="."), "%.")
  })
  
  # NAZIONALI----
  ### DATA ----
  CLEAN.nazData <- reactive({
    if (input$SHOW_ALL_NAZ & input$TIPO_VIZ_NAZ == "Percentuale") {
      CLEAN_df <- filter(naz.dta, ANNO == input$ANNO_NAZ 
                         & LBL_TIPO_METRICA == "Percentuale (su aventi diritto)") %>% 
        na.omit() %>% 
        merge(logos) %>% 
        arrange(ABS_RANK)
    
    } else if (input$SHOW_ALL_NAZ & input$TIPO_VIZ_NAZ == "Voti ottenuti") {
      CLEAN_df <- filter(naz.dta, ANNO == input$ANNO_NAZ 
                         & LBL_TIPO_METRICA == input$TIPO_VIZ_NAZ) %>% 
        na.omit() %>% 
        merge(logos) %>% 
        arrange(ABS_RANK)
    
    } else if (!input$SHOW_ALL_NAZ & input$TIPO_VIZ_NAZ == "Percentuale") {
      CLEAN_df <- filter(naz.dta, ANNO == input$ANNO_NAZ
                         & LBL_TIPO_METRICA == "Percentuale (su voti validi)") %>% 
        na.omit() %>% 
        merge(logos) %>% 
        arrange(ABS_RANK)
    
    } else if (!input$SHOW_ALL_NAZ & input$TIPO_VIZ_NAZ == "Voti ottenuti") {
      CLEAN_df <- filter(naz.dta, ANNO == input$ANNO_NAZ
                         & LBL_TIPO_METRICA == "Voti ottenuti"
                         & LISTA != "ASTENUTI") %>% 
        na.omit() %>% 
        merge(logos) %>% 
        arrange(ABS_RANK)
    }
    
    TXT_df <- filter(naz.dta, ANNO == input$ANNO_NAZ & LBL_TIPO_METRICA == "Voti ottenuti" & FLG_NOT_VALID == 1)
    
    return(list("CLEAN_df" = CLEAN_df, "TXT_df" = TXT_df))
  })
  
  TXT.nazData <- reactive({
    winner <- filter(naz.dta, ANNO == input$ANNO_NAZ & LBL_TIPO_METRICA == "Percentuale (su voti validi)") %>% 
      arrange(desc(LOCALE)) %>% 
      select(LISTA) %>% 
      first() %>% 
      pull()
    perc.winner <- filter(naz.dta, ANNO == input$ANNO_NAZ & LBL_TIPO_METRICA == "Percentuale (su voti validi)") %>% 
      select(LOCALE) %>% 
      arrange(desc(LOCALE)) %>% 
      first() %>% 
      pull()
    
    return(list("WINNER_NAME" = winner, "WINNER_PERC" = perc.winner))
  })
  
  ### COLORS ----
  CLEAN.nazColors <- reactive({

    CLEAN_colors <- p.kolors[CLEAN.nazData()[["CLEAN_df"]] %>% 
                               na.omit() %>% 
                               arrange(ABS_RANK) %>% 
                               distinct(LISTA) %>% 
                               pull()]
    return(CLEAN_colors)
  }) 
  
  ### PLOT PARAMS----
  naz.picSize <- reactive({ifelse(input$SHOW_ALL_NAZ, 0.12, 0.15)}) 
  naz.xStart <- reactive({ifelse(input$SHOW_ALL_NAZ, -0.08, -0.1)})
  naz.yStart <- reactive({ifelse(input$SHOW_ALL_NAZ, 1.142, 1.17)})
  naz.M <- reactive({ifelse(input$SHOW_ALL_NAZ, 140, 150)})
  naz.com <- reactive({ifelse(input$ANNO_NAZ < 1968, "MAGNAGO", "VANZAGHELLO")})
  
  
  ### PLOT ----
  output$nazPlot <- renderPlotly({
    if (input$TIPO_VIZ_NAZ == "Voti ottenuti") {
      
      plot_ly(CLEAN.nazData()[["CLEAN_df"]], y = ~LISTA, x = ~LOCALE,
              type = 'bar', name = 'Voti ottenuti', 
              hovertext = ~paste0('<b>', LISTA, '</b> <br>Voti ottenuti a ', COMUNE, ': ', formatC(LOCALE, big.mark = ".", decimal.mark = ",")),
              hoverinfo="text",
              marker = list(color=CLEAN.nazColors())) %>% 
        
        layout(yaxis=list(categoryorder='array', categoryarray=rev(names(CLEAN.nazColors())),  
                          title='', showticklabels=FALSE, tickfont=list(size=15)),
               xaxis=list(title='', tickfont=list(size=15)), 
               showlegend=FALSE, 
               margin = list(l = naz.M()),
               images= logos.positioner(
                 CLEAN.nazData()[["CLEAN_df"]], 
                 pic_size=naz.picSize(), 
                 xstart=naz.xStart(), ystart=naz.yStart()))
      
    } else {
      
      plot_ly(CLEAN.nazData()[["CLEAN_df"]], y = ~LISTA, x = ~NAZIONALE,
              type = 'bar', name = 'VOTI NAZIONALE', 
              hovertext = ~paste0('<b>', LISTA, '</b> <br> RISULTATI ITALIA: ', formatC(NAZIONALE, big.mark=".", decimal.mark=","), '%'),
              hoverinfo="text",
              marker = list(color=sapply(CLEAN.nazColors(), alpha.func, '64'))) %>% 
        
        add_trace(x = ~LOCALE, name="VOTI", 
                  hovertext = ~paste0('<b>', LISTA, '</b> <br> RISULTATI ', COMUNE, ": ", formatC(LOCALE, big.mark=".", decimal.mark=","), '%'),
                  hoverinfo = 'text',
                  marker = list(color=CLEAN.nazColors())) %>% 
        
        layout(yaxis=list(categoryorder='array', categoryarray=rev(names(CLEAN.nazColors())),  
                          title='', showticklabels=FALSE),
               xaxis=list(ticksuffix = "%", title='', tickfont=list(size=15)), 
               showlegend=FALSE, 
               margin = list(l = naz.M()),
               images= logos.positioner(
                 CLEAN.nazData()[["CLEAN_df"]], 
                 pic_size=naz.picSize(), 
                 xstart=naz.xStart(), ystart=naz.yStart()))
      
    }
  })
  
  ### TEXT----
  output$nazTitle <- renderText({paste("Top 5 partiti più votati a ", str_to_title(naz.com()) , "alle elezioni politiche del", input$ANNO_NAZ)})
  
  output$nazResume_pt1 <- renderText({paste0(
    "Alle elezioni politiche del ", input$ANNO_NAZ, ", ",
    TXT.nazData()[["WINNER_NAME"]],
    " è risultato il partito più votato a ", str_to_title(naz.com()), " con il ", 
    formatC(TXT.nazData()[["WINNER_PERC"]], decimal.mark=",", big.mark="."),
    "% delle preferenze validamente espresse."
  )}) 
  
  output$nazResume_pt2 <- renderText({paste0(
    "Su un totale di ", formatC(CLEAN.nazData()[["TXT_df"]][CLEAN.nazData()[["TXT_df"]]$LISTA == "ELETTORI", "LOCALE"], big.mark=".", decimal.mark = ","), 
    " aventi diritto, i votanti sono stati ", formatC(CLEAN.nazData()[["TXT_df"]][CLEAN.nazData()[["TXT_df"]]$LISTA == "VOTANTI", "LOCALE"], big.mark=".", decimal.mark = ","), 
    ", con ", formatC(
      CLEAN.nazData()[["TXT_df"]][CLEAN.nazData()[["TXT_df"]]$LISTA == "VOTANTI", "LOCALE"] 
      - CLEAN.nazData()[["TXT_df"]][CLEAN.nazData()[["TXT_df"]]$LISTA == "BIANCHE", "LOCALE"]
      - CLEAN.nazData()[["TXT_df"]][CLEAN.nazData()[["TXT_df"]]$LISTA == "NULLE", "LOCALE"],
      big.mark=".", decimal.mark = ","), " voti validi, ",
    formatC(CLEAN.nazData()[["TXT_df"]][CLEAN.nazData()[["TXT_df"]]$LISTA == "BIANCHE", "LOCALE"], big.mark=".", decimal.mark = ","), 
    " schede bianche e ", 
    formatC(CLEAN.nazData()[["TXT_df"]][CLEAN.nazData()[["TXT_df"]]$LISTA == "NULLE", "LOCALE"], big.mark=".", decimal.mark = ","), 
    " schede nulle.\n", 
    formatC(CLEAN.nazData()[["TXT_df"]][CLEAN.nazData()[["TXT_df"]]$LISTA == "ASTENUTI", "LOCALE"], big.mark=".", decimal.mark = ","), 
    " cittadini si sono astenuti, determinando un'affluenza pari a ",
    formatC(
      CLEAN.nazData()[["TXT_df"]][CLEAN.nazData()[["TXT_df"]]$LISTA == "VOTANTI", "LOCALE"] * 100 / CLEAN.nazData()[["TXT_df"]][CLEAN.nazData()[["TXT_df"]]$LISTA == "ELETTORI", "LOCALE"],
      big.mark=".", decimal.mark = ","), "%."
    
  )})
  
  #EUROPEE----
  ### DATA ----
  CLEAN.euData <- reactive({
    if (input$SHOW_ALL_EU & input$TIPO_VIZ_EU == "Percentuale") {
      CLEAN_df <- filter(eu.dta, ANNO == input$ANNO_EU 
                         & LBL_TIPO_METRICA == "Percentuale (su aventi diritto)") %>% 
        na.omit() %>% 
        merge(logos) %>% 
        arrange(ABS_RANK)
      
    } else if (input$SHOW_ALL_EU & input$TIPO_VIZ_EU == "Voti ottenuti") {
      CLEAN_df <- filter(eu.dta, ANNO == input$ANNO_EU 
                         & LBL_TIPO_METRICA == input$TIPO_VIZ_EU) %>% 
        na.omit() %>% 
        merge(logos) %>% 
        arrange(ABS_RANK)
      
    } else if (!input$SHOW_ALL_EU & input$TIPO_VIZ_EU == "Percentuale") {
      CLEAN_df <- filter(eu.dta, ANNO == input$ANNO_EU
                         & LBL_TIPO_METRICA == "Percentuale (su voti validi)") %>% 
        na.omit() %>% 
        merge(logos) %>% 
        arrange(ABS_RANK)
      
    } else if (!input$SHOW_ALL_EU & input$TIPO_VIZ_EU == "Voti ottenuti") {
      CLEAN_df <- filter(eu.dta, ANNO == input$ANNO_EU
                         & LBL_TIPO_METRICA == "Voti ottenuti"
                         & LISTA != "ASTENUTI") %>% 
        na.omit() %>% 
        merge(logos) %>% 
        arrange(ABS_RANK)
    }
    
    TXT_df <- filter(eu.dta, ANNO == input$ANNO_EU & LBL_TIPO_METRICA == "Voti ottenuti" & FLG_NOT_VALID == 1)
    
    return(list("CLEAN_df" = CLEAN_df, "TXT_df" = TXT_df))
  })
  
  TXT.euData <- reactive({
    winner <- filter(eu.dta, ANNO == input$ANNO_EU & LBL_TIPO_METRICA == "Percentuale (su voti validi)") %>% 
      arrange(desc(LOCALE)) %>% 
      select(LISTA) %>% 
      first() %>% 
      pull()
    perc.winner <- filter(eu.dta, ANNO == input$ANNO_EU & LBL_TIPO_METRICA == "Percentuale (su voti validi)") %>% 
      select(LOCALE) %>% 
      arrange(desc(LOCALE)) %>% 
      first() %>% 
      pull()
    
    return(list("WINNER_NAME" = winner, "WINNER_PERC" = perc.winner))
  })
  
  ### COLORS ----
  CLEAN.euColors <- reactive({
    CLEAN_colors <- p.kolors[CLEAN.euData()[["CLEAN_df"]] %>% 
                               na.omit() %>% 
                               arrange(ABS_RANK) %>% 
                               distinct(LISTA) %>% 
                               pull()]
    return(CLEAN_colors)
  }) 
  
  ### PLOT PARAMS----
  eu.picSize <- reactive({ifelse(input$SHOW_ALL_EU, 0.12, 0.15)}) 
  eu.xStart <- reactive({ifelse(input$SHOW_ALL_EU, -0.08, -0.1)})
  eu.yStart <- reactive({ifelse(input$SHOW_ALL_EU, 1.142, 1.17)})
  eu.M <- reactive({ifelse(input$SHOW_ALL_EU, 140, 150)})
  
  
  ### PLOT ----
  output$euPlot <- renderPlotly({
    if (input$TIPO_VIZ_EU == "Voti ottenuti") {
      
      plot_ly(CLEAN.euData()[["CLEAN_df"]], y = ~LISTA, x = ~LOCALE,
              type = 'bar', name = 'Voti ottenuti', 
              hovertext = ~paste0('<b>', LISTA, '</b> <br>Voti ottenuti a Vanzaghello', ': ', formatC(LOCALE, big.mark = ".", decimal.mark = ",")),
              hoverinfo="text",
              marker = list(color=CLEAN.euColors())) %>% 
        
        layout(yaxis=list(categoryorder='array', categoryarray=rev(names(CLEAN.euColors())),  
                          title='', showticklabels=FALSE),
               xaxis=list(title='', tickfont=list(size=15)), 
               showlegend=FALSE, 
               margin = list(l = eu.M()),
               images= logos.positioner(
                 CLEAN.euData()[["CLEAN_df"]], 
                 pic_size=eu.picSize(), 
                 xstart=eu.xStart(), ystart=eu.yStart()))
      
    } else {
      
      plot_ly(CLEAN.euData()[["CLEAN_df"]], y = ~LISTA, x = ~NAZIONALE,
              type = 'bar', name = 'VOTI NAZIONALE', 
              hovertext = ~paste0('<b>', LISTA, '</b> <br> RISULTATI ITALIA: ', formatC(NAZIONALE, big.mark=".", decimal.mark=","), '%'),
              hoverinfo="text",
              marker = list(color=sapply(CLEAN.euColors(), alpha.func, '64'))) %>% 
        
        add_trace(x = ~LOCALE, name="VOTI", 
                  hovertext = ~paste0('<b>', LISTA, '</b> <br> RISULTATI VANZAGHELLO', ": ", formatC(LOCALE, big.mark=".", decimal.mark=","), '%'),
                  hoverinfo = 'text',
                  marker = list(color=CLEAN.euColors())) %>% 
        
        layout(yaxis=list(categoryorder='array', categoryarray=rev(names(CLEAN.euColors())),  
                          title='', showticklabels=FALSE),
               xaxis=list(ticksuffix = "%", title='', tickfont=list(size=15)), 
               showlegend=FALSE, 
               margin = list(l = eu.M()),
               images= logos.positioner(
                 CLEAN.euData()[["CLEAN_df"]], 
                 pic_size=eu.picSize(), 
                 xstart=eu.xStart(), ystart=eu.yStart()))
      
    }
  })
  
  ### TEXT----
  output$euTitle <- renderText({paste("Top 5 partiti più votati a Vanzaghello alle elezioni europee del", input$ANNO_EU)})
  
  output$euResume_pt1 <- renderText({paste0(
    "Alle elezioni europee del ", input$ANNO_EU, ", ",
    TXT.euData()[["WINNER_NAME"]],
    " è risultato il partito più votato a Vanzaghello, con il ", 
    formatC(TXT.euData()[["WINNER_PERC"]], decimal.mark=",", big.mark="."),
    "% delle preferenze validamente espresse."
  )}) 
  
  output$euResume_pt2 <- renderText({paste0(
    "Su un totale di ", formatC(CLEAN.euData()[["TXT_df"]][CLEAN.euData()[["TXT_df"]]$LISTA == "ELETTORI", "LOCALE"], big.mark=".", decimal.mark = ","), 
    " aventi diritto, i votanti sono stati ", formatC(CLEAN.euData()[["TXT_df"]][CLEAN.euData()[["TXT_df"]]$LISTA == "VOTANTI", "LOCALE"], big.mark=".", decimal.mark = ","), 
    ", con ", formatC(
      CLEAN.euData()[["TXT_df"]][CLEAN.euData()[["TXT_df"]]$LISTA == "VOTANTI", "LOCALE"] 
      - CLEAN.euData()[["TXT_df"]][CLEAN.euData()[["TXT_df"]]$LISTA == "BIANCHE", "LOCALE"]
      - CLEAN.euData()[["TXT_df"]][CLEAN.euData()[["TXT_df"]]$LISTA == "NULLE", "LOCALE"],
      big.mark=".", decimal.mark = ","), " voti validi, ",
    formatC(CLEAN.euData()[["TXT_df"]][CLEAN.euData()[["TXT_df"]]$LISTA == "BIANCHE", "LOCALE"], big.mark=".", decimal.mark = ","), 
    " schede bianche e ", 
    formatC(CLEAN.euData()[["TXT_df"]][CLEAN.euData()[["TXT_df"]]$LISTA == "NULLE", "LOCALE"], big.mark=".", decimal.mark = ","), 
    " schede nulle.\n", 
    formatC(CLEAN.euData()[["TXT_df"]][CLEAN.euData()[["TXT_df"]]$LISTA == "ASTENUTI", "LOCALE"], big.mark=".", decimal.mark = ","), 
    " cittadini si sono astenuti, determinando un'affluenza pari a ",
    formatC(
      CLEAN.euData()[["TXT_df"]][CLEAN.euData()[["TXT_df"]]$LISTA == "VOTANTI", "LOCALE"] * 100 / CLEAN.euData()[["TXT_df"]][CLEAN.euData()[["TXT_df"]]$LISTA == "ELETTORI", "LOCALE"],
      big.mark=".", decimal.mark = ","), "%."
  )})
  
  # REFERENDUM----
  
  ### DATA ----
  CLEAN.refData <- reactive({
    if (input$SHOW_ALL_REF & input$TIPO_VIZ_REF == "Percentuale") {
      CLEAN_df <- filter(ref.dta, SIMPLIFIED_Q == input$ANNO_REF
                         & LBL_TIPO_METRICA == "Percentuale (su aventi diritto)"
                         & PREFERENZA != "ELETTORI"
                         & PREFERENZA != "VOTANTI") 
      
    } else if (input$SHOW_ALL_REF & input$TIPO_VIZ_REF == "Voti ottenuti") {
      CLEAN_df <- filter(ref.dta, SIMPLIFIED_Q == input$ANNO_REF
                         & LBL_TIPO_METRICA == input$TIPO_VIZ_REF
                         & PREFERENZA != "ELETTORI"
                         & PREFERENZA != "VOTANTI") 
      
    } else if (!input$SHOW_ALL_REF & input$TIPO_VIZ_REF == "Percentuale") {
      CLEAN_df <- filter(ref.dta, SIMPLIFIED_Q == input$ANNO_REF
                         & LBL_TIPO_METRICA == "Percentuale (su voti validi)"
                         & FLG_NOT_VALID == 0) 
      
    } else if (!input$SHOW_ALL_REF & input$TIPO_VIZ_REF == "Voti ottenuti") {
      CLEAN_df <- filter(ref.dta, SIMPLIFIED_Q == input$ANNO_REF
                         & LBL_TIPO_METRICA == input$TIPO_VIZ_REF
                         & FLG_NOT_VALID == 0) 
      
    }
    
    TXT_df <- filter(ref.dta, SIMPLIFIED_Q == input$ANNO_REF & LBL_TIPO_METRICA == "Voti ottenuti")
    
    return(list("CLEAN_df" = CLEAN_df, "TXT_df" = TXT_df))
  }) 
  
  TXT.refData <- reactive({
    winner <- filter(ref.dta, SIMPLIFIED_Q == input$ANNO_REF & LBL_TIPO_METRICA == "Percentuale (su voti validi)") %>% 
      arrange(desc(LOCALE)) %>% 
      select(PREFERENZA) %>% 
      first() %>% 
      pull()
    perc.winner <- filter(ref.dta, SIMPLIFIED_Q == input$ANNO_REF & LBL_TIPO_METRICA == "Percentuale (su voti validi)") %>% 
      select(LOCALE) %>% 
      arrange(desc(LOCALE)) %>% 
      first() %>% 
      pull()
    
    
    return(list("WINNER_NAME" = winner, "WINNER_PERC" = perc.winner))
  })
  
  ### COLORS ----
  CLEAN.refColors <- reactive({
    
    CLEAN_colors <- ref.kolors[CLEAN.refData()[["CLEAN_df"]] %>% 
                               na.omit() %>% 
                               arrange(desc(LOCALE)) %>% 
                               select(PREFERENZA) %>% 
                               pull()]
    return(CLEAN_colors)
  }) 
  
  ### PLOT PARAMS----
  ref.com <- reactive({ifelse(input$ANNO_REF == "1946 - Monarchia vs Repubblica", "MAGNAGO", "VANZAGHELLO")})
  
  ### PLOT ----
  output$refPlot <- renderPlotly({
    if (input$TIPO_VIZ_REF == "Voti ottenuti") {
      
      plot_ly() %>% 
        add_pie(data=CLEAN.refData()[["CLEAN_df"]], labels = ~PREFERENZA, values = ~LOCALE, 
                showlegend = FALSE, hoverinfo = 'text', textposition = 'inside', 
                textinfo = "label", texttemplate = '<b>%{label}</b>', 
                text = ~paste0('<b>', PREFERENZA, '</b><br>', LBL_TIPO_METRICA, ": ", formatC(LOCALE, big.mark=".", decimal.mark=",")),
                marker = list(colors = CLEAN.refColors()), 
                title=list(text=paste("Risultati", str_to_title(ref.com()), "<br> <span style='color:white'>.</span>"), font=list(size=15)),
                domain = list(row=0, column = 0)) %>% 
        add_pie(data=CLEAN.refData()[["CLEAN_df"]], labels = ~PREFERENZA, values = ~NAZIONALE, 
                showlegend = FALSE, hoverinfo = 'text', textposition = 'inside', 
                textinfo = "label", texttemplate = '<b>%{label}</b>', 
                text = ~paste0('<b>', PREFERENZA, '</b><br>', LBL_TIPO_METRICA, ": ", trimws(formatC(NAZIONALE, big.mark=".", decimal.mark=",", digits = 10))),
                marker = list(colors = CLEAN.refColors()), 
                title=list(text="Risultati Italia <br> <span style='color:white'>.</span>", font=list(size=15)),
                domain = list(row=0, column = 1)) %>% 
        layout(grid=list(rows=1, columns=2))
      
    } else {
      
      plot_ly() %>% 
        add_pie(data=CLEAN.refData()[["CLEAN_df"]], labels = ~PREFERENZA, values = ~LOCALE, 
                showlegend = FALSE, hoverinfo = 'text', textposition = 'inside', 
                textinfo = "label", texttemplate = '<b>%{label}</b>', 
                text = ~paste0('<b>', PREFERENZA, '</b><br>', LBL_TIPO_METRICA, ": ", formatC(LOCALE, big.mark=".", decimal.mark=","), "%"),
                marker = list(colors = CLEAN.refColors()), 
                title=list(text=paste("Risultati", str_to_title(ref.com()), "<br> <span style='color:white'>.</span>"), font=list(size=15)),
                domain = list(row=0, column = 0)) %>% 
        add_pie(data=CLEAN.refData()[["CLEAN_df"]], labels = ~PREFERENZA, values = ~NAZIONALE, 
                showlegend = FALSE, hoverinfo = 'text', textposition = 'inside', 
                textinfo = "label", texttemplate = '<b>%{label}</b>', 
                text = ~paste0('<b>', PREFERENZA, '</b><br>', LBL_TIPO_METRICA, ": ", formatC(NAZIONALE, big.mark=".", decimal.mark=","), "%"),
                marker = list(colors = CLEAN.refColors()), 
                title=list(text="Risultati Italia <br> <span style='color:white'>.</span>", font=list(size=15)),
                domain = list(row=0, column = 1)) %>% 
        layout(grid=list(rows=1, columns=2))
      
    }
  })
  
  ### TEXT----
  output$refTitle <- renderText({paste0(
    unique(CLEAN.refData()[["CLEAN_df"]]$QUESITO),
    " (", unique(CLEAN.refData()[["CLEAN_df"]]$ANNO), ")"
  )})
  
  output$refResume_pt1 <- renderText({paste0(
    "Il referendum del ", unique(CLEAN.refData()[["CLEAN_df"]]$ANNO), 
    " ha chiamato i cittadini ", unique(CLEAN.refData()[["CLEAN_df"]]$VERBOSE_Q)
  )})
  
  output$refResume_pt2 <- renderText({paste0(
    "A ", str_to_title(ref.com()), ", ", formatC(CLEAN.refData()[["TXT_df"]] %>% filter(PREFERENZA == "VOTANTI") %>% select(LOCALE) %>% pull(), big.mark = ".", decimal.mark = ","),
    " cittadini si sono recati a votare, determinando un'affluenza pari a ", formatC(
      CLEAN.refData()[["TXT_df"]] %>% filter(PREFERENZA == "VOTANTI") %>% select(LOCALE) %>% pull() * 100 / CLEAN.refData()[["TXT_df"]] %>% filter(PREFERENZA == "ELETTORI") %>% select(LOCALE) %>% pull(),
      big.mark = ".", decimal.mark = ","
    ), "%."
  )})
  
  output$refResume_pt3 <- renderText({paste0(
    "Con il ", TXT.refData()[["WINNER_PERC"]] %>% formatC(big.mark=".", decimal.mark=","), 
    "% delle preferenze validamente espresse, i ", ifelse(
      unique(CLEAN.refData()[["TXT_df"]]$ANNO) == 1946,
      "magnaghesi", "vanzaghellesi"
    ),
    " hanno scelto ",
    ref.outcome(TXT.refData()[["WINNER_NAME"]]), 
    ifelse(
      CLEAN.refData()[["TXT_df"]] %>% filter(PREFERENZA == "VOTANTI") %>% select(NAZIONALE) %>% pull() / CLEAN.refData()[["TXT_df"]] %>% filter(PREFERENZA == "ELETTORI") %>% select(NAZIONALE) %>% pull() < 0.5,
      " Tuttavia, avendo mancato la soglia del 50% di partecipazione a livello nazionale, il referendum è da ritenersi non valido.", ""
    )
  )})
  
  # REGIONALI----
  ### DATA ----
  CLEAN.regData <- reactive({
    if (input$SHOW_ALL_REG & input$TIPO_VIZ_REG == "Percentuale") {
      CLEAN_df <- filter(reg.dta, ANNO == input$ANNO_REG 
                         & LBL_TIPO_METRICA == "Percentuale (su aventi diritto)") %>% 
        na.omit() %>% 
        merge(logos) %>% 
        arrange(ABS_RANK)
      
    } else if (input$SHOW_ALL_REG & input$TIPO_VIZ_REG == "Voti ottenuti") {
      CLEAN_df <- filter(reg.dta, ANNO == input$ANNO_REG
                         & LBL_TIPO_METRICA == input$TIPO_VIZ_REG) %>% 
        na.omit() %>% 
        merge(logos) %>% 
        arrange(ABS_RANK)
      
    } else if (!input$SHOW_ALL_REG & input$TIPO_VIZ_REG == "Percentuale") {
      CLEAN_df <- filter(reg.dta, ANNO == input$ANNO_REG
                         & LBL_TIPO_METRICA == "Percentuale (su voti validi)") %>% 
        na.omit() %>% 
        merge(logos) %>% 
        arrange(ABS_RANK)
      
    } else if (!input$SHOW_ALL_REG & input$TIPO_VIZ_REG == "Voti ottenuti") {
      CLEAN_df <- filter(reg.dta, ANNO == input$ANNO_REG
                         & LBL_TIPO_METRICA == "Voti ottenuti"
                         & LISTA != "ASTENUTI") %>% 
        na.omit() %>% 
        merge(logos) %>% 
        arrange(ABS_RANK)
    }
    
    TXT_df <- filter(reg.dta, ANNO == input$ANNO_REG & LBL_TIPO_METRICA == "Voti ottenuti" & FLG_NOT_VALID == 1)
    
    return(list("CLEAN_df" = CLEAN_df, "TXT_df" = TXT_df))
  })
  
  TXT.regData <- reactive({
    winner <- filter(reg.dta, ANNO == input$ANNO_REG & LBL_TIPO_METRICA == "Percentuale (su voti validi)") %>% 
      arrange(desc(LOCALE)) %>% 
      select(LISTA) %>% 
      first() %>% 
      pull()
    perc.winner <- filter(reg.dta, ANNO == input$ANNO_REG & LBL_TIPO_METRICA == "Percentuale (su voti validi)") %>% 
      select(LOCALE) %>% 
      arrange(desc(LOCALE)) %>% 
      first() %>% 
      pull()
    pres <- case_when(
      input$ANNO_REG == 1995 ~ "È stato eletto presidente Roberto Formigoni.",
      input$ANNO_REG == 2000 ~ "È stato eletto presidente Roberto Formigoni.",
      input$ANNO_REG == 2005 ~ "È stato eletto presidente Roberto Formigoni.",
      input$ANNO_REG == 2010 ~ "È stato eletto presidente Roberto Formigoni.",
      input$ANNO_REG == 2013 ~ "È stato eletto presidente Roberto Maroni.",
      input$ANNO_REG == 2018 ~ "È stato eletto presidente Attilio Fontana.",
      input$ANNO_REG == 2023 ~ "È stato eletto presidente Attilio Fontana.",
      .default = ""
    )
    
    return(list("WINNER_NAME" = winner, "WINNER_PERC" = perc.winner, "PRES" = pres))
  })
  
  ### COLORS ----
  CLEAN.regColors <- reactive({
    
    CLEAN_colors <- p.kolors[CLEAN.regData()[["CLEAN_df"]] %>% 
                               na.omit() %>% 
                               arrange(ABS_RANK) %>% 
                               distinct(LISTA) %>% 
                               pull()]
    return(CLEAN_colors)
  }) 
  
  ### PLOT PARAMS----
  reg.picSize <- reactive({ifelse(input$SHOW_ALL_REG, 0.12, 0.15)}) 
  reg.xStart <- reactive({ifelse(input$SHOW_ALL_REG, -0.08, -0.1)})
  reg.yStart <- reactive({ifelse(input$SHOW_ALL_REG, 1.142, 1.17)})
  reg.M <- reactive({ifelse(input$SHOW_ALL_REG, 140, 150)})
  
  
  ### PLOT ----
  output$regPlot <- renderPlotly({
    if (input$TIPO_VIZ_REG == "Voti ottenuti") {
      
      plot_ly(CLEAN.regData()[["CLEAN_df"]], y = ~LISTA, x = ~LOCALE,
              type = 'bar', name = 'Voti ottenuti', 
              hovertext = ~paste0('<b>', LISTA, '</b> <br>Voti ottenuti a Vanzaghello: ', formatC(LOCALE, big.mark = ".", decimal.mark = ",")),
              hoverinfo="text",
              marker = list(color=CLEAN.regColors())) %>% 
        
        layout(yaxis=list(categoryorder='array', categoryarray=rev(names(CLEAN.regColors())),  
                          title='', showticklabels=FALSE),
               xaxis=list(title='', tickfont=list(size=15)), 
               showlegend=FALSE, 
               margin = list(l = reg.M()),
               images= logos.positioner(
                 CLEAN.regData()[["CLEAN_df"]], 
                 pic_size=reg.picSize(), 
                 xstart=reg.xStart(), ystart=reg.yStart()))
      
    } else {
      
      plot_ly(CLEAN.regData()[["CLEAN_df"]], y = ~LISTA, x = ~REGIONALE,
              type = 'bar', name = 'VOTI NAZIONALE', 
              hovertext = ~paste0('<b>', LISTA, '</b> <br> RISULTATI LOMBARDIA: ', formatC(REGIONALE, big.mark=".", decimal.mark=","), '%'),
              hoverinfo="text",
              marker = list(color=sapply(CLEAN.regColors(), alpha.func, '64'))) %>% 
        
        add_trace(x = ~LOCALE, name="VOTI", 
                  hovertext = ~paste0('<b>', LISTA, '</b> <br> RISULTATI VANZAGHELLO: ', formatC(LOCALE, big.mark=".", decimal.mark=","), '%'),
                  hoverinfo = 'text',
                  marker = list(color=CLEAN.regColors())) %>% 
        
        layout(yaxis=list(categoryorder='array', categoryarray=rev(names(CLEAN.regColors())),  
                          title='', showticklabels=FALSE),
               xaxis=list(ticksuffix = "%", title='', tickfont=list(size=15)), 
               showlegend=FALSE, 
               margin = list(l = reg.M()),
               images= logos.positioner(
                 CLEAN.regData()[["CLEAN_df"]], 
                 pic_size=reg.picSize(), 
                 xstart=reg.xStart(), ystart=reg.yStart()))
      
    }
  })
  
  ### TEXT----
  output$regTitle <- renderText({paste("Top 5 liste più votate a Vanzaghello alle elezioni regionali del", input$ANNO_REG)})
  
  output$regResume_pt1 <- renderText({paste0(
    "Alle elezioni regionali del ", input$ANNO_REG, ", ",
    TXT.regData()[["WINNER_NAME"]],
    " è risultato il partito più votato a Vanzaghello, con il ", 
    formatC(TXT.regData()[["WINNER_PERC"]], decimal.mark=",", big.mark="."),
    "% delle preferenze validamente espresse. ", TXT.regData()[["PRES"]]
  )}) 
  
  output$regResume_pt2 <- renderText({paste0(
    "Su un totale di ", formatC(CLEAN.regData()[["TXT_df"]][CLEAN.regData()[["TXT_df"]]$LISTA == "ELETTORI", "LOCALE"], big.mark=".", decimal.mark = ","), 
    " aventi diritto, i votanti sono stati ", formatC(CLEAN.regData()[["TXT_df"]][CLEAN.regData()[["TXT_df"]]$LISTA == "VOTANTI", "LOCALE"], big.mark=".", decimal.mark = ","), 
    ", con ", formatC(
      CLEAN.regData()[["TXT_df"]][CLEAN.regData()[["TXT_df"]]$LISTA == "VOTANTI", "LOCALE"] 
      - CLEAN.regData()[["TXT_df"]][CLEAN.regData()[["TXT_df"]]$LISTA == "BIANCHE", "LOCALE"]
      - CLEAN.regData()[["TXT_df"]][CLEAN.regData()[["TXT_df"]]$LISTA == "NULLE", "LOCALE"],
      big.mark=".", decimal.mark = ","), " voti validi, ",
    formatC(CLEAN.regData()[["TXT_df"]][CLEAN.regData()[["TXT_df"]]$LISTA == "BIANCHE", "LOCALE"], big.mark=".", decimal.mark = ","), 
    " schede bianche e ", 
    formatC(CLEAN.regData()[["TXT_df"]][CLEAN.regData()[["TXT_df"]]$LISTA == "NULLE", "LOCALE"], big.mark=".", decimal.mark = ","), 
    " schede nulle.\n", 
    formatC(CLEAN.regData()[["TXT_df"]][CLEAN.regData()[["TXT_df"]]$LISTA == "ASTENUTI", "LOCALE"], big.mark=".", decimal.mark = ","), 
    " cittadini si sono astenuti, determinando un'affluenza pari a ",
    formatC(
      CLEAN.regData()[["TXT_df"]][CLEAN.regData()[["TXT_df"]]$LISTA == "VOTANTI", "LOCALE"] * 100 / CLEAN.regData()[["TXT_df"]][CLEAN.regData()[["TXT_df"]]$LISTA == "ELETTORI", "LOCALE"],
      big.mark=".", decimal.mark = ","), "%."
    
  )})
  
  # PARTITI----
  ### DATA----
  CLEAN.partData <- reactive({
    if (input$N_PARTITI == 1) {
      filter(part.dta, LISTA == input$PARTITO)
    } else {
      filter(part.dta, LISTA %in% input$PARTITI)
    }
  })
  
  ### PLOT PARAMS----
  part.metric <- reactive({metric.map[[input$TIPO_VIZ_PART]]})
  
  ### PLOT----
  output$partPlot <- renderPlotly({
    ##### SINGLE PARTY - SINGLE LINE----
    if(input$N_PARTITI == 1 & input$SHOW_ALL_PART == FALSE) { 
        fig <- plot_ly(CLEAN.partData(), x=~ANNO, y=~PERC_VAL, type="scatter",  mode = 'lines+markers',
                       hovertext = ~paste0('<b>', LISTA, '</b> (', ANNO, ') <br> Percentuale (su voti validi): ', formatC(PERC_VAL, big.mark = ".", decimal.mark = ","), '%'),
                       hoverinfo="text", 
                       line=list(color=p.kolors[[input$PARTITO]]), marker=list(color=p.kolors[[input$PARTITO]], size=15, symbol="diamond")) %>% 
        layout(yaxis=list(zeroline = FALSE, ticksuffix = "%", title='', tickfont=list(size=15), showline= T, linewidth=2, linecolor='black'),
               xaxis=list(zeroline = FALSE, title="", tickvals=CLEAN.partData()$ANNO, tickfont=list(size=15), showline= T, linewidth=2, linecolor='black'),
               showlegend=FALSE)
    ##### SINGLE PARTY - DOUBLE LINE----
    } else if (input$N_PARTITI == 1 & input$SHOW_ALL_PART == TRUE) {
      fig <- plot_ly(CLEAN.partData(), x=~ANNO, y=~PERC_VAL, type="scatter",  mode = 'lines+markers',
                     hovertext = ~paste0('<b>', LISTA, '</b> (', ANNO, ') <br> Percentuale (su voti validi): ', formatC(PERC_VAL, big.mark = ".", decimal.mark = ","), '%'),
                     hoverinfo="text", 
                     line=list(color=p.kolors[[input$PARTITO]]), marker=list(color=p.kolors[[input$PARTITO]], size=15, symbol="diamond")) %>% 
        add_trace(y = ~PERC_ASS, mode = 'lines+markers', 
                  hovertext = ~paste0('<b>', LISTA, '</b> (', ANNO, ') <br> Percentuale (su aventi diritto): ', formatC(PERC_ASS, big.mark = ".", decimal.mark = ","), '%'),
                  hoverinfo="text", 
                  line=list(color=paste0(p.kolors[[input$PARTITO]], "64")), marker=list(color=paste0(p.kolors[[input$PARTITO]], "64"), size=15, symbol="square")) %>% 
        layout(yaxis=list(zeroline=FALSE, ticksuffix = "%", title='', tickfont=list(size=15), showline= T, linewidth=2, linecolor='black'),
               xaxis=list(zeroline=FALSE, title="", tickvals=CLEAN.partData()$ANNO, tickfont=list(size=15), showline= T, linewidth=2, linecolor='black'),
               showlegend=FALSE)
    ##### MULTI PARTY - ASSOLUTO----
    } else if (input$N_PARTITI == 2 & input$TIPO_VIZ_PART == "Voti ottenuti") {
      fig <- plot_ly(type="scatter", mode = 'lines+markers')
      
      for (part in input$PARTITI) {
        tmp.df <- filter(CLEAN.partData(), LISTA == part)
        c <- p.kolors[[part]]
        n <- ifelse(
          max(tmp.df$ANNO) == min(tmp.df$ANNO),
          paste0(part, ' (', max(tmp.df$ANNO), ')'),
          paste0(part, ' (', min(tmp.df$ANNO), '-', max(tmp.df$ANNO), ')')
        )
        
        fig <- fig %>% 
          add_trace(data=tmp.df, x=~ANNO, y = ~VOTI_OTTENUTI, mode = 'lines+markers', 
                    hovertext = ~paste0('<b>', LISTA, '</b> (', ANNO, ') <br> Voti ottenuti: ', formatC(VOTI_OTTENUTI, big.mark = ".", decimal.mark = ",")),
                    hoverinfo="text", name = n,
                    line=list(color=c), marker=list(color=c, size=15, symbol="diamond"))
      }
      
      fig <- fig %>% 
        layout(yaxis=list(zeroline = FALSE, title='', tickfont=list(size=15), showline= T, linewidth=2, linecolor='black'),
               xaxis=list(zeroline = FALSE, title="", tickvals=CLEAN.partData()$ANNO, tickfont=list(size=15), showline= T, linewidth=2, linecolor='black'),
               showlegend=TRUE)
    ##### MULTIPARTY (PERCENTUALE VALIDI)----
    } else if (input$N_PARTITI == 2 & input$TIPO_VIZ_PART == "Percentuale (su voti validi)") {
      fig <- plot_ly(type="scatter", mode = 'lines+markers')

      for (part in input$PARTITI) {
        tmp.df <- filter(CLEAN.partData(), LISTA == part)
        c <- p.kolors[[part]]
        n <- ifelse(
          max(tmp.df$ANNO) == min(tmp.df$ANNO),
          paste0(part, ' (', max(tmp.df$ANNO), ')'),
          paste0(part, ' (', min(tmp.df$ANNO), '-', max(tmp.df$ANNO), ')')
        )

        fig <- fig %>%
          add_trace(data=tmp.df, x=~ANNO, y = ~PERC_VAL, mode = 'lines+markers',
                    hovertext = ~paste0('<b>', LISTA, '</b> (', ANNO, ') <br> Percentuale (su voti validi): ', formatC(PERC_VAL, big.mark = ".", decimal.mark = ","), '%'),
                    hoverinfo="text", name= n,
                    line=list(color=c), marker=list(color=c, size=15, symbol="diamond"))
      }

      fig <- fig %>%
        layout(yaxis=list(zeroline = FALSE, ticksuffix = "%", title='', tickfont=list(size=15), showline= T, linewidth=2, linecolor='black'),
               xaxis=list(zeroline = FALSE, title="", tickvals=CLEAN.partData()$ANNO, tickfont=list(size=15), showline= T, linewidth=2, linecolor='black'),
               showlegend=TRUE)
    ##### MULTIPARTY (PERCENTUALE ASSOLUTA)----
    } else if (input$N_PARTITI == 2 & input$TIPO_VIZ_PART == "Percentuale (su aventi diritto)") {
      fig <- plot_ly(type="scatter", mode = 'lines+markers')

      for (part in input$PARTITI) {
        tmp.df <- filter(CLEAN.partData(), LISTA == part)
        c <- p.kolors[[part]]
        n <- ifelse(
          max(tmp.df$ANNO) == min(tmp.df$ANNO),
          paste0(part, ' (', max(tmp.df$ANNO), ')'),
          paste0(part, ' (', min(tmp.df$ANNO), '-', max(tmp.df$ANNO), ')')
        )

        fig <- fig %>%
          add_trace(data=tmp.df, x=~ANNO, y = ~PERC_ASS, mode = 'lines+markers',
                    hovertext = ~paste0('<b>', LISTA, '</b> (', ANNO, ') <br> Percentuale (su voti aventi diritto): ', formatC(PERC_ASS, big.mark = ".", decimal.mark = ","), '%'),
                    hoverinfo="text", name= n,
                    line=list(color=c), marker=list(color=c, size=15, symbol="diamond"))
      }

      fig <- fig %>%
        layout(yaxis=list(zeroline = FALSE, ticksuffix = "%", title='', tickfont=list(size=15), showline= T, linewidth=2, linecolor='black'),
               xaxis=list(zeroline = FALSE, title="", tickvals=CLEAN.partData()$ANNO, tickfont=list(size=15), showline= T, linewidth=2, linecolor='black'),
               showlegend=TRUE)
    }
    
    return(fig)
  })
  
  ### TEXT----
  output$partTitle <- renderText({paste("Andamento del consenso", ifelse(input$N_PARTITI == 1, "del partito selezionato", "dei partiti selezionati"), "nel comune di Vanzaghello (elezioni politiche nazionali)")})
}

# RUN ----
shinyApp(ui, server)
