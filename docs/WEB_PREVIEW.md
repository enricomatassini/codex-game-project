# Anteprima senza installazione sul telefono

Aggiornato: 2026-11-06.

Build web in `build/web/`, esportata e verificata con Chromium in viewport mobile 393 × 873. Un tocco su LANCIA completa un ciclo; contatore 01 verificato nella cattura. Nessun errore JavaScript. Evidenze: `build/web-ready.png`, `build/web-after-touch.png`, `build/web-browser-result.json`. Non è una prova su Android fisico.

Anteprima pubblica attiva e verificata: https://enricomatassini.github.io/codex-game-project/ . Workflow GitHub Pages 42226590864 concluso con successo. HTTP 200, HTTPS attivo e Content-Type application/wasm corretto. Prova sul sito con viewport mobile e touch completata: lancio riuscito, contatore 01 verificato visivamente, nessun errore JavaScript. Il repository resta pubblico solo per la prova richiesta dall’utente; chiuderla quando lo segnala.

## Build

```bash
bash scripts/setup-web.sh
bash scripts/export-web.sh
```

Template ufficiali Godot 4.6.3 verificati contro SHA-512 ufficiale; provenienza e hash in `config/web-template-checksums.json`. Il setup ricontrolla i template in cache. Su cache vuota scarica circa 1,26 GB sul cloud; TLS/checksum mantenuti.

Export single-thread senza GDExtension: non richiede SharedArrayBuffer o isolamento cross-origin. Import ETC2/ASTC abilitato. Solo scena/script di produzione nel PCK, documenti/test/video esclusi. Licenze del motore incluse. Il browser carica le risorse automaticamente: nessun APK o Godot da installare.

Test del runtime cloud: servire `build/web/` localmente e lanciare `node tests/web_smoke.cjs` (Playwright/Chromium preinstallati). Il test tiene conto delle bande 9:16 e salva le catture; contatore verificato visivamente.

## Pubblicazione nel repository privato

L'utente ha richiesto di usare il repository privato esistente enricomatassini/codex-game-project, senza crearne uno pubblico separato. L'integrazione ha permessi admin/push sui contenuti; GET Pages restituisce HTTP 403, Resource not accessible by integration. Questo non dimostra da solo un limite del piano dell'utente.

Caricamento completato: main contiene i sorgenti, gh-pages il sito compilato (12 file, 38.206.000 byte), commit web 01d77403e67d95a9fed7cf91c6d61ec556b38859. Push entrambi riusciti senza forzature; repository sempre privato. POST Pages con build_type legacy e source gh-pages / rifiutato con HTTP 403 Resource not accessible by integration. Non è una conferma del piano dell'utente.

Azione necessaria dall'account proprietario: aprire https://github.com/enricomatassini/codex-game-project/settings/pages e selezionare Source: Deploy from a branch, branch: gh-pages, cartella: / (root), quindi Save. Se l'interfaccia richiede upgrade per repository privati, resta un requisito del piano: non rendere pubblico il repository senza una nuova istruzione.

Dopo l'azione, verificare deployment, HTTPS e un lancio sul sito. L'accesso in scrittura ai contenuti Git non autorizza automaticamente le API Pages e non va aggirato estraendo token o avviando workflow con privilegi non disponibili.

Il repository resta privato; un sito Pages personale normalmente è pubblico. Nessun link va presentato come attivo prima di verificarlo. L'app Android può aprire il sito nel browser integrato o in Chrome, secondo il client.

## Autorizzazione aggiornata: prova pubblica temporanea

L'utente ha poi autorizzato di rendere pubblico il repository esistente per provare, e rimuovere l'anteprima dopo. PATCH /repos/enricomatassini/codex-game-project con private=false: HTTP 403 Resource not accessible by integration. GET di verifica: private=true, visibility=private, has_pages=false. Il blocco è dell'integrazione GitHub, non dell'autorizzazione dell'utente né un rifiuto di sicurezza del tool.

Azioni proprietario:
1. https://github.com/enricomatassini/codex-game-project/settings → Danger Zone → Change repository visibility → Public.
2. https://github.com/enricomatassini/codex-game-project/settings/pages → Deploy from a branch → gh-pages → / (root) → Save.

Dopo la prova: disattivare Pages e rimettere il repository privato dalla stessa pagina General. Non eliminare sorgenti o repository: per “levarla” usare disattivazione del sito e ripristino della visibilità. Aspettare che l'utente segnali la fine della prova, senza inventare una scadenza. Nessuna modifica di visibilità o attivazione è stata completata dall'agente.

## Attivazione completata dall'utente

Dopo “fatto”, API conferma private=false, has_pages=true, build_type=legacy, source gh-pages /, https_enforced=true. Il workflow pages build and deployment 42226590864 ha build riuscita sul commit 01d77403e67d95a9fed7cf91c6d61ec556b38859; distribuzione iniziale ancora in corso durante la prima osservazione. I precedenti blocchi di permesso sono storia, non il prerequisito attuale.

## Verifica finale del sito pubblico

Eseguito `node tests/web_smoke.cjs https://enricomatassini.github.io/codex-game-project/`: exit 0. Il test rispetta il proxy del runtime mantenendo la verifica TLS; screenshot e risultato salvati con prefisso build/web-live. Contatore 01 osservato in web-live-after-touch.png. Non è una prova su telefono fisico né nell'app Android dell'utente.
