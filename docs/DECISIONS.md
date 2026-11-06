# Registro decisioni

## D001 — Target 3D mobile
Data: 2026-11-04. Stato: accettata dall'utente.

Realizzare un gioco 3D per App Store e Play Store. Motore non ancora scelto.

## D002 — Contesto nel repository e coordinamento centrale
Data: 2026-11-04. Stato: impostazione operativa per la richiesta dell'utente.

Usare AGENTS.md, documenti brevi e skills locali. Un coordinatore integra il lavoro; gli agenti ricevono ambiti di scrittura distinti. Il contesto sopravvive alla chat se i file vengono conservati in Git o nello snapshot dell'ambiente.

## D003 — Definire il gioco prima del motore
Data: 2026-11-04. Stato: accettata dall'utente.

Rinviare la scelta tra Godot e Unity fino alla definizione del concept. Preparare ora le istruzioni e le skills comuni; installare la toolchain specifica dopo la scelta.

## D004 — Riferimento acrobatico e priorità della fisica
Data: 2026-11-04. Stato: requisito dell'utente.

Il gioco deve richiamare i riferimenti forniti: tavolo sopra i piedi, caduta sotto gravità, semplicità e fluidità. Specifica in `docs/GAME_DESIGN.md`. Analizzati sette screenshot; il video YouTube non è accessibile attraverso il proxy e non è stato visionato. I controlli a due zone, il punteggio e la raccomandazione Godot sono proposte, non nuove scelte dell'utente.

## D005 — Video acquisito: includere sostegno e ricezione progressiva
Data: 2026-11-04. Stato: aggiornamento tecnico verificato sul riferimento, non scelta definitiva dei controlli.

L'allegato MP4 dell'utente è stato acquisito e analizzato temporalmente. Supera il limite di accesso descritto in D004. La routine include sostegno, spinta, volo, ricezione progressiva e riassetto; il primo prototipo deve rappresentare queste fasi. Le manovre su un piede e di taglio sono incrementi successivi proposti. Nessun motore è stato ancora scelto e nessuna build è stata eseguita. Evidenze e incertezze in `docs/VIDEO_ANALYSIS.md`.

## D006 — Godot 4.6.3 e prototipo assistito
Data: 2026-11-06. Stato: scelta implementativa per proseguire il lavoro autorizzato.

Dopo il concept e la raccomandazione Godot, l'utente ha chiesto di continuare. Usata la versione 4.6.3 già presente nell'ambiente, fissata in `.godot-version`; nessun nuovo motore o SDK esterno installato. Il primo prototipo valida il ciclo fisico con ricezione assistita. Le spinte derivano dai collider dei piedi e dal solver; la rotazione in volo non è pilotata dallo script. Controllo temporizzato e acrobazie complesse restano incrementi successivi. Nessuna compatibilità o prestazione nativa mobile ancora dichiarata.

## Modello per le prossime decisioni
ID, data, stato (proposta/accettata/superata), problema, opzioni, scelta, motivazione, conseguenze e verifiche. Non riscrivere una scelta passata: aggiungere la decisione che la supera.
