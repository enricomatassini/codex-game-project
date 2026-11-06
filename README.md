# Sospeso — prototipo 3D mobile

Primo prototipo in **Godot 4.6.3**: sostieni un tavolo con i piedi, lancialo e accompagnane la ricaduta. Destinazioni previste: iOS e Android.

[Gioca dal telefono senza installazione](https://enricomatassini.github.io/codex-game-project/) — anteprima pubblica temporanea.

## Avvio e controlli

Apri `project.godot` con Godot 4.6.3 e premi F5. Da terminale, con Godot nel PATH e un display disponibile:

```bash
bash scripts/setup.sh
bash scripts/run-godot.sh
```

LANCIA usa entrambi i piedi; SINISTRO/DESTRO introducono una piccola asimmetria. Tastiera: Spazio per lancio bilanciato, A/D o frecce per i piedi, R per ricominciare, Esc per pausa/ripresa. La ricezione è assistita nella prima versione; tocchi durante il volo non aggiungono spinte a distanza.

## Verifica

```bash
bash scripts/check.sh
```

23 controlli fisici e 15 sulla scena completa, con profilo di salvataggio separato. Log in `build/validation/`; risultati e limiti in [VALIDATION.md](docs/VALIDATION.md). Scena e modelli sono procedurali; nessun asset del filmato viene usato dal gioco.

## Lavorare con Codex
Le istruzioni si trovano in [AGENTS.md](AGENTS.md). A ogni nuova sessione Codex deve riprendere [lo stato del progetto](docs/STATE.md) e [il backlog](docs/BACKLOG.md).

Esempi di richieste:
- «Riprendi il contesto e completa il prossimo task pronto del backlog.»
- «Usa game-feature per realizzare questa meccanica e mobile-qa per verificarla.»
- «Dividi questa funzionalità in attività indipendenti e assegna gli agenti.»
- «Prepara la release usando store-release e indica quali verifiche mancano.»

Le skills locali sono in `.agents/skills/`. Non richiedono servizi esterni. La loro presenza e queste istruzioni consentono di applicarle anche quando il client non le elenca automaticamente.

Per ambiente cloud e registrazioni vedi [DEVELOPMENT.md](docs/DEVELOPMENT.md). Grafica e ricezione assistita sono provvisorie; build e prove su telefoni reali restano da fare. Le modifiche locali devono essere salvate in Git o nello snapshot dell'ambiente per essere conservate fuori da questa macchina.
