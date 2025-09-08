# Makefile per esecuzione pipeline CI da remoto su Github

# makefile vars

# github vars
GIT_REMOTE_URL := $(shell git config --get remote.origin.url)
GIT_HTTPS_URL := $(shell echo $(GIT_REMOTE_URL) | sed -E 's|^git@github.com:|https://github.com/|' | sed -E 's|\.git$$||')
GITHUB_WORKFLOW := "$(GIT_HTTPS_URL)/actions"
GIT_REMOTE := origin
CURRENT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)

# tags definitions
TAG_DEV_PLAN := rc-PLAN-COLLAUDO
TAG_QA_PLAN := rc-PLAN-CERTIFICAZIONE
TAG_DEV := rc-COLLAUDO
TAG_QA := rc-CERTIFICAZIONE
TAG_MAIN := rc-main

INIT_TAGS := $(TAG_DEV_PLAN) $(TAG_QA_PLAN) $(TAG_DEV) $(TAG_QA) $(TAG_MAIN)

# colors
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m

# main
.PHONY: help dev qa prod plan_dev plan_qa plan_prod init
.DEFAULT_GOAL := help

help:
	@echo "Makefile per esecuzione della pipeline di Continuous Integration e Deployment (CI/CD) da remoto!"
	@echo ""
	@echo "How it works: crea e pusha il tag nella repository remota di riferimento, senza dover eseguire..."
	@echo "       ...ogni volta il comando a mano facendo partire la pipeline Terraform da remoto!"
	@echo ""
	@echo "Comandi disponibili:"
	@echo "  make init: inizializza tutti i tag per la pipeline di CI/CD, pushando tutti i tag necessari nella repository remota"
	@echo "  make dev: esegue la pipeline di CI/CD per ambiente di DEV per deploy terraform, pushando il tag $(TAG_DEV:rc-%=%)"
	@echo "  make qa: esegue la pipeline di CI/CD per ambiente di QA per deploy terraform, pushando il tag $(TAG_QA:rc-%=%)"
	@echo "  make plan_dev: esegue la pipeline di CI/CD per ambiente di DEV per piano terraform, pushando il tag $(TAG_DEV_PLAN:rc-%=%)"
	@echo "  make plan_qa: esegue la pipeline di CI/CD per ambiente di QA per piano terraform, pushando il tag $(TAG_QA_PLAN:rc-%=%)"
	@echo "  make help: mostra questo messaggio di aiuto!"
	@echo ""
	@echo "Current Branch: $(CURRENT_BRANCH)"
	@echo "Git Origin: $$(git config --get remote.origin.url)"
	@echo "Github Action link: $(GITHUB_WORKFLOW)"
	@echo ""

define check_remote_connection
@if ! git ls-remote --exit-code $(GIT_REMOTE_URL) >/dev/null 2>&1; then \
		echo "$(RED)❌ Errore: impossibile connettersi al repository remoto. Verifica la connessione e riprova.$(NC)"; \
		exit 1; \
	fi
endef

define safe_push_tag
	git push origin $(1) || { \
		echo "$(RED)❌ Errore durante il push del tag $(1).$(NC)"; \
		echo "$(RED)🔑 Verifica di avere i permessi di scrittura sul repository remoto.$(NC)"; \
		echo "$(RED)🌐 Controlla la connessione di rete e che il repository remoto esista.$(NC)"; \
		exit 1; \
	}
endef

define push_tag
	$(call check_remote_connection)
	@echo "🚀 Avvio pipeline CI/CD per ambiente di $(1)...$(NC)"
	@if ! git diff --quiet HEAD; then \
		echo "$(YELLOW)⚠️  Attenzione! Ci sono modifiche che non risultano committate!$(NC)"; \
		echo "Il tag $(1) verra comunque pushato per: $(CURRENT_BRANCH)$(NC)"; \
		echo "Ricorda di committare tutte le modifiche prima di eseguire la pipeline per il deploy di tutte le modifiche.$(NC)"; \
	fi
	@echo "Tentativo di eliminare il tag da remoto $(1) se esiste...$(NC)"
	@git push --delete origin $(1) > /dev/null 2>&1 || echo "$(YELLOW)⚠️  Tag remoto $(1) non trovato o già eliminato.$(NC)"
	@if git rev-parse $(1) >/dev/null 2>&1; then \
		echo "$(YELLOW)⚠️  Il tag locale $(1) esiste gia. Rimuovo e ricreo...$(NC)"; \
		git tag -d $(1); \
	fi
	@git tag $(1)
	@$(call safe_push_tag,$(1))
	@echo "$(GREEN)✅ Tag $(1) pushato con successo!$(NC)"
	@echo "📡 Verificare che la pipeline di CI sia partita correttamente e non siano presenti errori."
	@echo "🔍 Puoi controllare lo stato delle pipeline di Github Action tramite API, gh oppure il sito web."
	@echo ""
endef

define error_prod
	@echo "$(RED)❌ Attenzione! Non è possibile eseguire il deploy in produzione con la normale pipeline!$(NC)"
	@echo "Per poter eseguire il deploy in produzione è necessario eseguire la pipeline manualmente...$(NC)"
	@echo "Per eseguire il deploy andare nella sezione Actions del repository e selezionare il workflow di deploy$(NC)"
	@echo "al seguente link: $(GITHUB_WORKFLOW)$(NC)"
	@echo ""
endef

init:
	$(call check_remote_connection)
	@echo "🚀 Inizializzazione dei tag per la pipeline di CI/CD...$(NC)"
	@echo "Tentativo di eliminare i tag da remoto se esistono...$(NC)"
	@git push --delete origin $(INIT_TAGS) > /dev/null 2>&1 || echo "$(YELLOW)⚠️  Tag remoto non trovato o già eliminato.$(NC)"
	@for tag in $(INIT_TAGS); do \
		if git rev-parse $$tag >/dev/null 2>&1; then \
			echo "$(YELLOW)⚠️  Il tag $$tag esiste gia. Rimuovo...$(NC)"; \
			git tag -d $$tag; \
		fi; \
		git tag $$tag; \
		$(call safe_push_tag,$$tag); \
	done
	@git push origin $(INIT_TAGS)
	@echo "$(GREEN)✅  Tag inizializzati e pushati in remoto con successo!$(NC)"
	@echo "📡 Verificare che i tag di CI siano stati inseriti correttamente e non siano presenti errori."
	@echo "🔍 Puoi controllare lo stato della pipeline sul sito Github o API, oppure tramite gh."
	@echo ""

dev:
	$(call push_tag,$(TAG_DEV:rc-%=%))

qa:
	$(call push_tag,$(TAG_QA:rc-%=%))

plan_dev:
	$(call push_tag,$(TAG_DEV_PLAN:rc-%=%))

plan_qa:
	$(call push_tag,$(TAG_QA_PLAN:rc-%=%))

prod:
	$(call error_prod)

plan_prod:
	$(call error_prod)