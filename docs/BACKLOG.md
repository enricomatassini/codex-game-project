# Backlog

| ID | Attività | Stato | Dipendenze | Criterio di completamento |
|---|---|---|---|---|
| SETUP-01 | Istruzioni Codex, memoria e skills | Completato | — | File coerenti, skills leggibili, workflow agenti verificato con una delega reale |
| ENGINE-01 | Scegliere motore e versione | Completato: Godot 4.6.3 | DESIGN-01 | Versione fissata e motivata |
| SETUP-02 | Installare e validare toolchain | Completato per Linux | ENGINE-01 | Importazione, avvio e test eseguiti; comandi in DEVELOPMENT |
| DESIGN-01 | Analizzare riferimento e specificare prototipo | Specificato; controlli da provare | — | Concept documentato in GAME_DESIGN; osservazioni e proposte distinte |
| REF-01 | Analizzare il movimento del video | Completato: allegato analizzato | — | Primo ciclo con timestamp, resto della routine e limiti documentati in VIDEO_ANALYSIS |
| PHYS-01 | Sostegno, lancio e ricezione del tavolo | Core verificato; calibrazione da rifinire | SETUP-02, DESIGN-01, REF-01 | Ballistica e contatti passano; confronto 30/120 fps e dispositivi da fare |
| GAME-01 | Prima esperienza giocabile | Core pronto; playtest telefono da fare | PHYS-01 | Input, contatore, fine e riavvio verificati; semplicità valutata sul telefono |
| INPUT-01 | Tempismo e progressione difficoltà | Da fare | GAME-01 | Ricezione assistita confrontata con controllo temporizzato in playtest |
| ART-01 | Calibrare prospettiva e gesti rispetto al video | Da fare | REF-01, PHYS-01 | Confronto di lancio/ricaduta, leggibilità e contatto su telefono |
| WEB-01 | Versione web per prova senza installazione | Build pronta e testata nel browser | GAME-01 | Export Wasm e lancio touch verificati |
| WEB-02 | Pubblicare un link HTTPS | Build su gh-pages; attivazione manuale richiesta, API 403 | WEB-01 | Pages attivo e lancio verificato sul sito; poi prova utente Android |
| MOBILE-01 | Prima prova Android su dispositivo | Da fare | GAME-01 | Build installabile, touch e lifecycle verificati con evidenze |
| IOS-01 | Configurare build macOS/iOS | Da fare | ENGINE-01 | Xcode, provisioning e build verificati su runner o Mac disponibile |

Il coordinatore aggiorna stato e assegnazioni; gli agenti propongono aggiornamenti nel loro rapporto.
