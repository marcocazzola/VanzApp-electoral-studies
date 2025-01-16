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

### Small dict for LBL_TIPO_METRICA
METRICS_DESCR = {
    "VOTI_OTTENUTI" : "Voti ottenuti",
    "PERC_VAL" : "Percentuale (su voti validi)", 
    "PERC_ASS" : "Percentuale (su aventi diritto)"   
}

# Define variables
### Dates to be process & numero del quesito di interesse
DATES_TO_PROCESS = [
    ("02/06/1946", 1), 
    ("12/05/1974", 1), 
    ("11/06/1978", 2), 
    ("17/05/1981", 2), 
    ("17/05/1981", 3), 
    ("17/05/1981", 5), 
    ("09/06/1985", 1), 
    ("21/06/2009", 3), 
    ("12/06/2011", 1), 
    ("12/06/2011", 3), 
    ("12/06/2011", 4), 
    ("04/12/2016", 1), 
    # ("20/09/2020", 1)
]

# Path dove andremo a scrivere il nuovo output
OUTPUT_PATH="ScrapingScripts/RawOutput/RisultatiNazionali/REFERENDUM.csv"
# URL di partenza
URL = 'https://elezionistorico.interno.gov.it/index.php?tpel=F'

# Initialize the webpage
driver_ = webdriver.Chrome(
    service=Service(ChromeDriverManager().install()) # parametro attualmente non utilizzabile perchè le versioni del chromedriver attualmente scaricabili non sono aggiornate
)
driver_.get(URL)
wait = WebDriverWait(driver_, 5)
time.sleep(2)

df_lst = []
# Ciclo sulle date
for d in DATES_TO_PROCESS: 
    print(f"Eseguo lo script per il referendum del {d[0]}, quesito numero {d[1]}", end="\r")
    # Variabile utile allo scraping 
    table_idx = d[1] - 1
    
    # Seleziono un anno
    anno = wait.until(EC.presence_of_element_located((By.ID, 'sel_date')))
    anno = Select(anno)
    anno.select_by_visible_text(d[0])
    time.sleep(1 + random.random())

    # Filtro la pagina
    first_filter = wait.until(EC.presence_of_element_located((By.ID, 'sel_aree')))
    first_filter = Select(first_filter)
    first_filter.select_by_visible_text('ITALIA')
    time.sleep(1 + random.random())

    # creo oggetto beautifulsoup
    soup = bs(driver_.page_source, 'html.parser')

    # Elettori (uguale se ci sono uno o più quesiti)
    elettori = soup.find_all('div', {'class' : 'row box_elevot'})[0]\
        .find_all('table', {'class' : 'dati_riepilogo'})[0]\
        .find_all('tr')[0]\
        .find_all('td')[0]\
        .text.replace('.', '')
    elettori = int(elettori)
    
    # Mi concentro sul singolo quesito
    mini_soup = soup.find('div', {'class' : 'center-panel'})\
        .find_all('div', {'class' : 'box_election'})[table_idx]
    
    # Summary quesito
    q = mini_soup\
        .find('div', {'class' : 'dati_referendum_titolo_quesito'})\
        .text
    
    # Votanti
    votanti = mini_soup.find_all('table', {'class' : 'dati_riepilogo'})[0]\
        .find_all('tr')[1]\
        .find_all('td')[0]\
        .text.replace('.', '')
    votanti = int(votanti)

    # Valide
    valide = mini_soup.find_all('table', {'class' : 'dati_riepilogo'})[1]\
        .find_all('tr')[1]\
        .find_all('td')[0]\
        .text.replace('.', '')
    valide = int(valide)

    # Bianche
    bianche = mini_soup.find_all('table', {'class' : 'dati_riepilogo'})[1]\
        .find_all('tr')[2]\
        .find_all('td')[0]\
        .text.replace('.', '')
    bianche = int(bianche)

    # Nulle
    nulle = mini_soup.find_all('table', {'class' : 'dati_riepilogo'})[1]\
        .find_all('tr')[3]\
        .find_all('td')[0]\
        .text.replace('.', '')
    try: 
        nulle = int(nulle) - bianche
    except ValueError: 
        nulle = votanti - valide - bianche

    # Risultati - Label Preferenze
    preferenze = mini_soup.find('table', {'class' : 'dati'})\
        .find_all('tr')[0]\
        .find_all('th')
    preferenze = [h.text for h in preferenze]

    # Risultati - Numero di voti
    voti = mini_soup.find('table', {'class' : 'dati'})\
        .find_all('tr')[1]\
        .find_all('td')
    voti = [int(v.text.replace('.', '')) for v in voti]


    df = pd.DataFrame({
        "TIPO_ELEZIONI" : "REFERENDUM", 
        "QUESITO" : q,
        "ANNO" : d[0].split("/")[-1],
        "PREFERENZA" : preferenze + ["ASTENUTI", "NULLE", "BIANCHE", "ELETTORI", "VOTANTI"],
        "VOTI_OTTENUTI" : voti + [elettori - votanti, nulle, bianche, elettori, votanti]
    })
    df["PREFERENZA"] = df.PREFERENZA.apply(lambda x: x.upper())
    # percentuale su voti validi
    df["PERC_VAL"] = (df["VOTI_OTTENUTI"] / (votanti - nulle - bianche) * 100).round(2)
    # percentuale su aventi diritto
    df["PERC_ASS"] = (df["VOTI_OTTENUTI"] / (elettori) * 100).round(2)
    # abs rank
    df.sort_values("VOTI_OTTENUTI", ascending=False, inplace=True)
    df["ABS_RANK"] = range(1, df.shape[0]+1)
        
    # pivot
    final = pd.melt(df, value_vars=["VOTI_OTTENUTI", "PERC_VAL", "PERC_ASS"], 
        var_name="TIPO_METRICA", id_vars=df.columns[:4].to_list() + ["ABS_RANK"], value_name="VOTI")\
        .sort_values("ABS_RANK")
    # Aggiungo colonna con pretty name
    final["LBL_TIPO_METRICA"] = final.TIPO_METRICA.apply(lambda x: METRICS_DESCR[x])
    # Sbianchetto righe che non devono esistere
    final.loc[(final.PREFERENZA == "ASTENUTI") & (final.TIPO_METRICA == "PERC_VAL"), "VOTI"] = None
    final.loc[(final.PREFERENZA == "BIANCHE") & (final.TIPO_METRICA == "PERC_VAL"), "VOTI"] = None
    final.loc[(final.PREFERENZA == "NULLE") & (final.TIPO_METRICA == "PERC_VAL"), "VOTI"] = None
    final.loc[(final.PREFERENZA == "ELETTORI") & (final.TIPO_METRICA == "PERC_VAL"), "VOTI"] = None
    final.loc[(final.PREFERENZA == "VOTANTI") & (final.TIPO_METRICA == "PERC_VAL"), "VOTI"] = None
    # Colonna FLG
    final["FLG_NOT_VALID"] = final.PREFERENZA.isin(("ASTENUTI", "NULLE", "BIANCHE", "ELETTORI", "VOTANTI")).astype(int)
    
    # Salvo il risultato finale nella lista
    df_lst.append(final)

out_to_write = pd.concat(df_lst)

out_to_write.to_csv(OUTPUT_PATH, index=False)