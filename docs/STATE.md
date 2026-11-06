# Stato e prossimo passo

Aggiornato: 2026-11-06.

## Stato
Primo prototipo **Sospeso** implementato in Godot 4.6.3: sostegno a due piedi, spinta, volo sotto gravità, ricezione ammortizzata e riassetto. Input touch/mouse/tastiera, contatore, record locale, pausa e riavvio. Grafica procedurale provvisoria e ricezione assistita. Godot adottato operativamente dopo la richiesta di proseguire con il prototipo raccomandato.

## Evidenze
- Export web riuscito, caricamento/touch in Chromium mobile emulato verificati; contatore 01 osservato. Nessun link pubblico ancora disponibile.
- Video utente analizzato: `docs/VIDEO_ANALYSIS.md`; non richiederlo nuovamente.
- `bash scripts/setup.sh`: importazione riuscita con Godot preinstallato.
- `bash scripts/check.sh`: 23/23 controlli fisici e 15/15 sulla scena completa; log in `build/validation/`.
- Avvio grafico OpenGL/Mesa llvmpipe riuscito, screenshot ispezionato, posa delle gambe corretta.
- Demo offline di 5 s/300 frame: `build/sospeso-demo.mp4`, campioni ispezionati. Non dimostra prestazioni mobile.
- Comandi in `docs/DEVELOPMENT.md`. Nessuna build nativa né prova su telefono eseguita.

## Ripresa
0. Priorità attuale: provare dall'app Android senza installazioni. Build web pronta, vedi `docs/WEB_PREVIEW.md`. L’utente richiede di usare il repository privato esistente. Caricamento su main e gh-pages in preparazione; API Pages restituisce 403 Resource not accessible by integration. Nessun nuovo repository o cambio di visibilità autorizzato.
1. Aprire `project.godot` o usare `bash scripts/run-godot.sh` con un display disponibile.
2. Raffinare il tempismo: ora la ricezione è assistita; il prototipo valida ciclo fisico e contatti.
3. Calibrare prospettiva, ampiezza del lancio e animazione con il video. Grafica e fedeltà finale non sono ancora approvate.
4. Configurare export Android e prova su telefono; poi rotazioni ampie, appoggi su un piede/di taglio e percorso iOS su macOS.

## Deleghe
Nessun lavoro parallelo da integrare. Agente fisica: rig e test; visuale: mesh/IK e posa; UI: HUD e controlli. Coordinatore: integrazione, verifiche, cattura e documentazione.

## Persistenza
Modifiche ancora locali, senza commit/push GitHub. Conservare snapshot o pacchetto sorgenti prima di cambiare macchina. I processi del display non sopravvivono necessariamente alla pubblicazione. Bozza cloud aggiornata con install_script e start_skill del prototipo; salvataggio confermato. Rivedere e salvare le impostazioni, poi pubblicare lo snapshot nell’interfaccia. Pubblicazione e ripristino in un nuovo task non verificati.
