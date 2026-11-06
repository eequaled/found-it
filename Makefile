PYTHON ?= python
SQLC ?= sqlc
.PHONY: install up down migrate rollback generate validate check-generated check-migrations test
install:
	npm ci --ignore-scripts
	$(PYTHON) -m pip install -e '.[test]'
up:
	docker compose up --build -d
down:
	docker compose down
migrate:
	$(PYTHON) -m scripts.migrations up
rollback:
	$(PYTHON) -m scripts.migrations rollback
generate:
	$(PYTHON) -m scripts.prepare_plugin
	$(SQLC) generate
validate:
	$(PYTHON) -m scripts.codegen validate
check-generated:
	$(PYTHON) -m scripts.prepare_plugin
	$(PYTHON) -m scripts.codegen check
check-migrations:
	$(PYTHON) -m scripts.migrations check
test: validate check-generated
	ruff check .
	$(PYTHON) -m pytest -q
