-- fontparams.lua
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
-- This work has the LPPL maintenance status `maintained'.
-- The Current Maintainer of this work is Philipp Stephani.
-- This work consists of all files listed in MANIFEST.

local err, warn, info, log = luatexbase.provides_module {
   name = "fontparams",
   date = "2010/12/21",
   version = "0.1",
   description = "Engine-independent access to font parameters",
   author = "Philipp Stephani",
   license = "LPPL v1.3+"
}

luatexbase.require_module("fontparams-primitives", "2010/12/21")

local tex = tex
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
