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
0. L'utente ha autorizzato di rendere pubblico temporaneamente il repository esistente per provare e poi toglierlo. PATCH private=false rifiutato con HTTP 403 Resource not accessible by integration; GET successivo conferma private=true, has_pages=false. Occorrono azioni dall'account proprietario: Settings → General → Danger Zone → Change visibility → Public; poi Settings → Pages → Deploy from branch → gh-pages / (root) → Save. Non richiedere di nuovo l'autorizzazione già data. Al termine della prova disattivare Pages e ripristinare private; anche queste azioni possono richiedere l'account proprietario se l'integrazione resta limitata.
1. Aprire `project.godot` o usare `bash scripts/run-godot.sh` con un display disponibile.
2. Raffinare il tempismo: ora la ricezione è assistita; il prototipo valida ciclo fisico e contatti.
3. Calibrare prospettiva, ampiezza del lancio e animazione con il video. Grafica e fedeltà finale non sono ancora approvate.
4. Configurare export Android e prova su telefono; poi rotazioni ampie, appoggi su un piede/di taglio e percorso iOS su macOS.

## Deleghe
Nessun lavoro parallelo da integrare. Agente fisica: rig e test; visuale: mesh/IK e posa; UI: HUD e controlli. Coordinatore: integrazione, verifiche, cattura e documentazione.

## Persistenza
Sorgenti committati e inviati al repository privato su main; build web su gh-pages. L’attivazione Pages è bloccata dai permessi dell’integrazione, non dal caricamento Git. Conservare lo snapshot per cache e toolchain. I processi del display non sopravvivono necessariamente alla pubblicazione. Bozza cloud aggiornata con install_script e start_skill del prototipo; salvataggio confermato. Rivedere e salvare le impostazioni, poi pubblicare lo snapshot nell’interfaccia. Pubblicazione e ripristino in un nuovo task non verificati.
