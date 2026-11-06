# Evidenze di validazione

Registrare data, comando o procedura, risultato effettivo e limiti. Distinguere superato, fallito, saltato e non eseguito.

## 2026-11-04 — Base iniziale
- Accesso Git remoto in lettura: riuscito durante onboarding; repository senza riferimenti remoti.
- Node.js, npm e Python: versioni rilevate; nessun requisito del gioco ancora associato.
- Build, test gameplay, dispositivi Android/iOS: **non eseguiti**, applicazione assente.
- Configurazione Codex: controllo Python eseguito sui 13 file Markdown; quattro skills con campi name/description e nome corrispondente alla directory, riferimenti locali esistenti. Esito: superato.
- Delega reale: agente project_skills incaricato di tre skills, con ambito esclusivo; risultati letti e integrati dal coordinatore. Revisione successiva in sola lettura completata senza problemi bloccanti. Ordine concept → motore aggiornato secondo la risposta dell'utente.
- Persistenza configurazione: update_environment_config_draft ha confermato status=saved per start_skill; requires_publish=true. Nessun install_script necessario per questa base documentale.
- Caricamento automatico delle skills e ripristino in una nuova sessione: non eseguiti. Pubblicazione dell'ambiente e sincronizzazione GitHub: non eseguite.

Un controllo documentale non dimostra che il gioco funzioni o che una release possa essere pubblicata.

## 2026-11-04 — Riferimento del tavolo
- Esaminati visivamente i sette screenshot in chat. Osservazioni e limiti registrati in `docs/GAME_DESIGN.md`; nessuna deduzione di tempo di volo o ordine temporale dalle immagini statiche.
- Apertura del link: `curl --location --fail-with-body --silent --show-error --connect-timeout 10 --max-time 30` verso lo Short D31mZpg5lJo, attraverso il proxy previsto. Esito: exit 56, `CONNECT tunnel failed, response 403`, codice HTTP finale 000. Il 403 è del tunnel proxy, non una risposta del contenuto YouTube.
- Stato ambiente osservato: running, osservazioni correnti, rete restricted/enforced; nessun dominio YouTube consentito nella policy corrente al momento del tentativo.
- Bozza: confermato salvataggio di `youtube.com` e `www.youtube.com` come domini custom, preservando il preset esistente; aggiornato `start_skill` al concept attuale. Non equivale a nuova connettività, riproduzione del video o pubblicazione dell'ambiente. Nessun host media/CDN verificato.
- Revisione tecnica indipendente dell'agente physics_review: completata in sola lettura; osservazioni su prospettiva, impulsi, inerzia, contatti, interpolazione e verifiche integrate nel documento.
- Test fisici, misure di fps/latenza e confronto temporale col filmato: **non eseguiti**. I criteri in GAME_DESIGN sono un piano per il prototipo, non risultati di test.

## 2026-11-04 — Nuovo tentativo con collegamento diretto
- Ambiente nuovamente raggiungibile dal terminale; network policy osservata unrestricted/enforced, revision 2, osservazioni correnti.
- GET del collegamento MP4 firmato fornito dall'utente, via proxy e con TLS verificato: curl exit 56, `CONNECT tunnel failed, response 403`, HTTP finale 000, zero byte. Nessun video acquisito.
- Diagnosi mirata: HEAD della radice dello stesso host Googlevideo e GET della pagina Shorts su www.youtube.com. Entrambi rifiutati al CONNECT, con risposta HTTP/1.1 403 Forbidden del proxy (server envoy). La firma e i parametri del file non sono stati verificati dal server video: non attribuire il fallimento a scadenza o binding IP senza evidenza.
- Non modificata ulteriormente la rete; nessun tentativo di aggirare il proxy. Non copiato l'URL temporaneo nei documenti.

## 2026-11-04 — Allegato video: analisi completata
- Acquisizione via download_file dell'allegato `file_00000000a6008246bfdb56ed93a59ad6`: riuscita, 2.465.739 byte. Hash e riferimenti in `docs/VIDEO_ANALYSIS.md`.
- ffprobe: 360 × 640, video H.264 a 30000/1001 fps, 1.040 frame; durata contenitore 34,829932 s. Estratti timestamp reali di presentazione per ogni frame.
- `ffmpeg -hide_banner -loglevel error -i <file allegato> -f null -`: exit 0, nessun errore di decodifica audio/video. Questo non equivale a valutazione dell'audio o autenticazione della velocità originale della ripresa.
- Ispezione visiva: panoramica dell'intero clip e dettagli temporali dei contatti; campioni fino a un frame di passo nel primo lancio. Tavole generate e visionate tramite view_image. Evidenze, finestre di tempo e limiti salvati in VIDEO_ANALYSIS; figura del primo lancio in `docs/references/first-launch.jpg`.
- Agente physics_review: analisi indipendente del tratto 16,016–34,668 s e riscontro di distacco/ricezione del primo lancio. Correzione integrata: supporto e manipolazione sostenuta sono distinti dal volo libero.
- REF-01 completato. Build, test del gameplay, misure delle forze e performance su dispositivi: ancora **non eseguiti**.

## 2026-11-06 — Primo prototipo Godot
- Godot preinstallato `4.6.3.stable.official.7d41c59c4`, Linux x86_64. `bash scripts/setup.sh`: importazione riuscita, exit 0. Non installati nuovi artefatti del motore.
- `bash scripts/check.sh`: exit 0, **23/23 controlli fisici** e **15/15 controlli della scena integrata**. Log in `build/validation/test_physics.log` e `test_game.log`. Profilo QA temporaneo separato dal giocatore; controllati errori, exit status e presenza di test realmente completati.
- Fisica: ballistica, assenza di spin introdotto dalla gravità, impulsi centrati/decentrati, sostegno, tre cicli bilanciati, tocchi in aria senza energia aggiunta, altezza limitata, punteggio non ripetuto durante appoggio passivo, asimmetrie recuperabili, caduta e reset. Corpo dinamico e collider reali dei piedi.
- Integrazione: touch inoltrato al viewport della scena di produzione, lancio/ricezione, HUD e persistenza record, pausa con posizione fisica invariata, ripresa, reset anche da sostegno, caduta/retry, tastiera e layout verticale stretto. Il primo tentativo con Input.parse_input_event nel runner headless non inoltrava gli eventi; corretto il metodo di iniezione al viewport, mantenendo il percorso di input di produzione.
- Correzioni: reset del contatore visualizzato, enum Environment incompatibile e posa IK delle gambe che attraversava il piano vicino della camera.
- Avvio grafico su Xorg dummy :98, OpenGL/Mesa llvmpipe. Screenshot `build/prototype.png` acquisito e ispezionato. Avviso VSync non supportato dal driver virtuale; nessun errore di script/rendering nella cattura.
- Registrazione offline: 300 frame/5 s a 60 fps impostati, due lanci automatici, exit 0. Convertita in `build/sospeso-demo.mp4`, durata verificata con ffprobe e campioni visionati in `build/demo-frames.jpg`. Non è un test di prestazioni in tempo reale.
- **Non eseguiti:** confronto render 30/120 fps, touch fisico, lifecycle/termica/accessibilità su telefono, export/firma Android/iOS e store. Grafica provvisoria; tempismo, fedeltà al filmato e difficoltà richiedono calibrazione e playtest.

- Persistenza: install_script e start_skill aggiornati, tool con status=saved e requires_publish=true. Non equivale a pubblicazione, push GitHub o verifica di una nuova macchina.

## 2026-11-06 — Build web per prova senza installazione
- Archivio template ufficiale Godot 4.6.3 (1.255.918.323 byte) verificato con SHA-512 ufficiale prima dell'estrazione. Hash dei template estratti registrati in config/web-template-checksums.json; setup-web.sh verifica la cache e passa.
- Export release Web single-thread riuscito, exit 0. Risolto requisito di import ETC2/ASTC segnalato dall'exporter; nessun cambiamento ai valori fisici. Simbolo pausa sostituito con ASCII per compatibilità del font web.
- Chromium con viewport 393 × 873 e touch: caricamento WebGL2/Wasm riuscito, zero errori JavaScript, lancio tramite touch e contatore 01 verificato nella cattura. tests/web_smoke.cjs usa coordinate nel contenuto 9:16, comprese le bande, e chiude il browser anche in caso di errore. Screenshot e risultato JSON in build/.
- Sito pronto in build/web, licenze Godot incluse, .nojekyll presente; archivio build/sospeso-web-ready.zip con 12 file, CRC verificato. Non è pubblicato né provato su Android fisico.
- API GitHub in lettura: repository enricomatassini/codex-game-project privato, has_pages=false. Nessuna modifica remota. Proposta pubblicazione su repository pubblico separato da autorizzare.

## 2026-11-06 — Caricamento nel repository privato richiesto
- Lettura autenticata account/repository riuscita: account enricomatassini, repository private=true, admin/push=true; dettaglio piano non restituito. GET Pages: HTTP 403 Resource not accessible by integration.
- Sorgenti committati (iniziale 11c78b4) e push main riuscito. Sito compilato da 12 file/38.206.000 byte in commit separato 01d77403e67d95a9fed7cf91c6d61ec556b38859, push gh-pages riuscito. Indice temporaneo separato usato per il sito; checkout main conservato, nessun worktree o push forzato.
- POST /repos/enricomatassini/codex-game-project/pages con build_type=legacy e source gh-pages /: HTTP 403 Resource not accessible by integration. Attivazione non eseguita. Richiesta azione del proprietario in Settings → Pages; nessun URL pubblico dichiarato attivo e nessuna inferenza sul piano.
- Nessuna modifica di visibilità e nessun repository pubblico creato.

- Dopo autorizzazione esplicita dell'utente alla prova pubblica temporanea, PATCH repository con private=false: HTTP 403 Resource not accessible by integration. GET successivo HTTP 200 conferma private=true, visibility=private e has_pages=false. Necessario cambio di visibilità e attivazione Pages dal proprietario; autorizzazione utente registrata, non va richiesta nuovamente.
