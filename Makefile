#!/usr/bin/make
# An install-only makefile to allow easy running of checkinstall.

PACKAGE = i3-config
prefix = /usr/local
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin
datarootdir = $(prefix)/share
docdir = $(datarootdir)/doc/$(PACKAGE)
DESTDIR = /
pwd = $(shell pwd)
hostname = $(shell hostname)

executables = bin/i3-prelock \
              bin/i3-unlock \
              bin/i3-status-append \
              bin/current_temperature \
              bin/current_temperature_from_northcott

docfiles = $(wildcard *.md)

help:
	@echo "An install-only makefile to allow easy running of checkinstall:"
	@echo
	@echo "   $$ sudo make checkinstall"
	@echo
	@echo "Installs the following executables:"
	@echo
	@echo -n "   "; echo $(executables) | sed 's# \+#\n   #g'
	@echo
	@echo "You will have to manually symlink the config files into ~/.config/"

install:
	@install -d $(DESTDIR)$(bindir)
	@install -d $(DESTDIR)$(docdir)
	@install -v -m775 $(executables) $(DESTDIR)$(bindir)
	@install -v -m664 $(docfiles) $(DESTDIR)$(docdir)

checkinstall:
	checkinstall --pkgname=$(PACKAGE) --nodoc
	@echo
	@echo "Now you should symlink the configuration files into your home directory:"
	@echo
	@echo "   $$ ln -s $(pwd)/i3       ~/.config/i3       &&"
	@echo "     ln -s $(pwd)/i3status ~/.config/i3status &&"
	@echo "     ln -s $(pwd)/dunst    ~/.config/dunst    &&"
	@echo "     ls -l ~/.config/i3 ~/.config/i3status ~/.config/dunst"
	@echo
	@echo "You should also add a current temperature script to your crontab:"
	@echo
	@echo "   $$ crontab -e"
	@echo "   */15 * * * * /usr/local/bin/current_temperature_from_northcott > ~/.current_temperature"

