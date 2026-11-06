# Anteprima senza installazione sul telefono

Aggiornato: 2026-11-06.

Build web in `build/web/`, esportata e verificata con Chromium in viewport mobile 393 × 873. Un tocco su LANCIA completa un ciclo; contatore 01 verificato nella cattura. Nessun errore JavaScript. Evidenze: `build/web-ready.png`, `build/web-after-touch.png`, `build/web-browser-result.json`. Non è una prova su Android fisico.

Non è ancora pubblicata; nessun link pubblico attivo/verificato. Questa chat non espone hosting o anteprima interattiva sul telefono. Il server locale dei test non è raggiungibile dall'utente.

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

Preparazione: main per i sorgenti e gh-pages per il solo sito compilato. Nessun cambio di visibilità. Dopo il caricamento provare l'attivazione Pages sulla root di gh-pages; se l'API resta bloccata, l'utente dovrà abilitarla in Settings → Pages. I piani gratuiti non includono Pages da repository privati; verificare l'esito del servizio o l'interfaccia senza assumere il piano.

Il repository resta privato; un sito Pages personale normalmente è pubblico. Nessun link va presentato come attivo prima di verificarlo. L'app Android può aprire il sito nel browser integrato o in Chrome, secondo il client.
