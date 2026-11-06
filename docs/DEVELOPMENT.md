# Sviluppo del prototipo

Verificato il 2026-11-06 su Linux x86_64. Godot **4.6.3.stable.official.7d41c59c4** è già disponibile in `/usr/local/bin/godot`, collegato al runtime `/opt/godot/4.6.3/`. Non sono stati necessari nuovi download o dipendenze del gioco.

## Preparazione e avvio

Directory: `/workspace/codex-game-project`.

```bash
bash scripts/setup.sh
bash scripts/run-godot.sh
```

`setup.sh` controlla la versione e importa il progetto. `run-godot.sh` imposta dati, cache e configurazione sotto `.cache/`, senza dipendere da una HOME scrivibile. `SOSPESO_CACHE_ROOT` seleziona un profilo separato. Per aprire l'editor: `bash scripts/run-godot.sh --editor`.

Scena principale `scenes/main.tscn`; renderer Compatibility/OpenGL, GodotPhysics3D a 60 tick/s e interpolazione. Il record locale è in `user://progress.cfg`; nessun servizio remoto richiesto.

## Controlli e verifiche

Touch/mouse: LANCIA, SINISTRO/DESTRO, pausa e riprova. Tastiera: Spazio, A/D o frecce, R, Esc. La ricezione è assistita; tocchi durante il volo non aggiungono energia.

```bash
bash scripts/check.sh
```

23 controlli fisici e 15 sulla scena completa. Il runner crea e rimuove un profilo QA temporaneo, conserva log in `build/validation/` e controlla errori/exit status/test non vuoti. L'integrazione inoltra eventi touch al viewport: non sostituisce la prova su telefono. Non eseguire importazioni concorrenti.

## Display nel cloud

I test headless non richiedono display. Per la grafica usare il display disponibile. Nella macchina corrente è stato avviato Xorg dummy su `:98`. In una nuova sessione, se manca un display, verificare che :98 sia libero e avviare in un terminale separato:

```bash
mkdir -p /tmp/.X11-unix
/usr/lib/xorg/Xorg :98 -config /workspace/codex-game-project/config/virtual-display.conf -logfile /tmp/sospeso-Xorg.log -noreset -nolisten tcp
```

Tenere il processo attivo. Se il sandbox impedisce socket locali, usare l'esecuzione consentita dal runtime; non cambiare rete o credenziali per questo problema. Non presumere che il processo sopravviva allo snapshot.

Cattura e registrazione verificate:

```bash
mkdir -p build
DISPLAY=:98 LIBGL_ALWAYS_SOFTWARE=1 bash scripts/run-godot.sh --audio-driver Dummy -- --capture=/workspace/codex-game-project/build/prototype.png
DISPLAY=:98 LIBGL_ALWAYS_SOFTWARE=1 SOSPESO_CACHE_ROOT=/workspace/codex-game-project/.cache/record bash scripts/run-godot.sh --audio-driver Dummy --write-movie /workspace/codex-game-project/build/demo.avi --fixed-fps 60 --quit-after 300 -- --demo
ffmpeg -hide_banner -loglevel error -y -i build/demo.avi -c:v libx264 -crf 22 -pix_fmt yuv420p -movflags +faststart build/sospeso-demo.mp4
```

La demo offline di 5 s è pilotata automaticamente; non dimostra 60 fps reali su dispositivo. Grafica e ricezione assistita sono provvisorie; difficoltà basata sul tempismo da sviluppare.

## Componenti e limiti

- `scripts/table_rig.gd`: tavolo dinamico e piedi cinematici; le spinte derivano dal solver di contatto, senza impulsi a distanza. Velocità/accelerazione dei piedi limitate; nessun limite in newton imposto o misurato alla reazione del solver.
- `scripts/world_visuals.gd`: modelli e decoro originali procedurali, gambe IK, cielo e vegetazione. Nessun asset esterno aggiunto; font incluso in Godot.
- `scripts/game_ui.gd` e `scripts/main.gd`: input, HUD, record e pausa. Sospensione gestita nell'app ma ancora da provare sul lifecycle mobile.
- `docs/` è escluso dall'importazione Godot tramite `.gdignore`. `build/` e `.cache/` sono output locali ignorati da Git.

Nessun APK/AAB o archivio iOS generato. Export template, JDK/SDK Android, firma e telefoni vanno configurati nella prossima fase; iOS richiede macOS/Xcode e provisioning. I test desktop non stabiliscono prontezza per gli store.
