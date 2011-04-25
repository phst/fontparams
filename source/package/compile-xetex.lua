#!/usr/bin/env lua

-- compile-xetex.lua
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

local tpl_font_get_dimen = [[
  \fontdimen %s #1]]

local tpl_font_get_int = [[
  \numexpr \number \fontdimen %s #1 \relax]]

local function format_font_get(vtype, def)
   local value = def.nondisplay.noncramped
   local number = common.int_const(value)
   if vtype == "dimen" then
      return tpl_font_get_dimen:format(number)
   else
      return tpl_font_get_int:format(number)
   end
end

local tpl_font_set_dimen = [[
  \fontdimen %s #1 \dimexpr #2 \relax]]

local tpl_font_set_int = [[
  \fontdimen %s #1 \dimexpr \number \numexpr #2 \relax sp \relax]]

local function format_font_set(vtype, def)
   local value = def.nondisplay.noncramped
   local number = common.int_const(value)
   if vtype == "dimen" then
      return tpl_font_set_dimen:format(number)
   else
      return tpl_font_set_int:format(number)
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

local function format_font_macros(name, vtype, def)
   local get = format_font_get(vtype, def)
   local set = format_font_set(vtype, def)
   return tpl_font_macros:format(name, get, name, set)
end

local tpl_style_simple = [[
  \fontdimen %s \textfont \c_two]]

local tpl_style_complex = [[
  \fontdimen
  \cs_if_eq:NNTF #1 \displaystyle { %s \textfont } {
    \cs_if_eq:NNTF #1 \crampeddisplaystyle { %s \textfont } {
      \cs_if_eq:NNTF #1 \textstyle { %s \textfont } {
        \cs_if_eq:NNTF #1 \crampedtextstyle { %s \textfont } {
          \cs_if_eq:NNTF #1 \scriptstyle { %s \scriptfont } {
            \cs_if_eq:NNTF #1 \crampedscriptstyle { %s \scriptfont } {
              \cs_if_eq:NNTF #1 \scriptscriptstyle { %s \scriptscriptfont } {
                \cs_if_eq:NNTF #1 \crampedscriptscriptstyle { %s \scriptscriptfont } {
                  \msg_error:nnx { fontparams } { unknown-style } { \token_to_str:N #1 }
                }
              }
            }
          }
        }
      }
    }
  }
  \c_two]]

local function format_style_expr(def)
   local simple = common.is_simple(def)
   local nn = common.int_const(def.nondisplay.noncramped)
   if simple then
      return tpl_style_simple:format(nn)
   else
      local yy = common.int_const(def.display.cramped)
      local yn = common.int_const(def.display.noncramped)
      local ny = common.int_const(def.nondisplay.cramped)
      return tpl_style_complex:format(yn, yy, nn, ny, nn, ny, nn, ny)
   end
end

local tpl_style_get_dimen = "%s"

local tpl_style_get_int = [[
  \numexpr
  \number
%s
  \relax]]

local function format_style_get(vtype, expr)
   if vtype == "dimen" then
      return tpl_style_get_dimen:format(expr)
   else
      return tpl_style_get_int:format(expr)
   end
end

local tpl_style_set_dimen = [[
%s
  \dimexpr #2 \relax]]

local tpl_style_set_int = [[
%s
  \dimexpr \number \numexpr #2 \relax sp \relax]]

local function format_style_set(vtype, expr)
   if vtype == "dimen" then
      return tpl_style_set_dimen:format(expr)
   else
      return tpl_style_set_int:format(expr)
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

local function format_style_macros(name, vtype, expr)
   local get = format_style_get(vtype, expr)
   local set = format_style_set(vtype, expr)
   return tpl_style_macros:format(name, get, name, set)
end

local tpl_primitive_macro = [[
\cs_set_protected_nopar:Npn \%s #1 {
%s
}
]]

local function format_primitive_macro(name, vtype, expr)
   local get = format_style_get(vtype, expr)
   return tpl_primitive_macro:format(name, get)
end

local primitives = { }

common.output_tex("fontparams-xetex.def", "Font parameter definitions for XeTeX")

for key, dummy in pairs(params) do
   local primitive = dummy.luatex
   local value = common.value(params, key)
   local def = common.definition(value, "xetex")
   if def then
      local vtype = value.type or "dimen"
      local expr = format_style_expr(def)
      io.write(format_font_macros(key, vtype, def))
      io.write(format_style_macros(key, vtype, expr))
      if primitive then
         if primitives[primitive] then
            error(string.format([[Primitive \%s defined twice]], primitive))
         end
         io.write(format_primitive_macro(primitive, vtype, expr))
         primitives[primitive] = true
      end
   end
end

common.close_tex()
