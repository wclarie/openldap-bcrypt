# $OpenLDAP$

# You may want to edit the following line if you chose a different --prefix when
# using ./configure for OpenLDAP itself
prefix=/usr/local

DEFS =
# If you want to enable debugging, uncomment the following line, recompile and reinstall
# WARNING: This will log all passwords in plaintext!
#DEFS = -DSLAPD_BCRYPT_DEBUG


LDAP_SRC = ../../../..
LDAP_BUILD = ../../../..
LDAP_INC = -I$(LDAP_BUILD)/include -I$(LDAP_SRC)/include -I$(LDAP_SRC)/servers/slapd
LDAP_LIB = $(LDAP_BUILD)/libraries/libldap/libldap.la \
	$(LDAP_BUILD)/libraries/liblber/liblber.la

LIBTOOL = $(LDAP_BUILD)/libtool
CC = gcc
OPT = -g -O2 -Wall -fomit-frame-pointer -funroll-loops

INCS = $(LDAP_INC)
LIBS = $(LDAP_LIB)

PROGRAMS = pw-bcrypt.la
LTVER = 0:0:0

exec_prefix=$(prefix)
ldap_subdir=/openldap
libdir=$(exec_prefix)/lib
libexecdir=$(exec_prefix)/libexec
moduledir = $(libexecdir)$(ldap_subdir)

.SUFFIXES: .c .o .lo

.c.lo:
	$(LIBTOOL) --mode=compile $(CC) $(OPT) $(DEFS) $(INCS) -c $<

all:		$(PROGRAMS)

pw-bcrypt.la:  pw-bcrypt.lo crypt_blowfish.lo
	$(LIBTOOL) --mode=link $(CC) $(OPT) -version-info $(LTVER) \
	-rpath $(moduledir) -module -o $@ $? $(LIBS)

clean:
	rm -rf  *.o *.lo *.loT *.la .libs core test

install:	$(PROGRAMS)
	mkdir -p $(DESTDIR)$(moduledir)
	for p in $(PROGRAMS) ; do \
		$(LIBTOOL) --mode=install cp $$p $(DESTDIR)$(moduledir) ; \
	done

