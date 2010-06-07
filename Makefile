# Makefile, used for the powerpc-tutorial in DocBook XML

SOURCES		:= $(wildcard *.dbk) common.ent version.ent
FORMATS		:= pdf # txt html
TARGETS		:= $(foreach fmt,$(FORMATS),powerpc-tutorial.$(fmt))

VERSION=unknown
PUBDATE=unknown

XP=xsltproc --nonet --novalid --xinclude
XL=xmllint --nonet --noout --postvalid --xinclude
DBLATEX=dblatex --style=db2latex

DOCBOOK_XSL=http://docbook.sourceforge.net/release/xsl/current
DBK2HTML=$(CURDIR)/html.xsl
DBK2HTML1=$(CURDIR)/txt.xsl

all: $(TARGETS)

powerpc-tutorial.pdf: $(SOURCES)
	$(DBLATEX) -o $@ 00-index.dbk

powerpc-tutorial.html: 00-index.html
	$(XP) $(DBK2HTML) 00-index.dbk
	mv index.html powerpc-tutorial.html

powerpc-tutorial.txt: powerpc-tutorial.txt
	$(XP) $(DBK2HTML1) 00-index.dbk \
	    | w3m -cols 70 -dump -no-graph -T text/html > $@

version.ent:
	echo '<!ENTITY version "$(VERSION)">' >  $@
	echo '<!ENTITY pubdate "$(PUBDATE)">' >> $@

validate: $(SOURCES)
	$(XL) 00-index.dbk

clean:
	rm -f *.fo *.html *.pdf *.txt
	rm -f version.ent
	rm -f *~ *.bak .#* core

.PHONY: clean all powerpc-tutorial.html
