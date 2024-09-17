DOCKER=docker
COMPOSE=${DOCKER} compose
UP=${COMPOSE} up -d
BUILD=${COMPOSE} build
EXEC=${COMPOSE} exec
LOGS=${COMPOSE} logs -f
SHELL=sh
KUBECTL=kubectl



all: plugin-install

# Environment
#===============================================================
.PHONY: plugin-install
plugin-install: ## Install asdf plugins
	@$(SHELL) ./bin/scripts/plugin.sh



# Build for Development environment (Docker Compose)
#===============================================================
build: ## docker compose build
	${BUILD}

up: ## docker compose up
	${UP}

logs: ## docker compose logs
	${LOGS}



# Kubernetes
#===============================================================
.PHONY: get-all-resource
get-all-resource: ## Get all resources
	@$(KUBECTL) get '$(shell $(KUBECTL) api-resources --namespaced=true --verbs=list -o name | tr "\n" "," | sed -e 's/,$$//')'

.PHONY: get-argocd-initial-secret
get-argocd-initial-secret: ## Get ArgoCD initial admin secret
	@$(KUBECTL) -n argocd get secret/argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo



# Makefile config
#===============================================================
help: ## Display this help screen
	echo "Usage: make [task]\n\nTasks:"
	perl -nle 'printf("    \033[33m%-30s\033[0m %s\n",$$1,$$2) if /^([a-zA-Z_-]*?):(?:.+?## )?(.*?)$$/' $(MAKEFILE_LIST)

.SILENT: help

.PHONY: $(shell egrep -o '^(\._)?[a-z_-]+:' $(MAKEFILE_LIST) | sed 's/://')
