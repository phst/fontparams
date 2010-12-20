#!/usr/bin/env lua

require("fontparams-data")

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
