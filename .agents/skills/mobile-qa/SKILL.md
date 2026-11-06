---
name: mobile-qa
description: Verifica un gioco mobile con prove riproducibili di gameplay, ciclo di vita, input, accessibilità e prestazioni. Usare prima di integrare cambiamenti sensibili o preparare una versione Android e iOS.
---

# Verifica mobile

## Preparazione

Leggi `AGENTS.md`, `docs/PROJECT.md`, `docs/STATE.md`, il task in `docs/BACKLOG.md` e le scelte pertinenti in `docs/DECISIONS.md`. Segui `docs/AGENT_WORKFLOW.md` per assegnazione e consegna. Usa `docs/VALIDATION.md` come registro delle prove.

Identifica build/commit, versione del motore, piattaforma e dispositivi disponibili. Se manca un dispositivo, simulatore o toolchain, marca la prova come non eseguita e continua quelle possibili. Definisci una matrice proporzionata al cambiamento usando i requisiti del progetto; non inventare soglie prestazionali già approvate.

## Prove pertinenti

- **Percorso di gioco:** avvio, ingresso in partita, input, obiettivo, vittoria/sconfitta e ripetizione. Verifica regressioni nel percorso modificato e comportamento senza rete se supportato.
- **Ciclo di vita:** sospensione e ripresa, perdita del focus, interruzione audio, chiusura del processo e nuovo avvio. Verifica che progressi, timer e audio rispettino il comportamento previsto.
- **Dati:** primo avvio, salvataggio/caricamento, aggiornamento da una versione supportata e gestione di dati mancanti o corrotti se pertinente. Non cancellare dati reali: usa profili di prova.
- **Schermo e input:** touch singolo e multiplo quando previsto, bersagli raggiungibili, proporzioni, orientamenti supportati, notch e aree sicure. Controlla localizzazione e testi lunghi se presenti.
- **Accessibilità:** leggibilità, contrasto, significato non affidato al solo colore, controlli audio, movimento e vibrazione secondo le opzioni previste. Prova le tecnologie assistive effettivamente supportate senza attribuire compatibilità non verificata.
- **Prestazioni:** misura tempo dei frame e picchi, memoria, caricamento e stabilità in uno scenario ripetibile. Confronta con i budget documentati e con una baseline comparabile. Calore e consumo richiedono prove su hardware reale.
- **3D mobile:** prova controllo della camera, occlusioni e collisioni nel gameplay. Registra draw call, geometria visibile, memoria di texture e mesh quando misurabili; controlla shader, illuminazione e compatibilità grafica sul dispositivo target. Per sessioni prolungate misura cali di prestazioni e pressione termica; una scena fluida sul desktop non stabilisce il budget mobile.
- **Servizi e acquisti:** solo se presenti, usa sandbox/test account e verifica indisponibilità, errori, ripristino e gestione delle interruzioni. Non eseguire acquisti reali o operazioni distruttive per una verifica ordinaria.

Non eseguire tutta la matrice per ogni modifica: seleziona rischi e piattaforme interessati. Per una candidata alla pubblicazione, copri il percorso principale su Android e iOS e identifica esplicitamente le prove ancora mancanti.

## Evidenze e passaggio di consegne

Per ogni prova registra data, identificatore build/commit, ambiente, prerequisiti, passi, risultato atteso, risultato osservato ed esito in `docs/VALIDATION.md`. Collega log o artefatti privi di segreti e dati personali. Distingui dispositivo fisico, emulatore, simulatore e desktop.

Per un difetto fornisci riproduzione minima, frequenza e impatto; crea un task in `docs/BACKLOG.md` e aggiorna `docs/STATE.md` secondo la titolarità dei file assegnata dal coordinatore. Non modificare i criteri per far risultare superata una prova. Una porta aperta, un processo vivo o zero test eseguiti non dimostrano il funzionamento.
