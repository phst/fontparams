#!/usr/bin/env lua

-- fontparams-compile-desc.lua
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

local tpl_opentype_name = [[\texttt{%s}]]

local function format_opentype_name(key)
   if type(key) == "string" then
      return tpl_opentype_name:format(key)
   else
      return "—"
   end
end

local tpl_luatex_name = [[\cs{%s} \DescribeMacro{\%s}]]

local function format_luatex_name(name)
   if name then
      return tpl_luatex_name:format(name, name)
   else
      return "—"
   end
end

local type_to_term = {
   int = "number",
   dimen = "dimen"
}

local function format_type(vtype)
   return type_to_term[vtype or "dimen"]
end

local function pdftex_simple(def)
   return type(def) ~= "table" or (table.maxn(def) <= 1 and not def.factor and not def.absolute)
end

local result = { }
local luatex_logo = [[\hologo{LuaTeX}]]
local xetex_logo = [[\hologo{XeTeX}]]
local pdftex_logo = [[\hologo{pdfTeX}]]

for key, dummy in pairs(params) do
   local value = common.value(params, key)
   local opentype_name = format_opentype_name(key)
   local luatex_name = format_luatex_name(value.luatex)
   local term = format_type(value.type)
   local read = { }
   local write = { }
   if value.luatex or type(key) == "string" then
      table.insert(read, luatex_logo)
      table.insert(write, luatex_logo)
   end
   if value.xetex then
      table.insert(read, xetex_logo)
      table.insert(write, xetex_logo)
   end
   if value.pdftex then
      table.insert(read, pdftex_logo)
      if common.deep_all(value.pdftex, pdftex_simple) then
         table.insert(write, pdftex_logo)
      end
   end
   local readable = table.concat(read, ", ")
   local writable = table.concat(write, ", ")
   local description = value.description or ""
   table.insert(result, {opentype_name, luatex_name, term, readable, writable, description})
end

local function lexicographical_compare(a, b)
   for i, v in ipairs(a) do
      local w = b[i]
      if v ~= w then
         return v < w
      end
   end
end

table.sort(result, lexicographical_compare)

local tpl_row = [[
\FontparamDesc{%s}{%s}{%s}{%s}{%s}{%s}
]]

io.output("fontparams-desc.tex")

for index, value in ipairs(result) do
   io.write(tpl_row:format(unpack(value)))
end

io.close()
