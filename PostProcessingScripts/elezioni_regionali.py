# Lib import
import pandas as pd

# Leggo risultati regionali & comunali
df_reg = pd.read_csv("ScrapingScripts/RawOutput/RisultatiNazionali/REGIONALI.csv")
df_com = pd.read_csv("ScrapingScripts/RawOutput/RisultatiComunali/REGIONALI.csv")

# Eliminazione righe non valide
df_reg = df_reg[(df_reg.LISTA != 0) & (df_reg.VOTI != 0)]
df_com = df_com[(df_com.LISTA != 0) & (df_com.VOTI != 0)]

# Per identificare righe da eliminare (relative a candidato e non a liste)
candidate_names = [
    "FONTANA ATTILIO", 
    "MAJORINO PIERFRANCESCO",
    "BRICHETTO ARNABOLDI LETIZIA MARIA DETTA LETIZIA MORATTI",
    "GORI GIORGIO",
    "VIOLI DARIO",
    "MARONI ROBERTO ERNESTO",
    "AMBROSOLI UMBERTO RICCARDO RINALDO MARIA",
    "CARCANO SILVANA",
    "ALBERTINI GABRIELE"
]

# Metto da parte ASTENUTI/BIANCHE/NULLE
not_valid = df_com[df_com.FLG_NOT_VALID == 1].copy()

# Risultati dei partiti (elimino voti presi da candidato)
results = df_com[(df_com.FLG_NOT_VALID == 0) & (~(df_com.LISTA.isin(candidate_names)))]\
    .sort_values(["ANNO", "VOTI"], ascending=False)\
    .groupby(["ANNO", "LBL_TIPO_METRICA"])\
    .head(5)

# Concateno valid e non valid
stg_df = pd.concat([results, not_valid], ignore_index=True)

# Prima della join correggo inconsistenza tra dataset regionale e comunale
df_reg.loc[df_reg.LISTA == 'DEM.PROLETARIA', 'LISTA'] = "DEM.PROL"

# Join con risultati regionali
final = stg_df.merge(
    df_reg[["ANNO", "LISTA", "TIPO_METRICA", "VOTI"]],
    on=["ANNO", "LISTA", "TIPO_METRICA"],
    how="left"
).rename(
    columns={
        "VOTI_x" : "LOCALE",
        "VOTI_y" : "REGIONALE"
    }
).assign(
    COMUNE = "VANZAGHELLO"
)

# Sostituisco nomi troppo lunghi
mapping_dict = {
    "MSI-DN" : "MSI",
    "FORZA IT.-POLO POP." : "FORZA ITALIA",
    "UNITI NELL'ULIVO" : "L'ULIVO",
    "MOVIMENTO 5 STELLE BEPPEGRILLO.IT" : "MOVIMENTO 5 STELLE", 
    "FRATELLI D'ITALIA CON GIORGIA MELONI" : "FRATELLI D'ITALIA",
    "LEGA - SALVINI PER FONTANA - LEGA LOMBARDA" : "LEGA",
    "FRATELLI D'ITALIA - GIORGIA MELONI" : "FRATELLI D'ITALIA",
    "PART.DEMOCR. LOMBARDIA DEMOCRATICA E PROGRESSISTA - MAJORINO" : "PARTITO DEMOCRATICO",
    "LOMBARDIA IDEALE - FONTANA PRESIDENTE" : "FONTANA PRESIDENTE",
    "PSU" : "P.S.U."
}
# Per assegnare un logo diverso al PSI post-1980
final.loc[(final.ANNO > 1980) & (final.LISTA == "PSI"), "LISTA"] = "P.S.I."
# Sostituzione dei nomi
final['LISTA'] = final.LISTA.apply(lambda x: mapping_dict[x] if x in mapping_dict.keys() else x)

# Selezione colonne
final = final[["COMUNE", "ANNO", "LISTA", "LBL_TIPO_METRICA", "ABS_RANK", "TIPO_METRICA", "LOCALE", "REGIONALE", "FLG_NOT_VALID"]]

# Scrittura
final.to_csv(
    "SHINY_INPUT_DATA/REGIONALI.csv",
    index=False
)