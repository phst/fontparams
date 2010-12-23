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
-- The Current Maintainer of this work is Philipp Stephani.
-- This work consists of all files listed in MANIFEST.

require("fontparams-data")
require("fontparams-compile")

local params = fontparams.data.params
local common = fontparams.compile

local tpl_font_get_dimen = [[
  \dimexpr
  \lua_now:x {
    tex.sprint(font.getfont(font.id(" \cs_to_str:N #1 ")).MathConstants.%s)
  } sp
  \relax]]

local tpl_font_get_int = [[
  \numexpr
  \lua_now:x {
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
  \lua_now:x {
    font.getfont(font.id(" \cs_to_str:N #1 ")).MathConstants.%s = \number \dimexpr #2 \relax
  }]]

local tpl_font_set_int = [[
  \lua_now:x {
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
\cs_new_protected_nopar:Npn \fontparams_font_get_%s:N #1 {
%s
}
\cs_new_protected_nopar:Npn \fontparams_font_set_%s:Nn #1 #2 {
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

local tpl_style_get_display = [[
  \exp_last_unbraced:Nf \%s {
    \cs_if_eq:NNTF #1 \displaystyle { \displaystyle } {
      \cs_if_eq:NNTF #1 \crampeddisplaystyle { \crampeddisplaystyle } {
        \cs_if_eq:NNTF #1 \textstyle { \displaystyle } {
          \cs_if_eq:NNTF #1 \crampedtextstyle { \crampeddisplaystyle } {
            \cs_if_eq:NNTF #1 \scriptstyle { \displaystyle } {
              \cs_if_eq:NNTF #1 \crampedscriptstyle { \crampeddisplaystyle } {
                \cs_if_eq:NNTF #1 \scriptscriptstyle { \displaystyle } {
                  \cs_if_eq:NNTF #1 \crampedscriptscriptstyle { \crampeddisplaystyle } {
                    \msg_error:nnx { fontparams } { unknown-style } { \token_to_str:N #1 }
                  }
                }
              }
            }
          }
        }
      }
    }
  }]]

local tpl_style_get_cramped = [[
  \exp_last_unbraced:Nf \%s {
    \cs_if_eq:NNTF #1 \displaystyle { \crampeddisplaystyle } {
      \cs_if_eq:NNTF #1 \crampeddisplaystyle { \crampeddisplaystyle } {
        \cs_if_eq:NNTF #1 \textstyle { \crampedtextstyle } {
          \cs_if_eq:NNTF #1 \crampedtextstyle { \crampedtextstyle } {
            \cs_if_eq:NNTF #1 \scriptstyle { \crampedscriptstyle } {
              \cs_if_eq:NNTF #1 \crampedscriptstyle { \crampedscriptstyle } {
                \cs_if_eq:NNTF #1 \scriptscriptstyle { \crampedscriptscriptstyle } {
                  \cs_if_eq:NNTF #1 \crampedscriptscriptstyle { \crampedscriptscriptstyle } {
                    \msg_error:nnx { fontparams } { unknown-style } { \token_to_str:N #1 }
                  }
                }
              }
            }
          }
        }
      }
    }
  }]]

local function format_style_get(primitive, value)
   if value.only_display then
      return tpl_style_get_display:format(primitive)
   elseif value.only_cramped then
      return tpl_style_get_cramped:format(primitive)
   else
      return tpl_style_get:format(primitive)
   end
end

local tpl_style_set = [[
%s \%s #2 \relax]]

local expression_cmd = {
   int = "numexpr",
   dimen = "dimexpr"
}

local function format_style_set(primitive, value)
   local vtype = value.type or "dimen"
   local cmd = expression_cmd[vtype]
   local get = format_style_get(primitive, value)
   return tpl_style_set:format(get, cmd)
end

local tpl_style_macros = [[
\cs_new_protected_nopar:Npn \fontparams_style_get_%s:N #1 {
%s
}
\cs_new_protected_nopar:Npn \fontparams_style_set_%s:Nn #1 #2 {
%s
}
]]

local function format_style_macros(name, primitive, value)
   local get = format_style_get(primitive, value)
   local set = format_style_set(primitive, value)
   return tpl_style_macros:format(name, get, name, set)
end

tpl_undefine = [[
\fontparams_undefine:N \%s
]]

local function format_undefine(name)
   return tpl_undefine:format(name)
end

io.output("fontparams-luatex.def")
io.write(common.tex_license("fontparams-luatex.def"))

for key, dummy in pairs(params) do
   local value = common.value(params, key)
   local vtype = value.type or "dimen"
   if type(key) == "string" then
      io.write(format_font_macros(key, vtype))
      local primitive = value.luatex
      if primitive then
         io.write(format_style_macros(key, primitive, value))
      end
   end
   local primitive = dummy.luatex
   if primitive then
      io.write(format_undefine(primitive))
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

for key, value in pairs(params) do
   local primitive = value.luatex
   if primitive then
      table.insert(primitives, format_primitive(primitive))
   end
end

local list = table.concat(primitives, ",\n  ")

io.output("fontparams-primitives.lua")
io.write(common.lua_license("fontparams-primitives.lua"))
io.write(format_primitive_list(list))
io.close()
