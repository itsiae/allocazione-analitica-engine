# 🚀🚀🚀 Contribuire al Repository

Questa è una guida per contribuire allo sviluppo del progetto. Lo scopo è cercare di eliminare tutti i dubbi su come procedere. Se comunque hai domande o suggerimenti su come migliorare la documentazione o la repository, non esitare a contattare i responsabili del progetto.

## Codice di Condotta

Questo progetto e tutti coloro che vi partecipano sono governati dal nostro [Codice di Condotta](./CODE_OF_CONDUCT.md). Partecipando, ci si impegna a rispettare questo codice.

**TL;DR:** Sii gentile, aiuta gli altri, niente flamewar, niente leak di segreti (nemmeno per sbaglio alle 2 di notte! 🔑🚫). Nel dubbio chiedi sempre!

---

## Come posso iniziare a sviluppare?

### 👋 Onboarding e Primi Passi

1. **Richiesta Accesso**
   - Se sei un fornitore o nuovo collaboratore, chiedi di essere abilitato all'accesso su Github.
   - Per l'accesso a AWS devi essere abilitato ad Active Directory per accedere agli ambienti AWS di `dev` e `qa`

In entrambi i casi, contatta il referente del progetto per avere le credenziali necessarie.


### 👨‍💻👩‍💻 Il Tuo Primo Contributo al Codice

Per iniziare a contribuire al codice, segui questi passaggi:

1. **Clona il Repository**: Clona il tuo repository in locale per iniziare a sviluppare. Assicurati di avere i permessi utente di lettura e scrittura per il repository in questione per poter effettuare push e pull della repository. Per verificare i permessi, puoi eseguire i comandi per verificare i permessi di lettura:

   ```bash
   git clone nome-repository
   ```
   
   per i permessi di scrittura, nella repository in questione, puoi provare ad eseguire il seguente comando:

   ```bash
   git push --dry-run
   ```

   in caso di successo, il comando non restituirà errori. 
   Per poter eseguire il deployment, è necessario avere anche i permessi di scrittura dei tag. Per verificare i permessi di scrittura dei tag, puoi eseguire il seguente comando:

   ```bash
   git push --tags --dry-run
   ```

   in alternativa puoi eseguire il comando `make init`, che eseguirà l'inizializzazione della repository remota andando a inserire i tag necessari per il deployment. 
   
   Se dovessi avere problemi con i permessi, contatta l'amministratore del repository per avere i permessi necessari per eseguire le azioni sopra descritte.

2. **Crea un branch**: per lavorare a qualsiasi modifica, sia una fantastica nuova funzionalità che una correzione di un bug, è regola lavorare su un branch dedicato. Questo ti permette di lavorare in modo isolato, in tranquillità e di mantenere il branch principale, che rappresenta il codice di produzione isolato dal resto. Internamente viene adottato il seguente schema di denominazione per i branch:
   - `feature/DMNDCODICEDEMAND/nome-funzionalità`: per nuove funzionalità
   - `bugfix/DMNDCODICEDEMAND/nome-bug`: per correzioni di bug
   - `hotfix/DMNDCODICEDEMAND/nome-hotfix`: per correzioni urgenti (generalmente staccate dal branch principale)
   
   La regola generale è di utilizzare il prefisso `DMNDCODICEDEMAND` per identificare il codice della demand generata da Service Now a cui si riferisce il branch. Questo aiuta eventualmente a recuperare la modifica in caso di necessità. Se non disponibile il codice, in generale è buona norma utilizzare quella censita eventualmente su Jira. In tutti i casi, chiedere al responsabile del progetto per avere conferma della nomenclatura da utilizzare. Se esite già un branch con il codice della demand, utilizzare quello esistente per evitare conflitti e confusione.

4.  **Apporta le tue modifiche** al codice. Assicurati di seguire lo stile e le convenzioni del progetto. Cerca di mantenere il codice leggibile e commentato dove necessario. Se stai lavorando su un progetto condiviso, è importante mantenere uno stile di codice coerente. Cercare di adottare e mantenere il codice [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) fino a quanto ti è possibile.

5. **Commit delle modifiche**: Una volta che hai apportato le modifiche, è importante fare un commit con un messaggio chiaro e descrittivo. Il messaggio di commit dovrebbe spiegare cosa hai cambiato e perché. Segui le convenzioni di messaggio di commit del progetto.

   ```bash
   git add .
   git commit -m "Descrizione chiara delle modifiche"
   ```

   In generale l'idea è di cercare di adottare l'approccio delle conventional commit ove possibile. Per una breve descrizione rimandiamo alla sezione relativa a  `Messaggi di Commit`, per approfondimenti rimandiamo [qui](https://www.conventionalcommits.org/en/v1.0.0/)!

6. **Push del Branch**: Dopo aver fatto il commit delle tue modifiche, puoi pushare il tuo branch al repository remoto. 

7. **Testa le tue modifiche tramite il deploy delle pipeline**: per verificare che le tue modifiche funzionino correttamente, esegui il deploy attraverso le pipeline CI/CD di Github Action che deployano le strutture in ambiente di `dev` e `qa`. Questo ti permette di verificare e testare gli sviluppi e le modifiche su ambiente __AWS__. Per poter eseguire il deploy, è necessario avere i permessi di scrittura dei tag. Per poter eseguire la pipeline da remoto è sufficiente eseguire il push del branch su cui stai lavorando. Successivamente è sufficiente eseguire il comando:

   ```bash
   make ambiente
   ```

   Questo attiverà automaticamente le pipeline di deploy. Per la documentazione del comando `make`, puoi consultare il file `Makefile` presente nella root del repository, oppure eseguire il comando `make` o `make` help` per avere un elenco dei comandi disponibili e delle loro descrizioni.

   Qualora non si disponesse di ambiente di sviluppo unix-like e si volesse procedere manualmente, è possibile eseguire la pipeline remota pushando un tag specifico. Per farlo, è sufficiente eseguire il comando:

   ```bash
   git tag -a TAG
   git push origin TAG
   ```

   Di seguito la lista completa dei tag disponibili per il deploy:
   - `COLLAUDO`: per il deploy in ambiente di sviluppo
   - `PLAN-COLLAUDO`: per il plan in ambiente di sviluppo
   - `CERTIFICAZIONE`: per il deploy in ambiente di QA
   - `PLAN-CERTIFICAZIONE`: per il plan in ambiente di QA

   Per avere la lista completa dei tag disponibili, puoi consultare il file `Makefile` presente nella root del repository, oppure ai tag presenti nei file come [cd-terragrunt-plan-certificazione](workflows/cd-terragrunt-plan-certificazione.yml)

8. **Verifica lo stato del deploy**: Una volta che il deploy è stato completato, verifica lo stato del deploy e assicurati che tutto funzioni correttamente. Puoi farlo accedendo dal sito web di Github oppure tramite riga di comando gh e controllando lo stato delle azioni di deploy. In caso di errori, puoi consultare i log delle azioni per capire cosa è andato storto e correggere eventuali problemi.

9. **Verificare lo stato su AWS**: Una volta che il deploy è stato completato, verifica lo stato su AWS per assicurarti che tutto funzioni correttamente. Puoi farlo accedendo alla console di AWS e controllando lo stato delle risorse create dal deploy. In caso di errori, puoi consultare i log delle risorse per capire cosa è andato storto e correggere eventuali problemi.

10. **Crea una Pull Request**: Una volta che sei soddisfatto delle tue modifiche e hai testato il tuo codice, crea una pull request (PR) per il branch principale del repository. Assicurati di descrivere le modifiche apportate e di collegare eventuali issue o richieste di funzionalità correlate.

11. **Revisione del Codice**: Una volta creata la PR, il tuo codice sarà sottoposto a revisione da parte dei responsabili del progetto. Sii aperto ai feedback e pronto a fare eventuali modifiche richieste.

12. **Merge della PR**: Una volta che la PR è stata approvata, puoi procedere con il merge nel branch principale. Assicurati di risolvere eventuali conflitti prima di effettuare il merge.

13. **Elimina il Branch**: Dopo il merge, puoi eliminare il branch su cui hai lavorato per mantenere il repository pulito e ordinato.

---

## Messaggi di Commit

Per favore, cerca di seguire la specifica [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) per rendere i messaggi di commit chiari e coerenti. Questo aiuta a mantenere una cronologia dei cambiamenti leggibile e comprensibile.

Esempi:
-   `feat(scope): Aggiungi supporto per il nuovo servizio AWS SQS`
-   `fix(scope): Correggi il calcolo del nome della S3 bucket`
-   `docs(scope): Aggiorna il README con le nuove istruzioni`
-   `style(scope): Formatta il codice con terraform fmt`
-   `refactor(scope): Riorganizza la logica dei local`
-   `test(scope): Aggiungi test per il modulo vpc`
-   `chore(scope): Aggiorna le dipendenze della pipeline`

## 🏗️ Struttura del Progetto

In generale, la struttura del progetto è organizzata in modo da facilitare lo sviluppo e il deploy delle infrastrutture su AWS. La struttura segue le convenzioni di Terraform e Terragrunt, con una chiara separazione tra i moduli e le configurazioni specifiche per gli ambienti. Come naming convention, tutte le repository che presentano il nome `dataplatform-*` sono repository che sono afferenti al progetti relativi all'account `Data` di DataPlatform. Tutte le altre repository sono repository che sono afferenti all'account `Enterprise`.

## 📂 Struttura di una Repository

Ogni repository è organizzata per separare chiaramente la logica riutilizzabile (moduli) dalla configurazione specifica degli ambienti (live). Di seguito una panoramica della struttura tipica, con esempi riferiti a questa repository:

```
.
├── config.yaml                # Configurazione globale del progetto (nome repo, regioni, tag, ecc.)
├── modules/                   # Moduli Terraform riutilizzabili
│   └── example/               # Esempio di modulo (puoi avere più moduli)
│       ├── _input.tf          # Definizione delle variabili in input
│       ├── _local.tf          # Definizione di variabili locali
│       ├── _output.tf         # Output del modulo
│       ├── _data.tf           # Eventuali data source
│       └── example.tf         # Risorse principali del modulo
├── live/                      # Configurazione degli ambienti reali
│   ├── _envs/                 # Template YAML per variabili di ambiente (dev, qa, prod)
│   │   ├── dev.tmpl
│   │   ├── qa.tmpl
│   │   └── prod.tmpl
│   ├── example/               # Esempio di ambiente (puoi avere più ambienti/moduli)
│   │   └── terragrunt.hcl     # Configurazione Terragrunt per il modulo/ambiente
│   └── terragrunt.hcl         # Configurazione Terragrunt principale (include e remote state)
├── .github/                   # Workflow CI/CD, CODEOWNERS, CONTRIBUTING, CODE_OF_CONDUCT
├── Makefile                   # Comandi per pipeline CI/CD e gestione tag
└── README.md                  # Documentazione generale del progetto
```

### Dettaglio delle cartelle principali

- **modules/**  
  Contiene i moduli Terraform riutilizzabili. Ogni modulo ha i propri file di variabili, output, risorse e locals.  
  Esempio: [`modules/example/_input.tf`](modules/example/_input.tf)

- **live/**  
  Contiene la configurazione degli ambienti reali (dev, qa, prod, ecc.).  
  Ogni sottocartella rappresenta un ambiente o una componente deployata. Il nome delle variabili qui definite deve essere identico a quello definito nei moduli affinché venga iniettata la variabile.
  Esempio: [`live/example/terragrunt.hcl`](live/example/terragrunt.hcl)

- **live/_envs/**  
  Contiene i template YAML per le variabili specifiche di ogni ambiente.  
  Esempio: [`live/_envs/dev.tmpl`](live/_envs/dev.tmpl)

- **utils/**  
  Contiene script utili per la gestione del progetto, come ad esempio script per il deploy automatico delle infrastrutture.
  Esempio: [`utils/deploy.sh`](utils/deploy.sh)

- **config.yaml**  
  File di configurazione globale, usato per impostare variabili comuni a tutto il progetto (nome repository, regioni, tag, ecc.).  
  Esempio: [`config.yaml`](config.yaml)

- **Makefile**  
  Automatizza la gestione delle pipeline CI/CD tramite comandi `make`.  
  Esempio: [`Makefile`](Makefile)

- **.github/**  
  Contiene workflow GitHub Actions, file di configurazione per la community e automazioni.


## 🛠️ Setup e Sviluppo

La seguente repository è ottimizzata per essere utilizzata in ambienti UNIX-like, come Linux e macOS. Per gli utenti Windows, si consiglia caldamente di utilizzare il [Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl/install) per eseguire i comandi in un ambiente compatibile.

### Prerequisiti

Prima di iniziare a lavorare con questa repository, assicurati di avere installato gli strumenti necessari per lo sviluppo e il deploy.

Assicurati di avere installato:

-   [AWS CLI](https://aws.amazon.com/cli/)
-   `make`

Per semplicità, assicurati di avere installato anche il server Terraform per la verifica della sintassi.

### Uso del `Makefile`

Il `Makefile` è configurato per semplificare l'interazione con le pipeline di GitHub Actions. I comandi come `make dev` o `make plan_qa` non eseguono il codice localmente, ma creano e pushano un tag Git specifico che attiva la pipeline corrispondente nel repository remoto.

> Pro tip: Usa `make help` per vedere tutti i comandi disponibili.

---

## 📚 Risorse Utili

- [Guida Terragrunt](https://terragrunt.gruntwork.io/docs/)
- [Terraform Docs](https://www.terraform.io/docs/)
- [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
- [GitHub Actions](https://docs.github.com/en/actions)
- [AWS Documentation](https://docs.aws.amazon.com/)

## Cosa NON fare 🚫

- Non committare chiavi o segreti (nemmeno se sono “temporanei”)
- Non pushare direttamente su `main`
- Non ignorare i commenti in review (anche se sono solo typo!)
- Non lasciare branch zombie: elimina dopo il merge!
- Prima di eseguire il deploy in produzione, assicurati che il codice sia testato e funzionante sia in `dev` che in `qa`
- Non dimenticare di aggiornare la documentazione se necessario

---

## 📞 Contatti e Supporto

- **Canale di supporto:** Teams/email
- **Segnalazione problemi:** Scrivi al referente

---

## ❓ FAQ e Risoluzione Problemi

**Non riesco a pushare?**  
Verifica di avere i permessi. Se non li hai, contatta il referente.

**La pipeline fallisce?**  
Controlla i log su GitHub Actions. Spesso il problema è nella sintassi o nei permessi AWS.

**Non vedo le risorse su AWS?**  
Assicurati di essere nell’account e nella regione corretti. Verifica i permessi.

**Non so che branch usare?**  
Segui la convenzione `feature/DMNDxxxx/nome`, oppure chiedi conferma al referente.

---

Grazie per il tuo contributo!  
Se hai letto fino a qui, meriti un caffè pagato da parte del team di DataPlatform ☕