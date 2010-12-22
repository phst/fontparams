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

local type = type
local pairs = pairs
local select = select

module("fontparams.compile")

local tpl_tex_license = [[
%% %s
%% Copyright 2010 Philipp Stephani
%%
%% This work may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.3c
%% of this license or (at your option) any later version.
%% The latest version of this license is in
%%   http://www.latex-project.org/lppl.txt
%% and version 1.3c or later is part of all distributions of LaTeX
%% version 2009/09/24 or later.
%%
%% This work has the LPPL maintenance status `maintained'.
%%
%% The Current Maintainer of this work is Philipp Stephani.
%%
%% This work consists of the files fontparams.dtx, fontparams.ins,
%% fontparams.lua, fontparams-data.lua, fontparams-compile.lua,
%% fontparams-compile-common.lua, fontparams-compile-legacy.lua,
%% fontparams-compile-luatex.lua, fontparams-compile-xetex.lua,
%% fontparams-compile-pdftex.lua, fontparams-test.tex, build-test.sh,
%% fontparams.el, Makefile and README.rst
%% and the derived files fontparams.sty, fontparams.def,
%% fontparams-legacy.def, fontparams-luatex.def, fontparams-xetex.def,
%% fontparams-pdftex.def and fontparams-primitives.lua.
]]

function tex_license(filename)
   return tpl_tex_license:format(filename)
end

local tpl_lua_license = [[
-- %s
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
]]

function lua_license(filename)
   return tpl_lua_license:format(filename)
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

function navigate_default(root, ...)
   local number = select("#", ...)
   local branch = root
   for index = 1, number do
      if type(branch) == "table" then
         local name = select(index, ...)
         if branch[name] ~= nil then
            branch = branch[name]
         end
      else
         return branch
      end
   end
   return branch
end

function inflate(raw)
   if raw then
      result = {
         display = {
            cramped = navigate_default(raw, "display", "cramped"),
            noncramped = navigate_default(raw, "display", "noncramped"),
         },
         nondisplay = {
            cramped = navigate_default(raw, "nondisplay", "cramped"),
            noncramped = navigate_default(raw, "nondisplay", "noncramped")
         }
      }
      if type(raw) == "table" then
         for key, value in pairs(raw) do
            if result[key] == nil then
               result[key] = value
            end
         end
      end
      return result
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

local function all_equal(...)
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

function is_simple(def)
   return all_equal(def.display.cramped, def.display.noncramped,
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
      error("Argument must be a number")
   end
end
