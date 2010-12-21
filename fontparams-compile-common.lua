#!/usr/bin/env lua

-- fontparams-compile-common.lua
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

require("fontparams-data")
require("fontparams-compile")

local tpl_macros = [[
\chk_if_free_cs:N \fontparams_font_get_%s:N
\chk_if_free_cs:N \fontparams_font_set_%s:Nn
\chk_if_free_cs:N \fontparams_style_get_%s:N
\chk_if_free_cs:N \fontparams_style_set_%s:Nn
]]

local function format_macros(name)
   return tpl_macros:format(name, name, name, name)
end

io.output("fontparams.def")
io.write(fontparams.compile.tex_license("fontparams.def"))

for key, value in pairs(fontparams.data.params) do
   if type(key) == "string" then
      io.write(format_macros(key))
   end
end

io.close()
