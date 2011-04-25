SHELL := /bin/sh
MKTEXLSR := mktexlsr
TEX := tex
PDFLATEX := pdflatex
MAKEINDEX := makeindex
LUA := lua

latexflags := --file-line-error --interaction=scrollmode
latexflags_draft := $(latexflags) --draftmode
latexflags_final := $(latexflags) --synctex=1

name := fontparams
bundle := phst

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

definitions := $(name).def $(name)-legacy.def $(name)-luatex.def $(name)-xetex.def $(name)-pdftex.def $(name)-primitives.lua
data := data.lua

all: $(destination) $(manual) $(definitions)

$(destination): $(driver) $(source)
	$(TEX) $<

$(manual): $(source) $(name)-desc.tex $(destination) $(definitions)
	$(PDFLATEX) $(latexflags_draft) $<
	$(MAKEINDEX) -s $(index_sty) -o $(index_dest) -t $(index_log) $(srcdir)/$(index_src)
	$(MAKEINDEX) -s $(changes_sty) -o $(changes_dest) -t $(changes_log) $(srcdir)/$(changes_src)
	$(PDFLATEX) $(latexflags_draft) $<
	$(PDFLATEX) $(latexflags_final) $<

$(name).def: compile-common.lua compile.lua $(data)
	$(LUA) $<

$(name)-legacy.def: compile-legacy.lua compile.lua $(data)
	$(LUA) $<

$(name)-luatex.def: compile-luatex.lua compile.lua $(data)
	$(LUA) $<

$(name)-xetex.def: compile-xetex.lua compile.lua $(data)
	$(LUA) $<

$(name)-pdftex.def: compile-pdftex.lua compile.lua $(data)
	$(LUA) $<

$(name)-desc.tex: compile-desc.lua compile.lua $(data)
	$(LUA) $<

.SUFFIXES:
.PHONY: all
