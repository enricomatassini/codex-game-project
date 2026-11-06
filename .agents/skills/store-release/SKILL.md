---
name: store-release
description: Prepara una candidata alla distribuzione su App Store e Google Play con build, firma, metadati e verifiche documentate. Usare per pianificare o eseguire una release mobile; la pubblicazione richiede un'istruzione esplicita.
---

# Preparazione della release mobile

## Contesto e requisiti

Leggi `AGENTS.md`, `docs/PROJECT.md`, `docs/STATE.md`, `docs/BACKLOG.md`, le decisioni pertinenti in `docs/DECISIONS.md`, `docs/VALIDATION.md` e `docs/AGENT_WORKFLOW.md`. Identifica versione, commit, motore, bundle/application ID e piattaforme previste. Non inventare identificatori, titolarità degli account o certificazioni completate.

Verifica le regole correnti sulle fonti ufficiali prima di fissare requisiti di SDK, API target, formati, privacy e distribuzione. Registra URL e data di consultazione. Punti di partenza: `https://developer.apple.com/app-store/review/guidelines/`, `https://developer.apple.com/help/app-store-connect/`, `https://support.google.com/googleplay/android-developer/` e `https://developer.android.com/distribute`. Se non sono accessibili, esplicita che i requisiti correnti non sono verificati.

## Toolchain e firma

- **iOS:** prepara il progetto/export supportato dal motore; compilazione, archivio e firma richiedono un ambiente macOS con Xcode compatibile, certificati/profili appropriati e accesso Apple Developer/App Store Connect. Un ambiente Linux può eseguire lavoro condiviso e alcune verifiche, ma non sostituisce questa validazione. Un simulatore non prova la build firmata su dispositivo.
- **Android:** verifica toolchain del motore, JDK, Android SDK/build tools e formato di distribuzione richiesto (normalmente AAB per Play). Usa identità di firma/upload e Play App Signing secondo la configurazione del progetto. Conserva i materiali di firma nei servizi sicuri previsti.
- Ispeziona solo nomi e disponibilità delle credenziali già configurate. Non stamparle, non inserirle nel repository o nei documenti e non richiederle in chat. Elenca soltanto i prerequisiti effettivamente mancanti e dove configurarli in modo sicuro.
- Blocca versioni e registra comandi riproducibili. Non considerare un export generato equivalente a build installata, firmata o accettata dallo store.

## Candidata alla distribuzione

1. Verifica versione/build number, icone, schermate, descrizioni, supporto e URL privacy dove richiesti. Usa contenuti coerenti con il gioco reale e asset con licenze documentate.
2. Confronta SDK e comportamenti effettivi con dichiarazioni privacy/Data safety, permessi e classificazione per età. Se il progetto include pubblicità, minori, acquisti o account, verifica i relativi requisiti applicabili; non dichiarare conformità senza evidenza.
3. Esegui le prove pertinenti della skill `mobile-qa`, incluse installazione/aggiornamento, avvio della build candidata e percorso principale sui target disponibili. Registra tutte le verifiche non eseguite.
4. Prepara artefatti e una nota di rilascio con commit, versioni toolchain, identificatore build, verifiche, problemi noti e percorso degli artefatti. Controlla che siano della candidata corrente.
5. Se richiesto, prepara il canale di test appropriato (TestFlight o traccia di test Play). Upload, inviti e pubblicazione sono azioni esterne: eseguili solo nel perimetro esplicitamente autorizzato dall'utente. La richiesta di preparare una release non autorizza automaticamente la pubblicazione in produzione.

## Stato finale

Aggiorna `docs/VALIDATION.md`, `docs/STATE.md` e i task in `docs/BACKLOG.md`, oppure consegna gli aggiornamenti al coordinatore se ne detiene la scrittura. Separa questi stati: preparazione completata, build generata, firma verificata, prova su dispositivo superata, upload completato, revisione approvata, pubblicazione effettuata. Non inferire uno stato dal precedente e non promettere l'approvazione degli store.
