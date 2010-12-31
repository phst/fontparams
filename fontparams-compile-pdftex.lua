#!/usr/bin/env lua

-- fontparams-compile-pdftex.lua
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
-- The Current Maintainer of this work is Philipp Stephani.
-- This work consists of all files listed in MANIFEST.

require("fontparams-data")
require("fontparams-compile")

local params = fontparams.data.params
local common = fontparams.compile

local properties = {
   family = "letters",
   number = 0,
   absolute = false,
   factor = 0
}

local function inflate(def, child1, child2)
   local elem = def[child1][child2]
   local result = { }
   if type(elem) == "table" then
      if elem.sum then
         for index, value in ipairs(elem.sum) do
            local res = { }
            for prop, default in pairs(properties) do
               local obj = value[prop]
               if obj == nil then
                  obj = common.navigate(def, child1, child2, prop)
               end
               if obj == nil and default ~= 0 then
                  obj = default
               end
               res[prop] = obj
            end
            if type(res.number) ~= "number" then
               error("Something is wrong: " .. tostring(res.number))
            end
            result[index] = res
         end
      else
         local res = { }
         for prop, default in pairs(properties) do
            obj = common.navigate(def, child1, child2, prop)
            if obj == nil and default ~= 0 then
               obj = default
            end
            res[prop] = obj
         end
         if type(res.number) ~= "number" then
            error("Something is wrong: " .. tostring(res.number))
         end
         result[1] = res
      end
   elseif type(elem) == "string" then
      result[1] = {
         command = elem
      }
   elseif type(elem) == "number" then
      result[1] = {
         family = "letters",
         number = elem,
         absolute = false
      }
   else
      error("Invalid definition")
   end
   return result
end

local function is_composite(elem)
   if #elem > 1 then
      return true
   else
      def = elem[1]
      if def.absolute or def.factor then
         return true
      else
         return false
      end
   end
end

local tpl_font_dimen = [[\fontdimen %s #1]]
local tpl_font_dimen_abs = [[\fontparams_abs:n { \fontdimen %s #1 }]]
local tpl_font_term = [[%.2f \fontdimen %s #1]]
local tpl_font_term_abs = [[%.2f \fontparams_abs:n { \fontdimen %s #1 }]]

local function format_font_term(term)
   if term.command then
      return "\\" .. term.command
   else
      local factor = term.factor
      local absolute = term.absolute
      local number = common.int_const(term.number)
      if factor then
         if absolute then
            return tpl_font_term_abs:format(factor, number)
         else
            return tpl_font_term:format(factor, number)
         end
      else
         if absolute then
            return tpl_font_dimen_abs:format(number)
         else
            return tpl_font_dimen:format(number)
         end
      end
   end
end

local function format_font_expr(elem)
   local terms = { }
   for i, term in ipairs(elem) do
      terms[i] = format_font_term(term)
   end
   return table.concat(terms, " + ")
end

local tpl_font_get_prim = [[
  %s]]

local tpl_font_get_comp = [[
  \dimexpr %s \relax]]

local function format_font_get(name, def)
   local elem = def.nondisplay.noncramped
   local comp = is_composite(elem)
   local expr = format_font_expr(elem)
   if comp then
      return tpl_font_get_comp:format(expr)
   else
      return tpl_font_get_prim:format(expr)
   end
end

local tpl_font_set_prim = [[
  %s \dimexpr #2 \relax]]

local tpl_font_set_comp = [[
  \msg_error:nnx { fontparams } { readonly-param } { %s }]]

local function format_font_set(name, def)
   local elem = def.nondisplay.noncramped
   local comp = is_composite(elem)
   local expr = format_font_expr(elem)
   if comp then
      return tpl_font_set_comp:format(name)
   else
      return tpl_font_set_prim:format(expr)
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

local function format_font_macros(name, def)
   local get = format_font_get(name, def)
   local set = format_font_set(name, def)
   return tpl_font_macros:format(name, get, name, set)
end

local tpl_style_dimen = [[\fontdimen %s \%sfont %s]]
local tpl_style_dimen_abs = [[\fontparams_abs:n { \fontdimen %s \%sfont %s }]]
local tpl_style_term = [[%.2f \fontdimen %s \%sfont %s]]
local tpl_style_term_abs = [[%.2f \fontparams_abs:n { \fontdimen %s \%sfont %s }]]

local families = {
   letters = 2,
   symbols = 3
}

local function format_style_term(term, font)
   if term.command then
      return "\\" .. term.command
   else
      local factor = term.factor
      local absolute = term.absolute
      local number = common.int_const(term.number)
      local fam = common.int_const(families[term.family])
      if factor then
         if absolute then
            return tpl_style_term_abs:format(factor, number, font, fam)
         else
            return tpl_style_term:format(factor, number, font, fam)
         end
      else
         if absolute then
            return tpl_style_dimen_abs:format(number, font, fam)
         else
            return tpl_style_dimen:format(number, font, fam)
         end
      end
   end
end

local function format_style_expr(elem, font)
   local terms = { }
   for i, term in ipairs(elem) do
      terms[i] = format_style_term(term, font)
   end
   return table.concat(terms, " + ")
end

local tpl_style_simple = "  %s"

local tpl_style_complex = [[
  \cs_if_eq:NNTF #1 \displaystyle { %s } {
    \cs_if_eq:NNTF #1 \crampeddisplaystyle { %s } {
      \cs_if_eq:NNTF #1 \textstyle { %s } {
        \cs_if_eq:NNTF #1 \crampedtextstyle { %s } {
          \cs_if_eq:NNTF #1 \scriptstyle { %s } {
            \cs_if_eq:NNTF #1 \crampedscriptstyle { %s } {
              \cs_if_eq:NNTF #1 \scriptscriptstyle { %s } {
                \cs_if_eq:NNTF #1 \crampedscriptscriptstyle { %s } {
                  \msg_error:nnx { fontparams } { unknown-style } { \token_to_str:N #1 }
                }
              }
            }
          }
        }
      }
    }
  }]]

local function format_style_code(def)
   local simple = common.is_simple(def)
   local tn = format_style_expr(def.nondisplay.noncramped, "text")
   if simple then
      return tpl_style_simple:format(tn)
   else
      local dc = format_style_expr(def.display.cramped, "text")
      local dn = format_style_expr(def.display.noncramped, "text")
      local tc = format_style_expr(def.nondisplay.cramped, "text")
      local sc = format_style_expr(def.nondisplay.cramped, "script")
      local sn = format_style_expr(def.nondisplay.noncramped, "script")
      local xc = format_style_expr(def.nondisplay.cramped, "scriptscript")
      local xn = format_style_expr(def.nondisplay.noncramped, "scriptscript")
      return tpl_style_complex:format(dn, dc, tn, tc, sn, sc, xn, xc)
   end
end

local tpl_style_get_prim = "%s"

local tpl_style_get_comp = [[
  \dimexpr
%s
  \relax]]

local function format_style_get(name, comp, expr)
   if comp then
      return tpl_style_get_comp:format(expr)
   else
      return tpl_style_get_prim:format(expr)
   end
end

local tpl_style_set_prim = [[
%s
  \dimexpr #2 \relax]]

local tpl_style_set_comp = [[
  \msg_error:nnx { fontparams } { readonly-param } { %s }]]

local function format_style_set(name, comp, expr)
   if comp then
      return tpl_style_set_comp:format(name)
   else
      return tpl_style_set_prim:format(expr)
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

local function format_style_macros(name, comp, expr)
   local get = format_style_get(name, comp, expr)
   local set = format_style_set(name, comp, expr)
   return tpl_style_macros:format(name, get, name, set)
end

local tpl_primitive_macro = [[
\cs_set_protected_nopar:Npn \%s #1 {
%s
}
]]

local function format_primitive_macro(name, comp, expr)
   local get = format_style_get(name, comp, expr)
   return tpl_primitive_macro:format(name, get)
end

local primitives = { }

common.output_tex("fontparams-pdftex.def", "Font parameter definitions for TFM-based fonts")

for key, dummy in pairs(params) do
   local value = common.value(params, key)
   local raw = common.definition(value, "pdftex")
   if raw then
      local def = {
         display = {
            cramped = inflate(raw, "display", "cramped"),
            noncramped = inflate(raw, "display", "noncramped")
         },
         nondisplay = {
            cramped = inflate(raw, "nondisplay", "cramped"),
            noncramped = inflate(raw, "nondisplay", "noncramped")
         }
      }
      local primitive = value.luatex
      local vtype = value.type or "dimen"
      if vtype ~= "dimen" then
         error(string.format("Invalid type %s", vtype))
      end
      local satellite = value.only_display or value.only_cramped
      local comp = is_composite(def.display.cramped) or is_composite(def.display.noncramped)
                   or is_composite(def.nondisplay.cramped) or is_composite(def.nondisplay.noncramped)
      local expr = format_style_code(def)
      if type(key) == "string" then
         io.write(format_font_macros(key, def))
         io.write(format_style_macros(key, comp, expr))
      end
      if primitive and not satellite then
         if primitives[primitive] then
            error(string.format([[Primitive \%s defined twice]], primitive))
         end
         io.write(format_primitive_macro(primitive, comp, expr))
         primitives[primitive] = true
      end
   end
end

io.close()
