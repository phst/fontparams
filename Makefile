SHELL := /bin/sh
INSTALL := install
INSTALL_PROGRAM := $(INSTALL)
INSTALL_DATA := $(INSTALL) -m 644

MKTEXLSR := mktexlsr
TEX := tex
LATEX := pdflatex
MAKEINDEX := makeindex

BASH := bash
TAR := tar
ZIP := zip
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
doc_descriptions := $(name)-desc.tex
compile_mod := $(name)-compile.lua
runtime_files := $(destination) $(lua_module) $(generated)
doc_class := $(shell kpsewhich phst-doc.cls)

stage_root := texmf
stage_tex := $(stage_root)/tex/$(branch)
stage_doc := $(stage_root)/doc/$(branch)
stage_src := $(stage_root)/source/$(branch)

tds_tex := $(runtime_files)
tds_doc := $(manual) $(auctex_style)
tds_generic := Makefile README MANIFEST
tds_docstrip := $(source) $(driver)
tds_aux_lua := $(compile_mod) $(data)
tds_run_lua := $(name)-compile-*.lua
tds_aux_doc := $(doc_class) $(doc_descriptions)
tds_test := build-test.sh $(name)-test.tex test-lua-table.tex
tds_src_data := $(tds_generic) $(tds_docstrip) $(tds_aux_lua) $(tds_aux_doc) $(tds_test)
tds_src_prog := $(tds_run_lua)
tds_src := $(tds_src_data) $(tds_src_prog)
tds_files := $(tds_tex) $(tds_doc) $(tds_src)
tds_arch := $(name).tds.zip

ctan_files := $(tds_files) $(tds_arch)
ctan_arch := $(name).zip

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

tds: $(tds_arch)

ctan: $(ctan_arch)

check: $(runtime_files) $(test_template)
	$(BASH) build-test.sh

$(tds_arch): $(tds_files)
	$(INSTALL) -d $(stage_tex)
	$(INSTALL_DATA) $(tds_tex) $(stage_tex)
	$(INSTALL) -d $(stage_doc)
	$(INSTALL_DATA) $(tds_doc) $(stage_doc)
	$(INSTALL) -d $(stage_src)
	$(INSTALL_DATA) $(tds_src_data) $(stage_src)
	$(INSTALL_PROGRAM) $(tds_src_prog) $(stage_src)
	$(ZIP) -r $@ $(stage_root)

$(ctan_arch): $(ctan_files)
	$(ZIP) -j $@ $^

$(destination): $(source) $(driver)
	$(TEX) $(driver)

$(manual): $(source) $(doc_class) $(doc_descriptions) $(runtime_files)
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

$(doc_descriptions): $(name)-compile-desc.lua $(compile_mod) $(data)
	$(LUA) $<

.SUFFIXES:
