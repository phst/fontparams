#!/usr/bin/env lua

-- fontparams-compile-luatex.lua
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

local tpl_font_get_dimen = [[
  \dimexpr
  \directlua {
    tex.sprint(font.getfont(font.id(" \cs_to_str:N #1 ")).MathConstants.%s)
  } sp
  \relax]]

local tpl_font_get_int = [[
  \numexpr
  \directlua {
    tex.sprint(font.getfont(font.id(" \cs_to_str:N #1 ")).MathConstants.%s)
  }
  \relax]]

local function format_font_get(name, vtype)
   if vtype == "dimen" then
      return tpl_font_get_dimen:format(name)
   else
      return tpl_font_get_int:format(name)
   end
end

local tpl_font_set_dimen = [[
  \directlua {
    font.getfont(font.id(" \cs_to_str:N #1 ")).MathConstants.%s = \number \dimexpr #2 \relax
  }]]

local tpl_font_set_int = [[
  \directlua {
    font.getfont(font.id(" \cs_to_str:N #1 ")).MathConstants.%s = \number \numexpr #2 \relax
  }]]

local function format_font_set(name, vtype)
   if vtype == "dimen" then
      return tpl_font_set_dimen:format(name)
   else
      return tpl_font_set_int:format(name)
   end
end

local tpl_font_macros = [[
\cs_set_protected_nopar:Npn \fontparams_font_get_%s:N #1 {
%s
}
\cs_set_protected_nopar:Npn \fontparams_font_set_%s:Nn #1 #2 {
%s
}
]]

local function format_font_macros(name, vtype)
   local get = format_font_get(name, vtype)
   local set = format_font_set(name, vtype)
   return tpl_font_macros:format(name, get, name, set)
end

local tpl_style_get = [[
  \%s #1]]

local function format_style_get(name, vtype)
   return tpl_style_get:format(name)
end

local tpl_style_set_dimen = [[
  \%s #1 \dimexpr #2 \relax]]

local tpl_style_set_int = [[
  \%s #1 \numexpr #2 \relax]]

local function format_style_set(name, vtype)
   if vtype == "dimen" then
      return tpl_style_set_dimen:format(name)
   else
      return tpl_style_set_int:format(name)
   end
end

local tpl_style_macros = [[
\cs_set_protected_nopar:Npn \fontparams_style_get_%s:N #1 {
%s
}
\cs_set_protected_nopar:Npn \fontparams_style_set_%s:Nn #1 #2 {
%s
}
]]

local function format_style_macros(name, vtype, primitive)
   local get = format_style_get(primitive, vtype)
   local set = format_style_set(primitive, vtype)
   return tpl_style_macros:format(name, get, name, set)
end

io.output("fontparams-luatex.def")
io.write(fontparams.compile.tex_license("fontparams-luatex.def"))

for key, value in pairs(fontparams.data.params) do
   local vtype = value.type or "dimen"
   if type(key) == "string" then
      io.write(format_font_macros(key, vtype))
      local primitive = value.luatex
      if primitive then
         io.write(format_style_macros(key, vtype, primitive))
      end
   end
end

io.close()

tpl_primitive = "%q"

local function format_primitive(name)
   return tpl_primitive:format(name)
end

tpl_primitive_list = [[
luatexbase.provides_module {
   name = "fontparams-primitives",
   date = "2010/12/21",
   version = "0.1",
   description = "Engine-independent access to font parameters",
   author = "Philipp Stephani",
   license = "LPPL v1.3+"
}
module("fontparams.primitives")
list = {
  %s
}
]]

local function format_primitive_list(list)
   return tpl_primitive_list:format(list)
end

local primitives = { }

for key, value in pairs(fontparams.data.params) do
   local primitive = value.luatex
   if primitive then
      table.insert(primitives, format_primitive(primitive))
   end
end

local list = table.concat(primitives, ",\n  ")

io.output("fontparams-primitives.lua")
io.write(fontparams.compile.lua_license("fontparams-primitives.lua"))
io.write(format_primitive_list(list))
io.close()
