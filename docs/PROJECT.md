# Progetto

## Requisiti confermati
- Gioco 3D.
- Riferimento: tavolo palleggiato con i piedi, visuale verso il cielo; dettagli in `docs/GAME_DESIGN.md`.
- Priorità esplicite: caduta credibile sotto gravità, semplicità e fluidità.
- Destinazioni: Apple App Store e Google Play.
- Sviluppo assistito da Codex, skills locali, contesto persistente e lavoro ripartito tra agenti.
- Lingua di collaborazione: italiano.

## Da definire
- Motore del primo prototipo: Godot 4.6.3, adottato dopo la definizione del concept e la richiesta di continuare.
- Concept: gioco di abilità sul palleggio acrobatico; controlli e regole proposti in `docs/GAME_DESIGN.md`, da provare. Pubblico e stile finale da definire.
- Orientamento verticale proposto dai riferimenti; dispositivi minimi da definire.
- Offline/online, monetizzazione e servizi esterni: nessuno ancora richiesto.

## Primo traguardo proposto
Un tavolo fisico, piedi visibili, camera verso il cielo e rilanci touch. Verificare prima sostegno, lancio, caduta e ricezione ammortizzata; poi rotazione, punteggio, fine partita e riavvio. Screenshot e video allegato sono stati analizzati. Le finestre temporali e i limiti delle misure sono in `docs/VIDEO_ANALYSIS.md`: il riferimento alterna volo libero e manipolazione sostenuta sui piedi.

## Vincoli tecnici
Il ciclo base è implementato e verificato su Linux. Ricezione assistita e grafica procedurale sono provvisorie; tempismo, fedeltà visiva e giocabilità su telefono restano da rifinire e validare.

L'ambiente corrente è Linux. Il completamento della distribuzione iOS richiederà un Mac o un runner macOS, Xcode e credenziali Apple. La pubblicazione Android richiederà toolchain Android, firma e account Play Console. Questi prerequisiti non sono ancora verificati e non servono alla sola preparazione delle istruzioni Codex.
