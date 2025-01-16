# Lib import
import pandas as pd

# Dizionario per rinominare nomi troppo lunghi
mapping_dict = {
    "FED.LISTE VERDI" : "FEDERAZIONE DEI VERDI",
    "LEGA LOMBARDA-A.NORD" : "LEGA LOMBARDA",
    "UNITI NELL'ULIVO" : "L'ULIVO",
    "LEGA NORD-DIE FREIHEITLICHEN-BASTA EURO" : "LEGA NORD",
    "MOVIMENTO 5 STELLE BEPPEGRILLO.IT" : "MOVIMENTO 5 STELLE", 
    "LEGA SALVINI PREMIER" : "LEGA",
    "FORZA ITALIA - NOI MODERATI - PPE" : "FORZA ITALIA"
}

# Lettura Output Scraping
df_new_naz = pd.read_csv("ScrapingScripts/RawOutput/RisultatiNazionali/EUROPEE.csv")
df_new_com = pd.read_csv("ScrapingScripts/RawOutput/RisultatiComunali/EUROPEE.csv")

# Join risultati comunali con risultati nazionali
stg_df = df_new_com.merge(
    df_new_naz[["ANNO", "LISTA", "TIPO_METRICA", "VOTI"]],
    on=["ANNO", "LISTA", "TIPO_METRICA"],
    how="inner"
).rename(
    columns={
        "VOTI_x" : "LOCALE",
        "VOTI_y" : "NAZIONALE"
    }
)
# Assegnazione Comune
stg_df["COMUNE"] = "VANZAGHELLO"

# Per assegnare un logo diverso al PSI post-1980
stg_df.loc[(stg_df.ANNO > 1980) & (stg_df.LISTA == "PSI"), "LISTA"] = "P.S.I."
# Sostituzione dei nomi
stg_df['LISTA'] = stg_df.LISTA.apply(lambda x: mapping_dict[x] if x in mapping_dict.keys() else x)
# Selezione colonne
stg_df = stg_df[["LISTA", "LBL_TIPO_METRICA", "ABS_RANK", "TIPO_METRICA", "LOCALE", "NAZIONALE", "FLG_NOT_VALID", "COMUNE", "ANNO"]]

# Metto da parte ASTENUTI/BIANCHE/NULLE
not_valid = stg_df[stg_df.FLG_NOT_VALID == 1].copy()
# Risultati dei partiti (top 5)
results = stg_df[stg_df.FLG_NOT_VALID == 0]\
    .sort_values(["ANNO", "LOCALE"], ascending=False)\
    .groupby(["ANNO", "LBL_TIPO_METRICA"])\
    .head(5)

# Concateno valid e non valid
final = pd.concat([results, not_valid], ignore_index=True)

final.to_csv(
    "SHINY_INPUT_DATA/EUROPEE.csv",
    index=False
)