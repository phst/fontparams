SHELL := /bin/sh
INSTALL := install
INSTALL_PROGRAM := $(INSTALL)
INSTALL_DATA := $(INSTALL) -m 644

MKTEXLSR := mktexlsr
TEX := tex
LATEX := pdflatex
MAKEINDEX := makeindex

BASH := bash
LUA := lua

name := fontparams
bundle := phst

texmf := $(shell kpsewhich --var-value=TEXMFHOME)
branch := latex/$(bundle)
destdir := $(texmf)/tex/$(branch)
docdir := $(texmf)/doc/$(branch)
auctexdir := ~/.emacs.d/auctex/style

LATEXFLAGS := --file-line-error --interaction=scrollmode
LATEXFLAGS_DRAFT := $(LATEXFLAGS) --draftmode
LATEXFLAGS_FINAL := $(LATEXFLAGS) --synctex=1

source := $(name).dtx
driver := $(name).ins
destination := $(name).sty
manual := $(name).pdf
auctex_style := $(name).el
index_src := $(name).idx
index_dest := $(name).ind
index_log := $(name).ilg
index_sty := gind.ist
changes_src := $(name).glo
changes_dest := $(name).gls
changes_log := $(name).glg
changes_sty := gglo.ist
test_template := $(name)-test.tex

lua_module := $(name).lua
generated := $(name).def $(name)-legacy.def $(name)-luatex.def $(name)-xetex.def $(name)-pdftex.def $(name)-primitives.lua
data := $(name)-data.lua
compile_mod := $(name)-compile.lua
runtime_files := $(destination) $(lua_module) $(generated)


all: $(runtime_files) $(auctex_style)

pdf: $(manual)

complete: all pdf

install: all
	$(INSTALL) -d $(destdir)
	$(INSTALL_DATA) $(destination) $(destdir)
	$(INSTALL_DATA) $(lua_module) $(destdir)
	$(INSTALL_DATA) $(generated) $(destdir)
	$(INSTALL) -d $(auctexdir)
	$(INSTALL_DATA) $(auctex_style) $(auctexdir)
	$(MKTEXLSR)

install-pdf: pdf
	$(INSTALL) -d $(docdir)
	$(INSTALL_DATA) $(manual) $(docdir)
	$(MKTEXLSR)

install-complete: install install-pdf

$(destination): $(source) $(driver)
	$(TEX) $(driver)

$(manual): $(source) $(runtime_files)
	$(LATEX) $(LATEXFLAGS_DRAFT) $(source)
	$(MAKEINDEX) -s $(index_sty) -o $(index_dest) -t $(index_log) $(index_src)
	$(MAKEINDEX) -s $(changes_sty) -o $(changes_dest) -t $(changes_log) $(changes_src)
	$(LATEX) $(LATEXFLAGS_DRAFT) $(source)
	$(LATEX) $(LATEXFLAGS_FINAL) $(source)

$(name).def: $(name)-compile-common.lua $(compile_mod) $(data)
	$(LUA) $<

$(name)-legacy.def: $(name)-compile-legacy.lua $(compile_mod) $(data)
	$(LUA) $<

$(name)-luatex.def: $(name)-compile-luatex.lua $(compile_mod) $(data)
	$(LUA) $<

$(name)-xetex.def: $(name)-compile-xetex.lua $(compile_mod) $(data)
	$(LUA) $<

$(name)-pdftex.def: $(name)-compile-pdftex.lua $(compile_mod) $(data)
	$(LUA) $<

check: $(runtime_files) $(test_template)
	$(BASH) build-test.sh

.SUFFIXES:
