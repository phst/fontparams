#!/usr/bin/env lua

require("fontparams-data")

local tpl_primitive = [[
\luatex_if_engine:F {
  \chk_if_free_cs:N \%s
}
]]

local function format_primitive(name)
   return tpl_primitive:format(name)
end

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

for key, value in pairs(fontparams.data.params) do
   local primitive = value.luatex
   if primitive then
      io.write(format_primitive(primitive))
   end
   if type(key) == "string" then
      io.write(format_macros(key))
   end
end

io.close()
