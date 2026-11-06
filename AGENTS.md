# Istruzioni di progetto per Codex

## Obiettivo e avvio
Gioco **3D mobile** destinato a iOS/App Store e Android/Google Play. Comunica in italiano. Il primo prototipo usa **Godot 4.6.3**, versione fissata in `.godot-version`; segui i comandi verificati in `docs/DEVELOPMENT.md`.

All'inizio di ogni sessione leggi `docs/PROJECT.md`, `docs/STATE.md` e `docs/BACKLOG.md`; consulta `docs/DECISIONS.md` e `docs/VALIDATION.md` per le decisioni e le verifiche pertinenti. Controlla `git status --short` prima di modificare file. Usa il checkout esistente: le attività cloud sono già isolate; non creare worktree salvo richiesta esplicita.

## Contesto persistente
- I file del repository sono il punto di ripresa tra sessioni, non la memoria della chat.
- Aggiorna `docs/STATE.md` al termine di un'attività significativa o prima di un passaggio di consegne: risultato, file, verifiche realmente eseguite, problemi, prossimo passo concreto.
- Registra in `docs/DECISIONS.md` decisioni accettate e motivazione; distingui proposte e fatti. Non trasformare una preferenza non confermata in un requisito.
- Mantieni il backlog breve, con criteri di accettazione e dipendenze. Non duplicare il contenuto in molti documenti.
- Non salvare segreti, token, certificati o dati personali nei documenti, nei prompt o nel repository.

## Skills del progetto
Leggi la skill pertinente prima di applicarla:
- `.agents/skills/project-context/SKILL.md`: ripresa, aggiornamento del contesto e handoff.
- `.agents/skills/game-feature/SKILL.md`: progettazione e implementazione incrementale di funzionalità.
- `.agents/skills/mobile-qa/SKILL.md`: verifica funzionale, lifecycle e prestazioni mobile.
- `.agents/skills/store-release/SKILL.md`: preparazione e verifica delle release Android/iOS.

Le skills sono procedure, non plugin né strumenti installati. Se il runtime non le mostra nel catalogo, apri il relativo `SKILL.md` e seguilo esplicitamente. Per un task semplice usa soltanto quanto serve.

## Agenti
L'utente autorizza la suddivisione del lavoro tra agenti. Segui `docs/AGENT_WORKFLOW.md`. Il coordinatore resta responsabile dell'integrazione e delle verifiche. Delega solo lavoro indipendente e utile; usa inizialmente al massimo tre agenti di supporto contemporanei, adattandoti ai limiti del runtime. Non configurare modelli o opzioni sperimentali non verificati.

## Sviluppo e validazione
- Prima una piccola esperienza giocabile dall'inizio alla fine; poi estendere il progetto.
- Usa versioni fissate del motore e dipendenze quando scelte. Conserva lockfile, metadati e file di importazione richiesti dal motore.
- Privilegia controlli touch, safe area, sospensione/ripresa, salvataggi affidabili e prestazioni su dispositivi reali. Concorda budget di frame time e memoria in base ai dispositivi target.
- Valida il comportamento cambiato con test o smoke test significativi; non dichiarare una build o una piattaforma verificata se non è stata eseguita.
- Documenta sorgente e licenza degli asset e degli SDK prima di integrarli.
- Le build iOS definitive richiedono macOS/Xcode, provisioning e firma; questo ambiente Linux non le convalida. Non pubblicare sugli store senza un incarico esplicito.

## Verifiche del prototipo
Usa `bash scripts/check.sh`: testa fisica e scena integrata con profilo isolato dal record del giocatore. La grafica si verifica con un display reale o virtuale; il renderer headless non dimostra la resa visiva. Non inventare comandi di export: Android/iOS non sono ancora validati.
