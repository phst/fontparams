SHELL := /bin/sh
INSTALL := install
INSTALL_PROGRAM := $(INSTALL)
INSTALL_DATA := $(INSTALL) -m 644


BASH := bash
TAR := tar
ZIP := zip


texmf := $(shell kpsewhich --var-value=TEXMFHOME)
branch := latex/$(bundle)
destdir := $(texmf)/tex/$(branch)
docdir := $(texmf)/doc/$(branch)
auctexdir := ~/.emacs.d/auctex/style

test_template := $(name)-test.tex

lua_module := $(name).lua
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

.SUFFIXES:
