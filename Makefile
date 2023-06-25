all: tests

SHELL := /bin/bash

.PHONY: \
	all \
	check \
	test_external_python_modules \
	test_language_server_protocol \
	test_os_packages \
	test_os_version \
	tests

check:
	shellcheck /install_scripts/*

test_external_python_modules:
	pip freeze | grep black==23
	pip freeze | grep flake8==6
	pip freeze | grep ipython==8
	pip freeze | grep mutmut==2
	pip freeze | grep pylint==2
	pip freeze | grep pytest==7
	pip freeze | grep rope==1

test_language_server_protocol:
	Rscript -e "packageVersion('languageserver')" | egrep "0\.[0-9]+\.[0-9]+"
	apt-cache policy build-essential | grep "Installed: 12"
	apt-cache policy libcurl4-openssl-dev | grep "Installed: 7"
	apt-cache policy libssl-dev | grep "Installed: 3"
	apt-cache policy libxml2-dev | grep "Installed: 2"
	apt-cache policy python3 | grep "Installed: 3.10"
	apt-cache policy r-base | grep "Installed: 4"
	pyright --version | grep "pyright 1"

test_os_packages:
	. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' && nix develop --command neofetch --version | grep "Neofetch 7"
	. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' && nix develop --command nvim --version | grep "NVIM v0.9"
	. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' && nix develop --command rich --version | grep "^1"
	apt-cache policy curl | grep "Installed: 7"
	apt-cache policy exa | grep "Installed: 0"
	apt-cache policy fd-find | grep "Installed: 8"
	apt-cache policy git | grep "Installed: 1:2"
	apt-cache policy python3-pip | grep "Installed: 22"
	apt-cache policy ripgrep | grep "Installed: 13"
	apt-cache policy shellcheck | grep "Installed: 0"
	apt-cache policy tmux | grep "Installed: 3"
	apt-cache policy universal-ctags | grep "Installed: 5"
	apt-cache policy wget | grep "Installed: 1"
	node --version | grep "v18"
	npm --version | grep "^8"

test_os_version:
	cat /etc/os-release | grep "22.04"
	cat /etc/os-release | grep "Jammy Jellyfish"
	cat /etc/os-release | grep "LTS"

tests: \
		test_external_python_modules \
		test_language_server_protocol \
		test_os_packages \
		test_os_version
