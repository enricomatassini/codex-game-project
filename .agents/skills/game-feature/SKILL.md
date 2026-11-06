---
name: game-feature
description: Sviluppa una funzionalità del gioco come incremento giocabile, con criteri di accettazione, verifica e passaggio di contesto. Usare per gameplay, interfaccia, progressione e salvataggi.
---

# Sviluppo di una funzionalità

## Prima di lavorare

1. Leggi `AGENTS.md`, `docs/PROJECT.md`, `docs/STATE.md` e il task in `docs/BACKLOG.md`. Consulta le decisioni pertinenti in `docs/DECISIONS.md` e il protocollo in `docs/AGENT_WORKFLOW.md`.
2. Verifica codice, strumenti e stato Git reali. Il repository può non avere ancora un motore: non trattare una proposta come una scelta approvata. Se manca una decisione indispensabile, esplicitala e completa il lavoro indipendente.
3. Definisci comportamento osservabile, criteri di accettazione, file di competenza e dipendenze. Preferisci un incremento piccolo e giocabile dal comando dell'utente al risultato visibile. Specifica cosa misurare: correttezza, fluidità o comprensibilità del feedback.

## Implementazione

- Usa il motore, le versioni e le convenzioni documentate; non introdurre un nuovo framework senza una necessità concreta.
- Integra input touch, risoluzioni e aree sicure quando la funzionalità li coinvolge. Per dati persistenti considera compatibilità del formato, interruzioni e ripresa dell'app.
- Per questo gioco 3D mobile verifica anche camera e comandi touch, collisioni, visibilità degli obiettivi e leggibilità sullo schermo piccolo. Valuta geometria, materiali, shader, luci e draw call nel budget documentato prima di aggiungere complessità grafica. Unity e Godot sono opzioni in valutazione: usa soltanto il motore scelto e registrato nel progetto.
- Mantieni la logica verificabile e separa responsabilità solo quando serve. Per casualità rilevante ai test usa seed controllabili.
- Per delegare, segui `docs/AGENT_WORKFLOW.md`: assegna un risultato e file distinti, concorda prima le interfacce, evita scritture concorrenti sugli stessi file. Il coordinatore integra e verifica il comportamento completo.
- Non aggiungere SDK di pubblicità, acquisti o analytics come conseguenza implicita di una funzionalità. Registra le decisioni di prodotto necessarie.

## Verifica e consegna

1. Esegui le verifiche pertinenti disponibili: test della logica e regressioni, importazione/build se necessari e prova del percorso giocabile. Usa la skill `mobile-qa` per cambiamenti che toccano il comportamento mobile.
2. Confronta il risultato con ogni criterio. Per misure prestazionali registra dispositivo, build, scenario, durata e campione; non generalizzare risultati desktop ai dispositivi mobili.
3. In `docs/VALIDATION.md` registra comando o procedura, esito e limiti. Distingui superato, fallito e non eseguito. Una compilazione riuscita non dimostra la giocabilità.
4. Aggiorna il task in `docs/BACKLOG.md`, lo stato e il prossimo passo in `docs/STATE.md`; aggiungi in `docs/DECISIONS.md` solo decisioni durevoli con motivazione. Se il coordinatore è l'unico autore di questi file, restituisci gli aggiornamenti nel passaggio di consegne.
5. Comunica comportamento realizzato, prove eseguite e problemi residui. Non dichiarare concluso un criterio senza evidenza.
