#!/usr/bin/env lua

-- compile-legacy.lua
-- Copyright 2010, 2011 Philipp Stephani
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
-- The Current Maintainer of this work is Philipp Stephani.
-- This work consists of all files listed in MANIFEST.

require("fontparams-data")
require("fontparams-compile")

local params = fontparams.data.params
local common = fontparams.compile

local tpl_primitive = [[
\chk_if_free_cs:N \%s
]]

local function format_primitive(name)
   return tpl_primitive:format(name)
end

common.output_tex("fontparams-legacy.def", "Font parameter definitions for non-LuaTeX engines")

for key, value in pairs(params) do
   local primitive = value.luatex
   if primitive then
      io.write(format_primitive(primitive))
   end
end

common.close_tex()
