# Organizzazione dei file

### Script R
* `app.R`: lo script principale della shiny app. 
* `dict_utils.R`: definisce i dizionari di mapping che permettono l'associazione partito-colore e partito-logo. 
* `function_utils.R`: definisce le funzioni che andranno ad essere utilizzate all'interno dello script principale della shiny app. 

### Script webscraping (Python)
* `ScrapingScripts/RisultatiComunali/FirstRun`: directory contente gli script per il web scraping dei risultati comunali. Da eseguire solo una volta, quando non si è ancora estratto alcun dato. L'output di questo script deve essere scritto in `RawOutput/`. 
* `ScrapingScripts/RisultatiComunali/Append`: directory contente gli script per il web scraping dei risultati comunali. Da eseguire solo quando si hanno già dei dati a disposizione, e si vogliono aggiungere i risultati di una singola consultazione al dataset già esistente. L'output di questo script deve essere scritto nella directory `RawOutput/`. 
* `ScrapingScripts/RisultatiNazionali/FirstRun`: directory contente gli script per il web scraping dei risultati nazionali. Da eseguire solo una volta, quando non si è ancora estratto alcun dato. L'output di questo script deve essere scritto in `RawOutput/`. 
* `ScrapingScripts/RisultatiNazionali/Append`: directory contente gli script per il web scraping dei risultati nazionali. Da eseguire solo quando si hanno già dei dati a disposizione, e si vogliono aggiungere i risultati di una singola consultazione al dataset già esistente. L'output di questo script deve essere scritto nella directory `RawOutput/`. 

### Script di post-processing (Python)
* `PostProcessingScripts/`: directory contenente gli script per il post-processing dei risultati estratti tramite webscraping. L'output degli script viene salvato in `SHINY_INPUT_DATA/`. 

### Altro 
* `www/`: directory contenente le immagini dei loghi dei partiti
* `SHINY_INPUT_DATA/`: directory contenente i dataset per le visualizzazioni della shiny app. 