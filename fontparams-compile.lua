-- fontparams-compile.lua
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

local error = error
local type = type
local tostring = tostring
local pairs = pairs
local select = select
local os = os
local io = io

module("fontparams.compile")

local version = "0.1"

function deep_all(value, predicate)
   if predicate(value) then
      if type(value) == "table" then
         for k, v in pairs(value) do
            if not deep_all(v, predicate) then
               return false
            end
         end
      end
      return true
   else
      return false
   end
end

local function deep_equal(a, b)
   if type(a) == type(b) then
      if type(a) == "table" then
         for k, v in pairs(a) do
            if not deep_equal(v, b[k]) then
               return false
            end
         end
         return true
      else
         return a == b
      end
   else
      return false
   end
end

local function all_deep_equal(...)
   local length = select("#", ...)
   if length > 0 then
      local first = select(1, ...)
      for index = 2, length do
         if not deep_equal(first, select(index, ...)) then
            return false
         end
      end
   end
   return true
end

local function deep_copy(object)
   if type(object) == "table" then
      local result = { }
      for k, v in pairs(object) do
         result[k] = deep_copy(v)
      end
      return result
   else
      return object
   end
end

local function merge(a, b)
   local result = deep_copy(a)
   for k, v in pairs(b) do
      result[k] = deep_copy(v)
   end
   return result
end

local comment_prefixes = {
   tex = "%%",
   lua = "--"
}

local function add_comment(text, language)
   local prefix = comment_prefixes[language]
   text = text:gsub("[^\n]+\n", prefix .. " %0")
   text = text:gsub("\n\n", "\n" .. prefix .. "\n")
   return text
end

local license = [[
Copyright 2010 Philipp Stephani

This work may be distributed and/or modified under the
conditions of the LaTeX Project Public License, either version 1.3c
of this license or (at your option) any later version.
The latest version of this license is in
  http://www.latex-project.org/lppl.txt
and version 1.3c or later is part of all distributions of LaTeX
version 2009/09/24 or later.

This work has the LPPL maintenance status `maintained'.
The Current Maintainer of this work is Philipp Stephani.
This work consists of all files listed in MANIFEST.
]]
-- '

local function format_header(filename, language)
   local header = filename .. "\n" .. license
   return add_comment(header, language)
end

function output_lua(filename, executable)
   io.output(filename)
   if executable then
      io.write("#!/usr/bin/env lua\n\n")
   end
   io.write(format_header(filename, "lua"))
   io.write("\n")
end

local date = os.date("%Y/%m/%d")
local tpl_provides_file = [[
\ProvidesExplFile { %s } { %s } { %s } { %s }
]]

function output_tex(filename, description)
   io.output(filename)
   io.write(format_header(filename, "tex"))
   io.write(tpl_provides_file:format(filename, date, version, description))
end

function navigate(root, ...)
   local number = select("#", ...)
   local last = select(number, ...)
   local branch = root
   local result = nil
   for index = 1, number do
      if type(branch) == "table" then
         if branch[last] ~= nil then
            result = branch[last]
         end
         local name = select(index, ...)
         if branch[name] ~= nil then
            branch = branch[name]
         end
      else
         return result
      end
   end
   return result
end

local function navigate_default(root, ...)
   local number = select("#", ...)
   local last = select(number, ...)
   local branch = root
   local result = nil
   for index = 1, number do
      if type(branch) == "table" then
         if branch[last] ~= nil then
            result = branch[last]
         end
         local name = select(index, ...)
         if branch[name] ~= nil then
            branch = branch[name]
         end
      else
         return result or branch
      end
   end
   return result or branch
end

function value(data, name)
   local raw = data[name]
   local parent = raw.parent
   if parent then
      return merge(data[parent], raw)
   else
      return deep_copy(raw)
   end
end

function definition(value, engine)
   local raw = value[engine]
   if raw then
      local nondisplay = value.only_display and "display" or "nondisplay"
      local noncramped = value.only_cramped and "cramped" or "noncramped"
      local result = {
         display = {
            cramped = navigate_default(raw, "display", "cramped"),
            noncramped = navigate_default(raw, "display", noncramped),
         },
         nondisplay = {
            cramped = navigate_default(raw, nondisplay, "cramped"),
            noncramped = navigate_default(raw, nondisplay, noncramped)
         }
      }
      if type(raw) == "table" then
         return merge(raw, result)
      else
         return result
      end
   end
end

function is_simple(def)
   return all_deep_equal(def.display.cramped, def.display.noncramped,
                         def.nondisplay.cramped, def.nondisplay.noncramped)
end

local integer_constants = {
   [-1] = "minus_one",
   [0] = "zero",
   [1] = "one",
   [2] = "two",
   [3] = "three",
   [4] = "four",
   [5] = "five",
   [6] = "six",
   [7] = "seven",
   [8] = "eight",
   [9] = "nine",
   [10] = "ten",
   [11] = "eleven",
   [12] = "twelve",
   [13] = "thirteen",
   [14] = "fourteen",
   [15] = "fifteen",
   [16] = "sixteen",
   [32] = "thirty_two",
   [101] = "hundred_one",
   [255] = "twohundred_fifty_five",
   [256] = "twohundred_fifty_six",
   [1000] = "thousand",
   [10000] = "ten_thousand",
   [10001] = "ten_thousand_one",
   [10002] = "ten_thousand_two",
   [10003] = "ten_thousand_three",
   [10004] = "ten_thousand_four",
   [20000] = "twenty_thousand"
}

function int_const(number)
   if type(number) == "number" then
      local s = integer_constants[number]
      if s then
         return "\\c_" .. s
      else
         return number .. "~"
      end
   else
      error("Argument must be a number, but is " .. tostring(number))
   end
end
