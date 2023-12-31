.EXPORT_ALL_VARIABLES:
.PHONY: venv install pre-commit clean

ifeq ($(OS),Windows_NT)
  GLOBAL_PYTHON := $(shell py -c 'import sys; print(sys.executable)')
  LOCAL_PYTHON := .\\.venv\\Scripts\\python.exe
  LOCAL_PRE_COMMIT := .\\.venv\\Lib\\site-packages\\pre_commit
else #macOS & Linux
  GLOBAL_PYTHON := $(shell python3 -c 'import sys; print(sys.executable)') #which python3
  LOCAL_PYTHON := ./.venv/bin/python
  LOCAL_PRE_COMMIT := ./.venv/lib/python3.9/site-packages/pre_commit
endif

setup: venv build pre-commit

venv: $(GLOBAL_PYTHON)
	@echo "⚙️💈💈💈💈💈💈⚙️ Creating a Virtual Environment ⚙️💈💈💈💈💈💈⚙️"
	poetry env use $(GLOBAL_PYTHON)

build: ${LOCAL_PYTHON}
	@echo "⚙️💈💈💈💈💈💈⚙️ Building the Environment ⚙️💈💈💈💈💈💈⚙️"
	poetry install --no-root --sync

pre-commit: ${LOCAL_PYTHON} ${LOCAL_PRE_COMMIT}
	@echo "⚙️💈💈💈💈💈💈⚙️ Setting up pre-commit ⚙️💈💈💈💈💈💈⚙️"
	$(LOCAL_PYTHON) -m pre_commit install
	$(LOCAL_PYTHON) -m pre_commit autoupdate
	@echo "🚀🚀🚀🚀🚀🚀 Your nx-py-template is ready for action 🚀🚀🚀🚀🚀🚀 "

clean:
	@echo "⚙️🚮🚮🚮⚙️ Cleaning the Environment ⚙️🚮🚮🚮⚙️"
ifeq ($(OS),Windows_NT)
	@if exist .\.git\hooks rmdir /s /q .\.git\hooks
	@if exist .\.venv rmdir /s /q .\.venv
	@if exist poetry.lock del poetry.lock
else
	@if [ -d ./.git/hooks ]; then rm -rf ./.git/hooks; fi
	@if [ -d ./.venv ]; then rm -rf ./.venv; fi
	@if [ -f poetry.lock ]; then rm poetry.lock; fi
endif
