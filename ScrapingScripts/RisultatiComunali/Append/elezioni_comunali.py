# Lib import
### import generiche
import pandas as pd
import numpy as np
import re 
import random
import time
### beautiful soup, per gestione HTML
from bs4 import BeautifulSoup as bs
### moduli selenium, per creazione pagina automatizzata Chrome
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.select import Select
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.service import Service

# Define variables
### Dates to be process
DATES_TO_PROCESS=[
    "09/06/2024"
]
### Small dict to translate from numbers to month
NUMBERS_TO_MONTH = {
    "01" : "gennaio", 
    "02" : "febbraio",
    "03" : "marzo", 
    "04" : "aprile", 
    "05" : "maggio", 
    "06" : "giugno",
    "07" : "luglio",
    "08" : "agosto",
    "09" : "settembre", 
    "10" : "ottobre", 
    "11" : "novembre",
    "12" : "dicembre"
}
### Small dict for LBL_TIPO_METRICA
METRICS_DESCR = {
    "VOTI_OTTENUTI" : "Voti ottenuti",
    "PERC_VAL" : "Percentuale (su voti validi)", 
    "PERC_ASS" : "Percentuale (su aventi diritto)"   
}
### Path dell'output a cui andremo ad appendere questo risultato
EXISTING_OUTPUT_PATH="ScrapingScripts/RawOutput/RisultatiComunali/COMUNALI.csv"
### Path dove andremo a scrivere il nuovo output
NEW_OUTPUT_PATH="ScrapingScripts/RawOutput/RisultatiComunali/COMUNALI.csv"

# Selenium init
URL = 'https://elezionistorico.interno.gov.it/index.php?tpel=G'
driver_ = webdriver.Chrome(
    service=Service(ChromeDriverManager().install()) # parametro attualmente non utilizzabile perchè le versioni del chromedriver attualmente scaricabili non sono aggiornate
    )
driver_.get(URL)
wait = WebDriverWait(driver_, 5)
time.sleep(2)

df_lst = []
# Ciclo sulle date
for d in DATES_TO_PROCESS: 
    print(f"Eseguo lo script per le elezioni del {d}")
    #######################
    ### Identifico anno ###
    #######################
    anno = wait.until(EC.presence_of_element_located((By.ID, 'sel_date')))
    anno = Select(anno)
    anno.select_by_visible_text(d)
    time.sleep(1 + random.random())

    #######################
    ### Identifico area ###
    #######################
    area = wait.until(EC.presence_of_element_located((By.ID, 'sel_aree')))
    area = Select(area)
    area.select_by_visible_text("ITALIA")
    time.sleep(1 + random.random())

    ##########################
    ### Identifico regione ###
    ##########################
    reg = wait.until(EC.presence_of_element_located((By.ID, 'sel_sezione2')))
    reg = Select(reg)
    reg.select_by_visible_text("LOMBARDIA")
    time.sleep(1 + random.random())

    ############################
    ### Identifico provincia ###
    ############################
    prov = wait.until(EC.presence_of_element_located((By.ID, 'sel_sezione3')))
    prov = Select(prov)
    prov.select_by_visible_text("MILANO")
    time.sleep(1 + random.random())

    #########################
    ### Identifico comune ###
    #########################
    com = wait.until(EC.presence_of_element_located((By.ID, 'sel_sezione4')))
    com = Select(com)
    com.select_by_visible_text("VANZAGHELLO")
    time.sleep(1 + random.random())

    soup = bs(driver_.page_source, 'html.parser')

    ####################################
    ### Web scraping (tab riepilogo) ###
    ####################################
    ts = soup.find_all("table", attrs={"class": "dati_riepilogo"})
    # Votanti & Elettori 
    t = ts[0]
    body = t.find_all('tr')
    body_rows = body[1:]
    elettori = int(re.sub("(\xa0)|(\n)|,","",body_rows[0].find_all('td')[0].text).replace('.', ''))
    votanti = int(re.sub("(\xa0)|(\n)|,","",body_rows[1].find_all('td')[0].text).replace('.', ''))
    # Bianche & Nulle
    t = ts[1]
    body = t.find_all('tr')
    body_rows = body[1:]
    bianche = int(re.sub("(\xa0)|(\n)|,","",body_rows[0].find_all('td')[0].text).replace('.', ''))
    nulle = int(re.sub("(\xa0)|(\n)|,","",body_rows[1].find_all('td')[0].text).replace('.', '')) - bianche

    ####################################
    ### Web scraping (tab risultati) ###
    ####################################
    t = soup.find_all("table", attrs={"class": "dati table-striped"})[0]
    body = t.find_all('tr')
    #header
    head = body[0]
    #rows
    body_rows = body[1:]
    #Lista in cui raccoglieremo gli header
    headings = []
    #Colleziono gli header e li appendo
    for item in head.find_all('th'): 
        item = (item.text).rstrip('\n')
        headings.append(item)

    #Lista in cui raccoglieremo le righe
    all_rows = []
    #Per ciascuna riga: 
    # -2 per togliere le ultime 2 righe (conteggi totali che non ci servono)
    for row_num in range(len(body_rows) - 2): 
        #Lista in cui raccoglieremo gli elementi della riga
        row = []
        for row_item in body_rows[row_num].find_all('td'): 
            # Per ciascun elemento della riga, se è un'immagine raccogli solo la caption (alt field)
            if row_item.find('img'): 
                aa = row_item.text[:2] + row_item.find('img')['alt'] + row_item.text[2:]
                row.append(aa)
            elif not row_item.text: 
                row.append('0')
            else: 
                #Altrimenti prendi il testo
                aa = re.sub("(\xa0)|(\n)|,","",row_item.text)
                row.append(aa)
        all_rows.append(row)

    # Nome dei candidati (su righe pari)
    candidati = [all_rows[i][0].strip() for i in range(len(all_rows)) if i % 2 == 0]
    # Nome delle liste a sostegno dei candidati (su righe dispari)
    liste = [all_rows[i][0].strip() for i in range(len(all_rows)) if i % 2 != 0]
    # Voti presi da ogni lista
    voti_lista = [int(all_rows[i][4].strip().replace(".", "")) for i in range(len(all_rows)) if i % 2 != 0]

    # creo df finale
    df = pd.DataFrame({
        "TIPO_ELEZIONI" : "COMUNALI", 
        "ANNO" : d.split("/")[-1],
        "MESE" : NUMBERS_TO_MONTH[d.split("/")[-2]],
        "GIORNO" : d.split("/")[0],
        "CANDIDATO" : candidati + ["ASTENUTI", "NULLE", "BIANCHE"],
        "CANDIDATO_LISTA" : [cand + "\n" + l for (cand, l) in zip(candidati, liste)] + ["ASTENUTI", "NULLE", "BIANCHE"],
        "VOTI_OTTENUTI" : voti_lista + [elettori - votanti, nulle, bianche]
    })
    # percentuale su voti validi
    df["PERC_VAL"] = (df["VOTI_OTTENUTI"] / (votanti - nulle - bianche) * 100).round(2)
    # percentuale su aventi diritto
    df["PERC_ASS"] = (df["VOTI_OTTENUTI"] / (elettori) * 100).round(2)
    # abs rank
    df.sort_values("VOTI_OTTENUTI", ascending=False, inplace=True)
    df["ABS_RANK"] = range(1, df.shape[0]+1)
    
    # pivot
    final = pd.melt(df, value_vars=["VOTI_OTTENUTI", "PERC_VAL", "PERC_ASS"], 
        var_name="TIPO_METRICA", id_vars=df.columns[:6].to_list() + ["ABS_RANK"], value_name="VOTI")\
        .sort_values("ABS_RANK")
    # Aggiungo colonna con pretty name
    final["LBL_TIPO_METRICA"] = final.TIPO_METRICA.apply(lambda x: METRICS_DESCR[x])
    # Sbianchetto righe che non devono esistere
    final.loc[(final.CANDIDATO_LISTA == "ASTENUTI") & (final.TIPO_METRICA == "PERC_VAL"), "VOTI"] = None
    final.loc[(final.CANDIDATO_LISTA == "BIANCHE") & (final.TIPO_METRICA == "PERC_VAL"), "VOTI"] = None
    final.loc[(final.CANDIDATO_LISTA == "NULLE") & (final.TIPO_METRICA == "PERC_VAL"), "VOTI"] = None
    # Le droppo
    final.dropna(inplace=True)
    
    # Salvo il risultato finale nella lista
    df_lst.append(final)
    
partial_output = pd.concat(df_lst)

existing_output = pd.read_csv(EXISTING_OUTPUT_PATH)

out_to_write = pd.concat([existing_output, partial_output])

out_to_write.to_csv(NEW_OUTPUT_PATH, index=False)