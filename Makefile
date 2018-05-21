#!/usr/bin/make
# An install-only makefile to allow easy running of checkinstall.

PACKAGE = i3-config
prefix = /usr/local
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin
datarootdir = $(prefix)/share
docdir = $(datarootdir)/doc/$(PACKAGE)
xsessiondir = /usr/share/xsessions
DESTDIR = /
pwd = $(shell pwd)
hostname = $(shell hostname)

executables = bin/i3-launch \
              bin/i3-status-append \
              bin/current_temperature \
              bin/current_temperature_from_northcott \
              $(or $(wildcard bin/$(hostname)/*), $(wildcard bin/default/*)) \

docfiles = $(wildcard *.md)

session_files = i3-douglas.desktop

help:
	@echo "An install-only makefile to allow easy running of checkinstall:"
	@echo "   $$ sudo make checkinstall"
	@echo
	@echo "Installs the following executables:"
	@echo -n "   "; echo $(executables) | sed 's# \+#\n   #g'
	@echo
	@echo "You will have to manually symlink the config files into ~/.i3"

install:
	@install -d $(DESTDIR)$(bindir)
	@install -d $(DESTDIR)$(docdir)
	@install -d $(DESTDIR)$(xsessiondir)
	@install -v -m775 $(executables) $(DESTDIR)$(bindir)
	@install -v -m664 $(docfiles) $(DESTDIR)$(docdir)
	@install -v -m644 $(session_files) $(DESTDIR)$(xsessiondir)

checkinstall:
	checkinstall --pkgname=$(PACKAGE) --nodoc
	@echo
	@echo "Now you should symlink the configuration files into your home directory:"
	@echo
	@echo "   $$ ln -s $(pwd)/home/i3/ ~/.i3 &&"
	@echo "     ln -s $(pwd)/home/i3status.conf ~/.i3status.conf &&"
	@echo "     ln -s $(pwd)/home/xsession ~/.xsession"
	@echo
	@echo "You should also add a current temperature script to your crontab:"
	@echo
	@echo "   $$ crontab -e"
	@echo "   */15 * * * * /usr/local/bin/current_temperature_from_northcott > ~/.current_temperature"

