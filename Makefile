SHELL:=/bin/bash

make_vars ?= vars.env
ifneq ("$(wildcard $(make_vars))","")
include $(make_vars)
endif

make_secrets ?= secrets.env
ifneq ("$(wildcard $(make_secrets))","")
include $(make_secrets)
endif

export

open-webui:
	if [ ! -d ./open-webui ]; then \
		git clone "https://github.com/open-webui/open-webui.git"; \
	fi

.PHONY: up
up: open-webui
	docker-compose -f docker-compose.devcontainer.yaml up -d

.PHONY: down
down:
	docker-compose -f docker-compose.devcontainer.yaml down
