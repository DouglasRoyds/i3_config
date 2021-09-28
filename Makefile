#!/usr/bin/make
# An install-only makefile to allow easy running of checkinstall.

PACKAGE = i3-config
prefix = /usr/local
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin
datarootdir = $(prefix)/share
docdir = $(datarootdir)/doc/$(PACKAGE)
pixmaps = $(datarootdir)/pixmaps/$(PACKAGE)
DESTDIR = /
pwd = $(shell pwd)
hostname = $(shell hostname)

executables = bin/i3-locknow \
              bin/i3-prelock \
              bin/i3-unlock \
              bin/i3-status-append \
              bin/current_temperature \
              bin/current_temperature_from_northcott \
              bin/devmon-launch

docfiles = $(wildcard *.md)

imagefiles = pixmaps/floppy-disk.png

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
	@install -d $(DESTDIR)$(pixmaps)
	@install -v -m775 $(executables) $(DESTDIR)$(bindir)
	@install -v -m664 $(docfiles) $(DESTDIR)$(docdir)
	@install -v -m664 $(imagefiles) $(DESTDIR)$(pixmaps)

checkinstall:
	checkinstall --pkgname=$(PACKAGE) --nodoc
	@echo
	@echo "Ensure that the following packages are installed:"
	@echo
	@echo "   $$ sudo apt-get install i3 i3status curl dunst rofi"
	@echo
	@echo "Now you should symlink the configuration files into your home directory:"
	@echo
	@echo "   $$ ln -s $(pwd)/i3       ~/.config/i3       &&"
	@echo "     ln -s $(pwd)/i3status ~/.config/i3status &&"
	@echo "     ln -s $(pwd)/dunst    ~/.config/dunst    &&"
	@echo "     ln -s $(pwd)/rofi     ~/.config/rofi     &&"
	@echo "     ls -l ~/.config/i3 ~/.config/i3status ~/.config/dunst ~/.config/rofi"
	@echo
	@echo "You should also add a current temperature script to your crontab:"
	@echo
	@echo "   $$ crontab -e"
	@echo "   */15 * * * * /usr/local/bin/current_temperature_from_northcott > ~/.current_temperature"

