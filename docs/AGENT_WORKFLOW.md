# Coordinamento degli agenti

## Ruoli, attivati solo quando servono
- **Coordinatore:** legge il contesto, definisce accettazione, dipendenze e ambiti, integra e verifica, aggiorna i documenti condivisi.
- **Gameplay:** implementa la meccanica assegnata e controlli pertinenti.
- **Interfaccia e contenuti:** UI touch, feedback, asset e accessibilità, su file assegnati.
- **QA/revisore:** verifica comportamento e regressioni; preferibilmente lavora in sola lettura sui file dell'implementatore.
- **Build/release:** toolchain ed esportazione per piattaforma, quando richiesto.

Sono incarichi per gli strumenti di delega disponibili, non processi permanenti. Per attività piccole è sufficiente il coordinatore.

## Contratto di delega
Ogni incarico deve includere:
1. Obiettivo e criteri di accettazione osservabili.
2. Contesto minimo, decisioni applicabili e file da leggere.
3. File o directory modificabili in esclusiva e interfacce concordate.
4. Dipendenze, verifiche da eseguire e condizioni per fermarsi e segnalare un blocco.
5. Rapporto finale con file modificati, risultati dei comandi, limiti e suggerimenti di integrazione.

## Concorrenza
Gli agenti condividono lo stesso filesystem. Assegnare un solo autore per file. Manifest, lockfile, scene condivise e documenti di stato hanno un responsabile unico. Coordinare prima modifiche trasversali; non annullare lavoro altrui. Non eseguire installazioni/importazioni concorrenti sullo stesso progetto. Non creare worktree salvo richiesta dell'utente.

Delegare in parallelo solo attività indipendenti. Usare inizialmente al massimo tre agenti di supporto; non creare ulteriori agenti senza accordo con il coordinatore. Se la piattaforma non supporta delega, svolgere gli stessi incarichi in sequenza e dichiararlo.

## Integrazione e chiusura
Il coordinatore legge i rapporti e le modifiche, risolve conflitti, esegue la verifica integrata necessaria e aggiorna STATE/BACKLOG/VALIDATION. Nei lavori lunghi registra in STATE incarichi attivi, responsabili, file assegnati e risultati ancora da integrare; in una nuova sessione non presumere che i processi degli agenti siano sopravvissuti. Il successo dichiarato da un agente non sostituisce le evidenze. Una revisione non eseguita non va indicata come completata.
