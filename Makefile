all: tests

SHELL := /bin/bash

.PHONY: \
	all \
	test_docker_installed_versions \
	test_os_version \
	tests

test_docker_installed_versions:
	Rscript -e "packageVersion('languageserver')" | egrep "0\.[0-9]+\.[0-9]+"
	apt-cache policy fd-find | grep "Installed: 8"
	apt-cache policy python3-venv | grep "Installed: 3.10"
	apt-cache policy ripgrep | grep "Installed: 13"
	apt-cache policy universal-ctags | grep "Installed: 5"
	apt-cache policy wget | grep "Installed: 1"
	\. "${HOME}/.nvm/nvm.sh" && node --version | grep "v22"
	\. "${HOME}/.nvm/nvm.sh" && npm --version | grep "^10"
	nvim --version | grep "NVIM v0.11"
	pip freeze | grep rope==1

test_os_version:
	cat /etc/os-release | grep "22.04"
	cat /etc/os-release | grep "Jammy Jellyfish"
	cat /etc/os-release | grep "LTS"

tests: \
		test_docker_installed_versions \
		test_os_version
