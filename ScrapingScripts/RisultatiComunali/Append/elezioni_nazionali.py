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
from selenium.common.exceptions import NoSuchElementException

# Define variables
### Dates to be process
DATES_TO_PROCESS=[
    "25/09/2022"
]
### Small dict for LBL_TIPO_METRICA
METRICS_DESCR = {
    "VOTI_OTTENUTI" : "Voti ottenuti",
    "PERC_VAL" : "Percentuale (su voti validi)", 
    "PERC_ASS" : "Percentuale (su aventi diritto)"   
}
### Path dell'output a cui andremo ad appendere questo risultato
EXISTING_OUTPUT_PATH="ScrapingScripts/RawOutput/RisultatiComunali/NAZIONALI.csv"
### Path dove andremo a scrivere il nuovo output
NEW_OUTPUT_PATH="ScrapingScripts/RawOutput/RisultatiComunali/NAZIONALI.csv"

# Selenium init
URL = 'https://elezionistorico.interno.gov.it/index.php?tpel=C'
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
    # Seleziono un anno
    anno = wait.until(EC.presence_of_element_located((By.ID, 'sel_date')))
    anno = Select(anno)
    anno.select_by_visible_text(d)
    time.sleep(1 + random.random())

    # Inizializzo i valori corretti per il filtraggio della pagina
    year = int(d.split("/")[-1])
    # Primo livello di selezione
    first_lvl_value = "ITALIA" if year < 2006 else "ITALIA (escl. Valle d'Aosta)"
    # Secondo livello di selezione
    second_lvl_value = "Milano-Pavia" if year == 1948 else "LOMBARDIA 1" if year > 1992 else "MILANO-PAVIA"
    # Terzo livello di selezione
    if year in (1994, 1996, 2001): 
        third_lvl_value = "Busto Garolfo"
    elif year < 2018: 
        third_lvl_value = "MILANO"
    elif year == 2018:
        third_lvl_value = "LOMBARDIA 1 - 04"
    elif year == 2022:
        third_lvl_value = "LOMBARDIA 1 - P01"
    # Quarto livello di selezione
    if year <= 1968: 
        fourth_lvl_value = "MAGNAGO"
    elif year == 2018: 
        fourth_lvl_value = "01 - ABBIATEGRASSO"
    elif year == 2022: 
        fourth_lvl_value = "LOMBARDIA 1 - U05 (LEGNANO)"
    else: 
        fourth_lvl_value = "VANZAGHELLO"
    # Quinto livello di selezione (solo per 2018 e 2022)
    fifth_lvl_value = "VANZAGHELLO"
    column_index = 1 if year < 2006 else 4

    # Filtro la pagina
    if year not in (2018, 2022): 
        # Primo livello
        first_filter = wait.until(EC.presence_of_element_located((By.ID, 'sel_aree')))
        first_filter = Select(first_filter)
        first_filter.select_by_visible_text(first_lvl_value)
        time.sleep(1 + random.random())
        # Secondo livello
        second_filter = wait.until(EC.presence_of_element_located((By.ID, 'sel_sezione2')))
        second_filter = Select(second_filter)
        second_filter.select_by_visible_text(second_lvl_value)
        time.sleep(1 + random.random())
        # Terzo livello
        third_filter = wait.until(EC.presence_of_element_located((By.ID, 'sel_sezione3')))
        third_filter = Select(third_filter)
        third_filter.select_by_visible_text(third_lvl_value)
        time.sleep(1 + random.random())
        # Quarto livello
        fourth_filter = wait.until(EC.presence_of_element_located((By.ID, 'sel_sezione4')))
        fourth_filter = Select(fourth_filter)
        fourth_filter.select_by_visible_text(fourth_lvl_value)
        time.sleep(1 + random.random())
    else: 
        # Primo livello
        first_filter = wait.until(EC.presence_of_element_located((By.ID, 'sel_aree')))
        first_filter = Select(first_filter)
        first_filter.select_by_visible_text(first_lvl_value)
        time.sleep(1 + random.random())
        # Secondo livello
        second_filter = wait.until(EC.presence_of_element_located((By.ID, 'sel_sezione2')))
        second_filter = Select(second_filter)
        second_filter.select_by_visible_text(second_lvl_value)
        time.sleep(1 + random.random())
        # Terzo livello
        third_filter = wait.until(EC.presence_of_element_located((By.ID, 'sel_sezione3')))
        third_filter = Select(third_filter)
        third_filter.select_by_visible_text(third_lvl_value)
        time.sleep(1 + random.random())
        # Quarto livello
        fourth_filter = wait.until(EC.presence_of_element_located((By.ID, 'sel_sezione4')))
        fourth_filter = Select(fourth_filter)
        fourth_filter.select_by_visible_text(fourth_lvl_value)
        time.sleep(1 + random.random())
        # Quinto livello
        fifth_filter = wait.until(EC.presence_of_element_located((By.ID, 'sel_sezione5')))
        fifth_filter = Select(fifth_filter)
        fifth_filter.select_by_visible_text(fifth_lvl_value)
        time.sleep(1 + random.random())
    
    # creo oggetto beautifulsoup
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
    # -1 per togliere ultima riga (conteggi totali che non ci servono)
    for row_num in range(len(body_rows) - 1): 
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

    # Nome delle liste 
    liste = [all_rows[i][0].strip() for i in range(len(all_rows))]
    # Voti presi da ogni lista
    voti_lista = [int(all_rows[i][column_index].strip().replace(".", "")) for i in range(len(all_rows))]

    # creo df finale
    df = pd.DataFrame({
        "TIPO_ELEZIONI" : "NAZIONALI", 
        "ANNO" : d.split("/")[-1],
        "LISTA" : liste + ["ASTENUTI", "NULLE", "BIANCHE", "ELETTORI", "VOTANTI"],
        "VOTI_OTTENUTI" : voti_lista + [elettori - votanti, nulle, bianche, elettori, votanti]
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
        var_name="TIPO_METRICA", id_vars=df.columns[:3].to_list() + ["ABS_RANK"], value_name="VOTI")\
        .sort_values("ABS_RANK")
    # Aggiungo colonna con pretty name
    final["LBL_TIPO_METRICA"] = final.TIPO_METRICA.apply(lambda x: METRICS_DESCR[x])
    # Sbianchetto righe che non devono esistere
    final.loc[(final.LISTA == "ASTENUTI") & (final.TIPO_METRICA == "PERC_VAL"), "VOTI"] = None
    final.loc[(final.LISTA == "BIANCHE") & (final.TIPO_METRICA == "PERC_VAL"), "VOTI"] = None
    final.loc[(final.LISTA == "NULLE") & (final.TIPO_METRICA == "PERC_VAL"), "VOTI"] = None
    final.loc[(final.LISTA == "ELETTORI") & (final.TIPO_METRICA == "PERC_VAL"), "VOTI"] = None
    final.loc[(final.LISTA == "VOTANTI") & (final.TIPO_METRICA == "PERC_VAL"), "VOTI"] = None
    # Colonna FLG
    final["FLG_NOT_VALID"] = final.LISTA.isin(("ASTENUTI", "NULLE", "BIANCHE", "ELETTORI", "VOTANTI")).astype(int)

    # Salvo il risultato finale nella lista
    df_lst.append(final)
    
partial_output = pd.concat(df_lst)

existing_output = pd.read_csv(EXISTING_OUTPUT_PATH)

out_to_write = pd.concat([existing_output, partial_output])

out_to_write.to_csv(NEW_OUTPUT_PATH, index=False)