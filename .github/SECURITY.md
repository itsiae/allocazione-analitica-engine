# 🛡️ Security Policy

## 📌 Scopo

Questa Security Policy definisce le linee guida per garantire la sicurezza del codice e dei dati all'interno di questa repository template aziendale. L'obiettivo è assicurare che tutti i progetti derivati aderiscano alle best practice di sicurezza fin dalla loro creazione.

---

## 🔐 Accesso e Permessi

- **Repository Template**: accesso in sola lettura al gruppo `Developers`. Solo i `CODEOWNERS` definiti nel repository possono approvare modifiche.
- **Repository Derivate**: devono ereditare i permessi secondo la policy aziendale. Gli accessi privilegiati devono essere giustificati e tracciati.
- **Token/API Keys**: è vietato inserire segreti o credenziali hardcoded. Utilizzare strumenti come AWS Secrets Manager, HashiCorp Vault o le variabili d'ambiente cifrate di GitHub.

---

## 📄 Gestione del Codice

- **Revisione Obbligatoria**: ogni modifica deve essere proposta tramite Pull Request e approvata da almeno un revisore definito nel file [`CODEOWNERS`](./CODEOWNERS).
- **Scansione del Codice**:
  - Scansione statica della sicurezza del codice tramite **Qodana** come definito nel workflow [`code-scan.yaml`](./workflows/code-scan.yaml).
  - Scansione delle dipendenze tramite strumenti come `dependabot` o `snyk`.
- **Protezione Branch e Tag**: abilitare la protezione su `main` e altri branch critici. Le regole devono impedire push diretti e richiedere l'approvazione delle PR. Anche i tag usati per il deploy (es. `COLLAUDO`, `CERTIFICAZIONE`) devono essere protetti per evitare deploy non autorizzati.

---

## 📦 Gestione delle Dipendenze

- Bloccare le versioni delle dipendenze tramite `requirements.txt`, `poetry.lock`, `package-lock.json`, ecc.
- Evitare l’uso di librerie non ufficiali o abbandonate.
- Le dipendenze devono essere aggiornate periodicamente tramite strumenti automatici.

---

## 🛑 Best Practice di Sicurezza

- **No secrets nel codice**: usare il file [`.gitignore`](../.gitignore) per escludere file contenenti dati sensibili (es. `*.tfvars`).
- **Stato Terraform Sicuro**: Il remote state di Terraform deve essere sempre cifrato. La configurazione in [`live/terragrunt.hcl`](../live/terragrunt.hcl) imposta `encrypt = true` per il backend S3, e questa impostazione è obbligatoria.
- **Minimizzazione della superficie d’attacco**: esporre solo le risorse strettamente necessarie (porte, API, endpoint).
- **Audit Trail**: ogni modifica deve essere tracciabile tramite la cronologia di Git.

---

## 🧪 CI/CD

- I workflow CI/CD devono:
  - Usare secrets cifrati e accessi con privilegi minimi.
  - Non esporre output contenenti dati sensibili.
  - Eseguire test di sicurezza statici e dinamici.
- Il deploy deve avvenire solo da branch e tag approvati secondo policy.

---

## 📤 Report di Vulnerabilità

- Segnalare eventuali vulnerabilità in modo privato ai responsabili del repository definiti nel file [`CODEOWNERS`](./CODEOWNERS). Non creare issue pubbliche per problemi di sicurezza.
- Notificare immediatamente il team `Security` aziendale in caso di:
  - Violazioni dei dati
  - Esposizione accidentale di credenziali
  - Dipendenze compromesse

---

## 📅 Manutenzione del Template

- Il template viene rivisto almeno **ogni 6 mesi** per:
  - Aggiornare dipendenze e strumenti
  - Rivedere e allineare le best practice
  - Garantire la conformità con le policy aziendali e normative (es. GDPR, ISO27001)

---

> Per dubbi o suggerimenti su questa policy, contatta il team `Security` aziendale.