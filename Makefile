VENV_NAME := venv
PYTHON_VERSION := $(shell python3 -c "import sys; print('{}.{}'.format(sys.version_info.major, sys.version_info.minor))")

create-venv:
	echo "Creating virtual environment $(VENV_NAME)"
	virtualenv -p $(PYTHON_VERSION) $(VENV_NAME)

delete-venv:
	echo "Deleting virtual environment $(VENV_NAME)"
	rm -rf ./$(VENV_NAME)

install-packages:
	echo "Installing packages from requirements.txt"
	pip install -r requirements.txt --extra-index-url https://pypi.python.org/simple


.PHONY: 
	create-venv
	delete-venv
	install-packages