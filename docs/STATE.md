# Stato e prossimo passo

Aggiornato: 2026-11-06.

## Stato
Primo prototipo **Sospeso** implementato in Godot 4.6.3: sostegno a due piedi, spinta, volo sotto gravità, ricezione ammortizzata e riassetto. Input touch/mouse/tastiera, contatore, record locale, pausa e riavvio. Grafica procedurale provvisoria e ricezione assistita. Godot adottato operativamente dopo la richiesta di proseguire con il prototipo raccomandato.

## Evidenze
- Export web riuscito, caricamento/touch in Chromium mobile emulato verificati; contatore 01 osservato. Sito HTTPS attivo: https://enricomatassini.github.io/codex-game-project/ ; lancio touch sul sito verificato in Chromium mobile emulato, contatore 01 e zero errori JavaScript.
- Video utente analizzato: `docs/VIDEO_ANALYSIS.md`; non richiederlo nuovamente.
- `bash scripts/setup.sh`: importazione riuscita con Godot preinstallato.
- `bash scripts/check.sh`: 23/23 controlli fisici e 15/15 sulla scena completa; log in `build/validation/`.
- Avvio grafico OpenGL/Mesa llvmpipe riuscito, screenshot ispezionato, posa delle gambe corretta.
- Demo offline di 5 s/300 frame: `build/sospeso-demo.mp4`, campioni ispezionati. Non dimostra prestazioni mobile.
- Comandi in `docs/DEVELOPMENT.md`. Nessuna build nativa né prova su telefono eseguita.

## Ripresa
0. Anteprima pubblica attiva: https://enricomatassini.github.io/codex-game-project/ . Deployment GitHub Pages 42226590864 concluso con successo, HTTP 200, MIME Wasm corretto; prova browser sul sito completata. Attendere il riscontro dell'utente Android. Quando segnala fine prova, disattivare Pages e ripristinare private; non cancellare repository o sorgenti e non fissare una scadenza arbitraria.
1. Aprire `project.godot` o usare `bash scripts/run-godot.sh` con un display disponibile.
2. Raffinare il tempismo: ora la ricezione è assistita; il prototipo valida ciclo fisico e contatti.
3. Calibrare prospettiva, ampiezza del lancio e animazione con il video. Grafica e fedeltà finale non sono ancora approvate.
4. Configurare export Android e prova su telefono; poi rotazioni ampie, appoggi su un piede/di taglio e percorso iOS su macOS.

## Deleghe
Nessun lavoro parallelo da integrare. Agente fisica: rig e test; visuale: mesh/IK e posa; UI: HUD e controlli. Coordinatore: integrazione, verifiche, cattura e documentazione.

## Persistenza
Sorgenti su main e build su gh-pages. Repository ora pubblico temporaneamente, attivazione Pages completata dall’utente. Non conservare come stato corrente il precedente blocco API dei permessi. Conservare lo snapshot per cache e toolchain. I processi del display non sopravvivono necessariamente alla pubblicazione. Bozza cloud aggiornata con install_script e start_skill del prototipo; salvataggio confermato. Rivedere e salvare le impostazioni, poi pubblicare lo snapshot nell’interfaccia. Pubblicazione e ripristino in un nuovo task non verificati.
