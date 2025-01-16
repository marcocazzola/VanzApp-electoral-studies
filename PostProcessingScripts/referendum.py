# Lib import
import pandas as pd

# Data import
df_new_naz = pd.read_csv("ScrapingScripts/RawOutput/RisultatiNazionali/REFERENDUM.csv")
df_new_com = pd.read_csv("ScrapingScripts/RawOutput/RisultatiComunali/REFERENDUM.csv")

# Dizionario relabelling quesito (1)
verbose_dict = {# ha chiamato i cittadini...
    "1. REFERENDUM SULLA FORMA ISTITUZIONALE DELLO STATO" : "a scegliere quale tra monarchia e repubblica dovesse essere la nuova forma istituzionale dello Stato.",
    "1. Divorzio" : "ad esprimersi sulla possibilità di abrogare la legge che introduceva il divorzio in Italia.",
    "2. Finanziamento pubblico dei partiti" : " ad esprimersi sull'abolizione del finanziamento pubblico ai partiti.",
    "2. Ergastolo" : "ad esprimersi sull'abolizione della pena dell'ergastolo",
    "3. Porto d'armi" : "ad esprimersi sull'abolizione delle norme sulla concessione di porto d'arma da fuoco.",
    "5. Interruzione gravidanza (Proposta Movimento per la vita)" : "ad esprimersi sulla possibilità di restringere i casi in cui l'aborto era consentito dalla legge.",
    "1. Indennita' di contingenza" : "ad esprimersi sull'abrogazione della norma che aveva disposto il taglio di 3 punti di contingenza della scala mobile.",
    "3. Elezione della Camera dei Deputati. Abrogazione della possibilita' per uno stesso candidato di presentare la propria candidatura in piu' di una circoscrizione" : "ad esprimersi sull'abrogazione della possibilità per uno stesso candidato di candidarsi contemporaneamente in più circoscrizioni.",
    "1. Modalita' di affidamento e gestione dei servizi pubblici locali di rilevanza economica - Abrogazione" : "ad esprimersi sull'abrogazione delle norme che consentivano di affidare la gestione dei servizi pubblici locali a operatori privati.",
    "3. Abrogazione delle nuove norme che consentono la produzione nel territorio di energia elettrica nucleare" : "ad esprimersi sull'abrogazione delle nuove norme che consentivano la produzione nel territorio nazionale di energia elettrica nucleare.",
    "4. Abrogazione di norme della legge 7 aprile 2010, n.51, in materia di legittimo impedimento del Presidente del Consiglio dei Ministri e dei Ministri a comparire in udienza penale, quale risultante a seguito della sentenza n.23 del 2011 della Corte Costituzionale " : "ad esprimersi sull'abrogazione delle norme in termini di legittimo impedimento.",
    "1. PER L'APPROVAZIONE DELLA LEGGE DI RIFORMA COSTITUZIONALE" : "ad esprimersi sulla riforma costituzionale promossa dal governo di Matteo Renzi nel 2016.",
    "1. REFERENDUM COSTITUZIONALE - RIDUZIONE DEL NUMERO DEI PARLAMENTARI" : "ad esprimersi sulla riforma costituzionale relativa alla riduzione del numero dei parlamentari."
}

# Dizionario relabelling quesito (2)
simplified_dict = {
    "1. REFERENDUM SULLA FORMA ISTITUZIONALE DELLO STATO" : "1946 - Monarchia vs Repubblica",
    "1. Divorzio" : "1974 - Divorzio",
    "2. Finanziamento pubblico dei partiti" : "1978 - Finanziamento pubblico ai partiti",
    "2. Ergastolo" : "1981 - Ergastolo",
    "3. Porto d'armi" : "1981 - Porto d'armi",
    "5. Interruzione gravidanza (Proposta Movimento per la vita)" : "1981 - Aborto",
    "1. Indennita' di contingenza" : "1985 - Scala mobile",
    "3. Elezione della Camera dei Deputati. Abrogazione della possibilita' per uno stesso candidato di presentare la propria candidatura in piu' di una circoscrizione" : "2009 - Abrogazione della possibilità di candidarsi in più circoscrizioni",
    "1. Modalita' di affidamento e gestione dei servizi pubblici locali di rilevanza economica - Abrogazione" : "2011 - Acqua pubblica",
    "3. Abrogazione delle nuove norme che consentono la produzione nel territorio di energia elettrica nucleare" : "2011 - Nucleare",
    "4. Abrogazione di norme della legge 7 aprile 2010, n.51, in materia di legittimo impedimento del Presidente del Consiglio dei Ministri e dei Ministri a comparire in udienza penale, quale risultante a seguito della sentenza n.23 del 2011 della Corte Costituzionale " : "2011 - Legittimo impedimento",
    "1. PER L'APPROVAZIONE DELLA LEGGE DI RIFORMA COSTITUZIONALE" : "2016 - Riforma costituzionale Renzi-Boschi",
    "1. REFERENDUM COSTITUZIONALE - RIDUZIONE DEL NUMERO DEI PARLAMENTARI" : "2020 - Riduzione del numero dei parlamentari"
}

title_dict = {
    '1. REFERENDUM SULLA FORMA ISTITUZIONALE DELLO STATO' : 'Referendum sulla forma istituzionale dello Stato',
    '1. Divorzio' : "Referendum sul divorzio", 
    '2. Finanziamento pubblico dei partiti' : "Referendum sul finanziamento pubblico ai partiti",
    '2. Ergastolo' : "Referendum sull'ergastolo", 
    "3. Porto d'armi" : "Referendum sul porto d'armi",
    '5. Interruzione gravidanza (Proposta Movimento per la vita)' : "Interruzione di gravidanza (Proposta Movimento per la vita)",
    "1. Indennita' di contingenza" : "Referendum sull'indennità di contingenza (scala mobile)",
    "3. Elezione della Camera dei Deputati. Abrogazione della possibilita' per uno stesso candidato di presentare la propria candidatura in piu' di una circoscrizione" : "Abrogazione della possibilita' per uno stesso candidato di presentare la propria candidatura in piu' di una circoscrizione",
    "1. Modalita' di affidamento e gestione dei servizi pubblici locali di rilevanza economica - Abrogazione" : "Referendum sulla modalita' di affidamento e gestione dei servizi pubblici locali di rilevanza economica",
    '3. Abrogazione delle nuove norme che consentono la produzione nel territorio di energia elettrica nucleare' : "Abrogazione del nucleare",
    '4. Abrogazione di norme della legge 7 aprile 2010, n.51, in materia di legittimo impedimento del Presidente del Consiglio dei Ministri e dei Ministri a comparire in udienza penale, quale risultante a seguito della sentenza n.23 del 2011 della Corte Costituzionale ' : "Referendum sul legittimo impedimento",
    "1. PER L'APPROVAZIONE DELLA LEGGE DI RIFORMA COSTITUZIONALE" : "Referendum costituzionale - Riforma Renzi-Boschi",
    '1. REFERENDUM COSTITUZIONALE - RIDUZIONE DEL NUMERO DEI PARLAMENTARI' : "Referendum costituzionale - Riduzione del numero dei parlamentari" 
}

# Join con risultati nazionali
final = df_new_com.merge(
    df_new_naz[["ANNO", "PREFERENZA", "TIPO_METRICA", "QUESITO", "VOTI"]],
    on=["ANNO", "PREFERENZA", "TIPO_METRICA", "QUESITO"],
    how="inner"
).rename(
    columns={
        "VOTI_x" : "LOCALE",
        "VOTI_y" : "NAZIONALE"
    }
)

# Assegnazione Comune
final["COMUNE"] = final.ANNO.apply(lambda x: "VANZAGHELLO" if x > 1968 else "MAGNAGO")
# Relabelling quesito (1)
final["SIMPLIFIED_Q"] = final.QUESITO.map(simplified_dict)
# Relabelling quesito (2)
final["VERBOSE_Q"] = final.QUESITO.map(verbose_dict)
# Relabelling quesito (3)
final["QUESITO"] = final.QUESITO.map(title_dict)
# Selezione colonne
final = final[["ANNO", "QUESITO", "SIMPLIFIED_Q", "VERBOSE_Q", "PREFERENZA", "LBL_TIPO_METRICA", "TIPO_METRICA", "LOCALE", "NAZIONALE", "FLG_NOT_VALID", "COMUNE"]]

final.to_csv(
    "SHINY_INPUT_DATA/REFERENDUM.csv",
    index=False
)