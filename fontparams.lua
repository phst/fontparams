-- fontparams.lua
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

local module_info = {
   name = "fontparams",
   date = "2011/01/03",
   version = "0.1",
   description = "Engine-independent access to font parameters",
   author = "Philipp Stephani",
   license = "LPPL v1.3+"
}

local err = luatexbase.provides_module(module_info)

luatexbase.require_module("fontparams-primitives", module_info.date)

local tostring = tostring
local font = font
local tex = tex
local cct_string = luatexbase.catcodetables.string
local primitives = fontparams.primitives.list

module("fontparams")

local cramped_styles = {
   "crampeddisplaystyle",
   "crampedtextstyle",
   "crampedscriptstyle",
   "crampedscriptscriptstyle"
}

function activate_primitives()
   tex.enableprimitives("", cramped_styles)
   tex.enableprimitives("", primitives)
end

local function get_constants(font_name)
   local id = font.id(font_name)
   if id and id ~= -1 then
      local fnt = font.getfont(id)
      if fnt then
         local const = fnt.MathConstants
         if const then
            return const
         else
            err("Font \\%s has no mathematical font parameter table", font_name)
         end
      else
         err("Unknown font identifier %d", id)
      end
   else
      err("Unknown font \\%s", font_name)
   end
end

function print_value(font_name, param_name)
   local const = get_constants(font_name)
   local val = const[param_name]
   if val then
      local res = tostring(val)
      tex.sprint(cct_string, res)
   else
      err("Font \\%s does not contain font parameter %s", font_name, param_name)
   end
end

function set_value(font_name, param_name, value)
   local const = get_constants(font_name)
   const[param_name] = value
end
