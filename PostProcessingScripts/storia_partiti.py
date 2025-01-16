# Lib import
import pandas as pd

# Data import
df_new = pd.read_csv(
    "SHINY_INPUT_DATA/NAZIONALI.csv",
    usecols=['ANNO', 'LISTA', 'ABS_RANK', 'TIPO_METRICA', 'LBL_TIPO_METRICA', 'LOCALE', 'FLG_NOT_VALID']
).rename(columns={'LOCALE' : 'VOTI'})

# Aggiustare PSI
df_new['LISTA'] = df_new.LISTA.apply(lambda x: 'PSI' if x == 'P.S.I.' else x)
df_new['TIPO_ELEZIONI'] = 'NAZIONALI'

# Definizione dei partiti di interesse
to_keep = [
  "DC", "PCI", "PSI", "PLI", "PRI", "MSI",
  "FORZA ITALIA", "LEGA LOMBARDA", "PSDI",
  "LEGA NORD", "LEGA", "ALLEANZA NAZIONALE", "PDS",
  "IL POPOLO DELLA LIBERTA'", "RIFONDAZIONE COMUNISTA",
  "MOVIMENTO 5 STELLE", "PARTITO DEMOCRATICO", "L'ULIVO",
  "FRATELLI D'ITALIA", "DEMOCRATICI SINISTRA", "LA MARGHERITA",
  "ASTENUTI", "BIANCHE", "NULLE"
]
# Filtro
stg_df = df_new[df_new.LISTA.isin(to_keep)].copy()

# Pivotizzo
final = stg_df\
    .pivot(
        index=['ANNO', 'TIPO_ELEZIONI', 'LISTA'], 
        columns='TIPO_METRICA', 
        values='VOTI'
    ).reset_index()

# Pretty printing
final.columns.name = None
# Inizializzo colonna del Comune
final['COMUNE'] = final.ANNO.apply(lambda x: 'VANZAGHELLO' if x > 1968 else "MAGNAGO")

# Scrittura
final.to_csv(
    "SHINY_INPUT_DATA/PARTITI.csv",
    index=False
)