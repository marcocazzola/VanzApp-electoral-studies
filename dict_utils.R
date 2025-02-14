# Colori elezioni comunali----
com.kolors <- c("ASTENUTI" = "#343434",
                "BIANCHE" = "#d5d5d5",
                "NULLE" = "#a2a2a2",
                "DONATI GILBERTO\n(CENTRO)" = "#0a7efa", 
                "DONATI GILBERTO\n(LISTA CIVICA)" = "#0a7efa", 
                "ROMANO' MARCO\n(L.NORD-CIVICHE)" = "#008000", 
                "VITALI MAURIZIO\n(SINISTRA)" = "#fe161d",
                "TURCO ANTONIO\n(LISTA CIVICA)" = "#be2ed6",
                "GUALDONI GIAN BATTISTA\n(LISTA CIVICA)" = "#fe161d",
                "VITALI TERESA\n(LISTA CIVICA)" = "#be2ed6",
                "GIUDICI ANGELA\n(CEN-DES)" = "#0a7efa",
                "GARASCIA EMILIO MARIO\n(IL POPOLO DELLA LIBERTA')" = "#0a7efa",
                "RUDONI ALESSIO\n(LEGA NORD)" = "#008000",
                "VITALI TERESA\n(TERESA VITALI SINDACO)" = "#be2ed6",
                "GIANI LEOPOLDO ANGELO\n(INSIEME PER VANZAGHELLO)" = "#fe161d",
                "VALLI ELENA\n(L.NORD-BASTA EURO-CIVICA)" = "#008000",
                "GATTI ARCONTE\n(LEGA SALVINI <br> RIACCENDIAMO VANZAGHELLO)" = "#0a7efa",
                "GUALDONI GIAN BATTISTA\n(INSIEME PER VANZAGHELLO)" = "#fe161d",
                "GATTI ARCONTE\n(CENTRODESTRA UNITO <br> RIACCENDIAMO VANZAGHELLO)" = "#0a7efa",
                "GIANI RINO\n(INSIEME PER VANZAGHELLO)" = "#fe161d")

# Colori partiti nazionali e regionali----
p.kolors <- c("FR.DEMOCR.POPOLARE" = "#d01318", 
              "DC" = "#0a7efa", 
              "ASTENUTI" = "#000000",
              "BIANCHE" = "#d5d5d5",
              "NULLE" = "#a2a2a2",
              "UNITA' SOCIALISTA" = "#fe161d", 
              "PC.INTERNAZIONALISTA" = "#54070a", 
              "P.CONTADINI D'ITALIA" = "#008000", 
              "PSI" = "#fe161d",
              "PCI" = "#d01318",
              "PSDI" = "#ed2339",
              "MSI" = "#000080",
              "PLI" = "#4cc9f0",
              "PSU" = "#ed2339",
              "PSIUP" = "#fe161d",
              "DEM.PROL" = "#54070a",
              "P.RAD" = "#be2ed6",
              "PRI" = "#4cc9f0",
              "LEGA LOMBARDA" = "#008000",
              "LISTA VERDE" = "#355e3b",
              "PDS" = "#d01318",
              "P.S.I." = "#fe161d",
              "FEDERAZIONE DEI VERDI" = "#355e3b",
              "LEGA NORD" = "#008000",
              "FORZA ITALIA" = "#4cc9f0",
              "P.POPOLARE ITALIANO" = "#0a7efa",
              "PATTO SEGNI" = "#000080",
              "POPOLARI PER PRODI" = "#0a7efa",
              "ALLEANZA NAZIONALE" = "#000080",
              "LA MARGHERITA" = "#fe161d",
              "DEMOCRATICI SINISTRA" = "#d01318",
              "L'ULIVO" = "#fe161d",
              "UNIONE DI CENTRO" = "#0a7efa",
              "IL POPOLO DELLA LIBERTA'" = "#4cc9f0",
              "PARTITO DEMOCRATICO" = "#fe161d",
              "DI PIETRO ITALIA DEI VALORI" = "#be2ed6",
              "SCELTA CIVICA" = "#000080",
              "LEGA" = "#0a7efa",
              "MOVIMENTO 5 STELLE" = "#ffb32b",
              "FRATELLI D'ITALIA" = "#000080",
              "AZIONE - ITALIA VIVA" = "#be2ed6",
              "PLI-PRI" = "#4cc9f0",
              "RIFONDAZIONE COMUNISTA" = "#54070a",
              "I DEMOCRATICI" = "#0a7efa",
              "LISTA EMMA BONINO" = "#be2ed6",
              "NUOVO CENTRO DESTRA - UDC" = "#0a7efa",
              "P.S.U." = "#ed2339",
              "MARTINAZZOLI CEN-SIN" =  "#fe161d",
              "MARONI PRESIDENTE" = "#0a7efa", 
              "LETIZIA MORATTI PRESIDENTE" = "#be2ed6",
              "FONTANA PRESIDENTE" = "#008000")

#Colori per referendum----
ref.kolors <- c("ASTENUTI" = "#343434",
                "BIANCHE" = "#d5d5d5",
                "NULLE" = "#a2a2a2",
                "SI" = "#377eb8",
                "NO" = "#e4211c",
                "REPUBBLICA" = "#377eb8",
                "MONARCHIA" = "#e4211c")

# Loghi partiti politici----
logos <- c("FR.DEMOCR.POPOLARE" = "www/fronte popolare.png", 
           "DC" = "www/dc.png",
           "ASTENUTI" = "www/astenuti.png",
           "UNITA' SOCIALISTA" = "www/unita socialista.png", 
           "PC.INTERNAZIONALISTA" = "www/pc_internazionalista.png",
           "P.CONTADINI D'ITALIA" = "www/partito contadini.png",
           "PSI" = "www/psi_old.png",
           "PCI" = "www/pci_old.png",
           "PSDI" = "www/psdi.png",
           "MSI" = "www/msi.png",
           "PLI" = "www/pli.png",
           "PSU" = "www/psu.png",
           "PSIUP" = "www/psiup.png",
           "DEM.PROL" = "www/democrazia proletaria.png",
           "P.RAD" = "www/partito radicale.png",
           "PRI" = "www/pri.png",
           "LEGA LOMBARDA" = "www/lega lombarda.png",
           "LISTA VERDE" = "www/lista verde.png",
           "PDS" = "www/pds.png",
           "P.S.I." = "www/psi_new.png",
           "FEDERAZIONE DEI VERDI" = "www/federazione verdi.png",
           "LEGA NORD" = "www/lega nord.png",
           "FORZA ITALIA" = "www/forza italia.png",
           "P.POPOLARE ITALIANO" = "www/ppi.png",
           "PATTO SEGNI" = "www/patto segni.png",
           "POPOLARI PER PRODI" = "www/prodi.png",
           "ALLEANZA NAZIONALE" = "www/alleanza nazionale.png",
           "LA MARGHERITA" = "www/margherita.png",
           "DEMOCRATICI SINISTRA" = "www/democratici di sx.png",
           "L'ULIVO" = "www/ulivo.png",
           "UNIONE DI CENTRO" = "www/udc.png",
           "IL POPOLO DELLA LIBERTA'" = "www/pdl.png",
           "PARTITO DEMOCRATICO" = "www/pd.png",
           "DI PIETRO ITALIA DEI VALORI" = "www/italia dei valori.png",
           "SCELTA CIVICA" = "www/scelta civica.png",
           "LEGA" = "www/lega.png",
           "MOVIMENTO 5 STELLE" = "www/m5s.png",
           "FRATELLI D'ITALIA" = "www/fratelli ditalia.png",
           "AZIONE - ITALIA VIVA" = "www/azione italia viva.png", 
           "PLI-PRI" = "www/pli-pri.png",
           "RIFONDAZIONE COMUNISTA" = "www/rifondazione comunista.png",
           "I DEMOCRATICI" = "www/i democratici.png", 
           "LISTA EMMA BONINO" = "www/lista bonino.png",
           "NUOVO CENTRO DESTRA - UDC" = "www/ndc.png",
           "P.S.U." = "www/unita socialista.png",
           "MARTINAZZOLI CEN-SIN" =  "www/martinazzoli.png",
           "MARONI PRESIDENTE" = "www/maroni presidente.png", 
           "LETIZIA MORATTI PRESIDENTE" = "www/moratti presidente.png",
           "FONTANA PRESIDENTE" = "www/fontana presidente.png") %>% 
  data.frame() %>% 
  rownames_to_column('LISTA') 
colnames(logos) <- c("LISTA", "IMG_DIR")