-- fontparams.lua
-- Copyright 2010 Philipp Stephani
--
-- This work may be distributed and/or modified under the
-- conditions of the LaTeX Project Public License, either version 1.3c
-- of this license or (at your option) any later version.
-- The latest version of this license is in
--   http://www.latex-project.org/lppl.txt
-- and version 1.3c or later is part of all distributions of LaTeX
-- version 2009/09/24 or later.
--
-- This work has the LPPL maintenance status `maintained'.
--
-- The Current Maintainer of this work is Philipp Stephani.
--
-- This work consists of the files fontparams.dtx, fontparams.ins,
-- fontparams.lua, fontparams-data.lua, fontparams-compile.lua,
-- fontparams-compile-common.lua, fontparams-compile-legacy.lua,
-- fontparams-compile-luatex.lua, fontparams-compile-xetex.lua,
-- fontparams-compile-pdftex.lua, fontparams-test.tex, build-test.sh,
-- fontparams.el, Makefile and README.rst
-- and the derived files fontparams.sty, fontparams.def,
-- fontparams-legacy.def, fontparams-luatex.def, fontparams-xetex.def,
-- fontparams-pdftex.def and fontparams-primitives.lua.

local err, warn, info, log = luatexbase.provides_module {
   name = "fontparams",
   date = "2010/12/21",
   version = "0.1",
   description = "Engine-independent access to font parameters",
   author = "Philipp Stephani",
   license = "LPPL v1.3+"
}

luatexbase.require_module("fontparams-primitives", "2010/12/21")

local tex = tex
local luatexbase = luatexbase
local fontparams = fontparams

module("fontparams")

local cramped_styles = {
   "crampeddisplaystyle",
   "crampedtextstyle",
   "crampedscriptstyle",
   "crampedscriptscriptstyle"
}

-- TODO: check whether control sequences already defined
tex.enableprimitives("", cramped_styles)
tex.enableprimitives("", fontparams.primitives.list)
