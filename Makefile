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

# i3_config is relative to HOME
i3_config := $(patsubst %/,%,$(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
i3_config := $(subst $(HOME)/,,$(i3_config))

docfiles = $(wildcard *.md)
dot_config = dunst \
	     i3 \
	     i3status \
	     rofi \
	     xlunch
executables = bin/i3-locknow \
              bin/i3-prelock \
              bin/i3-unlock \
              bin/i3-status-append \
              bin/current_temperature \
              bin/current_temperature_from_northcott \
              bin/devmon-launch
imagefiles = pixmaps/floppy-disk.png

help:
	@echo "An install-only makefile to allow easy running of checkinstall:"
	@echo
	@echo "   $$ make checkinstall"
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

.PHONY: $(dot_config)
$(dot_config):
	@install -d $(HOME)/.config
	@ln -snf ../$(i3_config)/$@ $(HOME)/.config/$@
	@ls -ld --color $(HOME)/.config/$@

checkinstall: $(dot_config)
	sudo apt-get install i3-wm i3lock i3status curl dunst imagemagick rofi udevil x11-utils xautolock
	sudo checkinstall --pkgname=$(PACKAGE) --nodoc
	@echo
	@echo "Add a current temperature script to your crontab:"
	@echo
	@echo "   $$ crontab -e"
	@echo "   */15 * * * * /usr/local/bin/current_temperature_from_northcott > ~/.current_temperature"

