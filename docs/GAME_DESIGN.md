# Gioco di palleggio acrobatico con un tavolo

Data: 2026-11-04. Concept aggiornato dopo l'analisi del video allegato; nessun prototipo implementato.

## Fonti e limiti dell'analisi

- Video di riferimento richiesto su YouTube e poi fornito come allegato MP4: **ora acquisito, decodificato e analizzato tramite fotogrammi con timestamp**. Durata circa 34,83 s; dettagli, metodo e misure in `docs/VIDEO_ANALYSIS.md`. I precedenti problemi di rete non bloccano più questa analisi.
- Sette screenshot allegati in chat, numerati qui nell'ordine di invio. Esaminati visivamente. Gli originali non sono presenti come file nel checkout.
- Gli screenshot 1–5 mostrano pantaloni chiari; 6–7 pantaloni fucsia, cielo e vegetazione diversi. Non considerarli una singola sequenza continua o fotogrammi sicuramente provenienti dal link YouTube.
- Le immagini consentono di studiare inquadratura, geometria e pose. Non permettono di misurare durata del volo, velocità, verso di rotazione, massa, gravità effettiva o eventuale rallentamento del filmato. Gli orari del telefono non sono timecode video.
- Il video allegato mostra pantaloni gialli: è una ripresa distinta dagli screenshot. I suoi timestamp si applicano soltanto al file analizzato. I tempi di contatto sono intervalli visivi, non misure di forza o ricostruzioni 3D calibrate.

## Correzione dopo l'analisi del movimento

La routine comprende **sostegno → preparazione → spinta → volo → ricezione → riassetto**, con possibili ritorni al sostegno senza rilancio. Nel primo lancio il distacco cade circa a 0,77–0,83 s, il recupero comincia circa a 1,30–1,37 s e la ricezione a due piedi è evidente entro 1,40–1,44 s. Le gambe continuano ad accompagnare il tavolo verso la camera fino a circa 1,9 s. Il volo libero di questo esempio è dell'ordine di mezzo secondo.

Il tratto circa 20,4–22,6 s mostra controllo prevalentemente su un piede; circa 25–32,4 s mostra il tavolo di taglio con piccoli riassetti. Non simulare questi tratti come una serie uniforme di rimbalzi. Il video termina con un appoggio controllato: il fallimento rimane una regola di gioco proposta, non un evento osservato.

## Requisiti espressi dall'utente

Riprodurre in 3D mobile l'esperienza mostrata: tavolo sopra i piedi, attenzione al modo in cui cade e alla gravità, gioco semplice e fluido. Restano validi i target App Store e Google Play.

## Dettagli visivi osservabili

| Riferimento | Cosa si vede | Conseguenza per il progetto |
|---|---|---|
| 1 | Piano rosso con decoro dorato rivolto alla camera; piedi separati dal tavolo nella proiezione | Rendere leggibile la distanza fra piedi e oggetto durante il volo |
| 2 | Scarpe apparentemente appoggiate al piano decorato; due gambe del tavolo sporgono oltre il bordo lontano | Il piano può essere rivolto verso il giocatore, con le gambe del tavolo oltre di esso; curare il contatto visivo |
| 3 | Sottostruttura del tavolo, traverse, fascia perimetrale e gambe; piedi ad altezze diverse | Modellare entrambi i lati; consentire pose asimmetriche dei piedi |
| 4 | Tavolo separato dai piedi, con quattro gambe visibili; ginocchia raccolte in basso | Distinguere preparazione dei piedi e oggetto in volo; la camera non deve inseguire ogni oscillazione |
| 5 | Tavolo quasi di taglio, gambe proiettate lateralmente | Servono ribaltamenti su assi orizzontali, non soltanto una rotazione piatta sullo schermo |
| 6–7 | Altre pose vicino ai piedi, vista del bordo e del piano decorato | La leggibilità del contatto resta centrale anche quando l'oggetto occupa gran parte dello schermo |

Le sovrapposizioni fra scarpe e tavolo sono indizi di contatto, non prova della forza o dell'istante dell'urto.

Composizione proposta fedele ai riferimenti: schermo verticale, visuale in prima persona da posizione supina verso il cielo, gambe nella parte bassa, tavolo protagonista al centro e vegetazione ai margini. Camera prevalentemente stabile. Tavolo rigido a piano quadrato, fascia sottostante, quattro gambe sottili a sezione quadrata e rinforzi; superficie rossa con decorazione dorata originale. Scarpe chiare e pantaloni morbidi come riferimento di silhouette. UI social, nomi account e notifiche appartengono alla registrazione e non al gioco.

## Caduta e rotazione: comportamento da ottenere

### Profondità e prospettiva

La camera guarda verso l'alto: la gravità porta il tavolo verso i piedi e verso la camera. La caduta non coincide necessariamente con un moto verso il basso dello schermo. L'oggetto deve soprattutto avvicinarsi e crescere nell'inquadratura, con spostamenti laterali e orientamento indipendenti. L'apparente larghezza dipende sia dalla distanza sia dall'inclinazione: da sola non misura l'altezza.

Scegliere il campo visivo insieme a distanza camera-piedi, dimensioni del tavolo e altezza del lancio. Un campo visivo troppo ampio o un lancio troppo alto fa sparire l'oggetto; troppo stretto taglia continuamente le gambe. Nessun valore di FOV è stato misurato dalle immagini.

### Volo libero

- Tavolo come unico corpo rigido, soggetto a gravità in coordinate del mondo. Massa, centro di massa e inerzia devono rappresentare piano, fascia e gambe, non un cubo uniforme o il pivot grafico.
- In fase iniziale usare metri e secondi, con `g = 9,81 m/s²` come riferimento fisico; è una scelta di simulazione, non una misura del video. Calibrare prima scala e impulso di lancio.
- Dopo un impulso verso l'alto, la velocità verticale diminuisce, si annulla all'apice e cresce in discesa. L'apice è continuo: niente sosta artificiale né curva di animazione ripetuta. La velocità laterale e la rotazione possono continuare anche all'apice.
- Senza contatto, la gravità uniforme non genera una coppia attorno al centro di massa. Il ribaltamento nasce dal colpo fuori centro e dall'inerzia. Non ruotare il tavolo automaticamente in proporzione alla sua quota o invertirne la rotazione quando comincia a scendere.
- Con damping trascurabile, conservare il momento angolare durante il volo; per un corpo asimmetrico questo non significa imporre una velocità angolare costante su tutti gli assi.
- Evitare centratura magnetica o raddrizzamento in aria. Eventuali aiuti al giocatore devono essere limitati e documentati, preferibilmente applicati al posizionamento del piede prima del contatto.

### Contatto con i piedi

Distinguere preparazione, ricezione con flessione, sostegno/riassetto ed eventuale estensione di rilancio. Una ricezione non deve generare automaticamente una nuova spinta. La gamba segue il punto di appoggio con animazione o IK; il tavolo resta un corpo dinamico governato dalla fisica, anche quando sostenuto.

Durante l'appoggio i piedi esercitano reazioni e forze limitate, possono compensare o modificare l'orientamento e accompagnare la decelerazione. La regola della gravità uniforme senza coppia attorno al centro di massa vale per il volo isolato; non elimina la dinamica di ribaltamento rispetto a un punto di appoggio.

Un impulso `J` al punto di contatto modifica la velocità del centro di massa di `J / m`. Il suo braccio rispetto al centro di massa produce una variazione del momento angolare `ΔL = r × J`:
- Due appoggi simmetrici e ben sincronizzati possono rilanciare il tavolo con poca rotazione.
- Un piede solo o un colpo vicino al bordo può produrre un ribaltamento.
- Per rallentare una rotazione occorre un contatto che generi una coppia opposta; non basta azzerarla nello script.

Il gesto visibile e l'effetto fisico devono avvenire nello stesso momento. Non applicare un calcio mentre la scarpa è ancora distante. Non sommare un grande rimbalzo elastico automatico e un impulso manuale duplicato. Ogni pressione genera al massimo un gesto; tenere premuto non deve iniettare energia a ogni frame.

Geometrie di collisione semplici e composte per piano, fascia e gambe, evitando una scatola piena che chiuda gli spazi vuoti. Controllare compenetrazioni, contatti multipli instabili e collisioni continue/swept dove necessarie; verificare separatamente i movimenti rotazionali veloci perché il solo CCD traslazionale può non bastare. La resa dei tessuti può essere animata: simulazione cloth non necessaria al primo prototipo.

## Primo gameplay proposto, da provare

**Obiettivo:** controllare il tavolo con i piedi, concatenando sostegni e rilanci. Sessioni brevi e riavvio immediato. La prima prova deve già includere una ricezione che torna in equilibrio, prima di aggiungere trick.

1. Si parte con il tavolo appoggiato in modo stabile ai piedi; primo tocco avvia il lancio.
2. Due grandi zone touch nella parte bassa: sinistra per il piede sinistro, destra per il destro. Tocco quasi simultaneo per una spinta bilanciata. Il posizionamento dei piedi e la ricezione sono assistiti entro la loro portata e soltanto in prossimità di un contatto reale; il giocatore gestisce soprattutto il tempo del gesto. Nessun comando aggiuntivo richiesto per ogni fase interna della gamba.
3. Colpi asimmetrici permettono rotazioni. Inizialmente nessun joystick, controllo della camera o menu durante la partita. Valutare swipe e trick solo dopo aver verificato il gesto base.
4. Punteggio per rilanci effettivamente riusciti, non per numero di tocchi. Un contatto passivo o lo stesso gesto non incrementano più volte il contatore. Combo di ribaltamenti in una fase successiva.
5. Se il tavolo supera la zona recuperabile senza appoggio, la partita termina; un tocco ricomincia. Tolleranza iniziale generosa, senza teletrasportare il tavolo. Evitare di farlo attraversare la camera prima di mostrare l'esito.

Questi controlli, punteggio e regole di fine partita sono proposte di design, non caratteristiche misurate dal filmato né già approvate dall'utente. Se il controllo separato dei piedi è troppo difficile, confrontarlo in playtest con un unico tocco per il rilancio bilanciato.

## Fluidità e resa mobile

- Obiettivo iniziale proposto: 60 fps stabili sui dispositivi target da definire, non una promessa già verificata. Budget teorico di frame: circa 16,7 ms.
- Simulazione a passo fisso e rendering interpolato; campionare l'input senza dipendere dal numero di frame. Valutare 60 Hz come punto di partenza della fisica e aumentare substep/frequenza solo se i test sui contatti lo richiedono e il budget lo permette.
- Una scena contenuta, un corpo dinamico principale, piedi controllati, collisioni semplici e pochi materiali. Cielo e alberi devono dare profondità senza competere con il tavolo.
- Luci/ombre mobili solo dove aiutano forma e distanza. Il lato rivolto alla camera deve restare leggibile; materiale rosso con riflessi moderati, evitando superfici indistinguibili quando il tavolo ruota.
- Feedback breve al contatto: suono coerente con il tavolo e vibrazione opzionale. Evitare camera shake continuo e motion blur forte che nascondano il timing.
- Sospensione/ripresa senza accumulare un grande delta di simulazione e senza calci involontari. Verificare safe area e zone touch con entrambe le mani.

## Piano di verifica del prototipo — non ancora eseguito

| Prova | Cosa verificare |
|---|---|
| Caduta senza contatti da quota nota | Con damping nullo, traiettoria coerente con `h(t) = h0 − g t² / 2`; nessuna rotazione introdotta partendo da fermo |
| Lancio verticale | Altezza e tempo dell'apice coerenti con impulso/massa; velocità verticale continua nel cambio salita/discesa |
| Impulso centrato e fuori centro | Il primo non introduce coppia; il secondo produce variazione di momento angolare nel verso previsto |
| Contatto piede-tavolo | Scarpe allineate al contatto, nessun impulso remoto o ripetuto; niente attraversamento di piano o gambe |
| Ricezione e sostegno | Flessione distribuita su più tick, decelerazione e appoggio stabile possibile senza rilancio obbligato; nessun aggancio rigido artificiale |
| Rilanci ripetuti | Energia limitata dalle spinte previste, senza crescita incontrollata dovuta a contatti duplicati; altezza recuperabile |
| Piano, bordo e gamba del tavolo | Collisioni realmente diverse e nessun aggancio a volumi invisibili dentro il tavolo |
| Rendering a 30/60/120 fps con stesso tick fisico | Stessi input agli stessi tick producono traiettorie comparabili entro tolleranza misurata; nessuna promessa di determinismo bit-a-bit fra piattaforme |
| Telecamera dal basso | Il tavolo in avvicinamento cresce prospetticamente, non viene ridimensionato artificialmente; bordo e piedi rimangono leggibili |
| Playtest breve su telefono | Primo rilancio comprensibile, controllo del timing e riavvio semplice; misurare latenza e difficoltà, non solo fps |
| Sessione prolungata su dispositivo | Registrare tempi frame/picchi, memoria e comportamento termico; separare risultati Android e iOS |

Il video è ora analizzato: usare le finestre e i frame di `docs/VIDEO_ANALYSIS.md` per confrontare il primo prototipo. La massima distanza apparente non è una misura certa dell'apice del centro di massa. Massa e distanze assolute non sono ricavabili univocamente dal filmato monoculare senza scala nota; mantenere le stime distinte dai parametri scelti per il gameplay.

## Motore e suddivisione del primo lavoro

Il primo prototipo usa ora **Godot 4.6.3**, già presente nell'ambiente, con renderer Compatibility e fisica GodotPhysics3D. Implementati ciclo a due piedi, piccola asimmetria, ricezione assistita, contatore e riavvio. Evidenze e limiti in `docs/VALIDATION.md`. Le proposte non implementate sopra restano obiettivi, non caratteristiche già disponibili.

Dopo la scelta:
1. Coordinatore: scena minima, convenzioni di scala/assi, interfaccia dei piedi e integrazione.
2. Agente fisica: tavolo, centro di massa/inerzia, contatti e prove numeriche, con file di competenza esclusivi.
3. Agente visuale/input: modello provvisorio, camera, animazione delle gambe e touch, su file separati e interfacce concordate.
4. Agente QA: riproduzione dei casi e revisione; test sul dispositivo disponibile. Le verifiche integrate restano del coordinatore.

Prima verificare lancio e ricaduta con geometrie semplici; poi migliorare modello, materiali e decorazione. Non è necessario introdurre multiplayer, backend, pubblicità o acquisti per validare questo concept.
