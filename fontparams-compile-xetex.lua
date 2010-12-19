require("fontparams-data")

io.output("fontparams-xetex.def")

for key, value in pairs(fontparams.data.params) do
   local raw = value.xetex
   if raw then
      local simple = type(raw) == "number"
      local def
      if simple then
         def = {
            display = {
               cramped = raw,
               noncramped = raw
            },
            nondisplay = {
               cramped = raw,
               noncramped = raw
            }
         }
      else
         def = {
            display = { },
            nondisplay = { }
         }
         if raw.display then
            if type(raw.display) == "number" then
               def.display = {
                  cramped = raw.display,
                  noncramped = raw.display
               }
            else
               def.display = {
                  cramped = raw.display.cramped or raw.cramped,
                  noncramped = raw.display.noncramped or raw.noncramped
               }
            end
         else
            def.display = raw
         end
         if raw.nondisplay then
            if type(raw.nondisplay) == "number" then
               def.nondisplay = {
                  cramped = raw.nondisplay,
                  noncramped = raw.nondisplay
               }
            else
               def.nondisplay = {
                  cramped = raw.nondisplay.cramped or raw.cramped,
                  noncramped = raw.nondisplay.noncramped or raw.noncramped
               }
            end
         else
            def.nondisplay = raw
         end
      end
      local primitive = value.luatex
      local vtype = value.type or "dimen"
      if primitive then
         io.write("\\cs_set_protected_nopar:Npn \\" .. primitive .. " #1 {\n")
         if vtype == "int" then
            io.write("  \\numexpr\n")
         end
         if simple then
            io.write("  \\fontdimen " .. def.nondisplay.noncramped .. " \\textfont \\c_two \n")
         else
            io.write("  \\fontdimen \n"
                     .. "  \\cs_if_eq:NNTF #1 \\displaystyle { " .. def.display.noncramped .. " \\textfont } {\n"
                     .. "    \\cs_if_eq:NNTF #1 \\crampeddisplaystyle { " .. def.display.cramped .. " \\textfont } {\n"
                     .. "      \\cs_if_eq:NNTF #1 \\textstyle { " .. def.nondisplay.noncramped .. " \\textfont } {\n"
                     .. "        \\cs_if_eq:NNTF #1 \\crampedtextstyle { " .. def.nondisplay.cramped .. " \\textfont } {\n"
                     .. "          \\cs_if_eq:NNTF #1 \\scriptstyle { " .. def.nondisplay.noncramped .. " \\scriptfont } {\n"
                     .. "            \\cs_if_eq:NNTF #1 \\crampedscriptstyle { " .. def.nondisplay.cramped .. " \\scriptfont } {\n"
                     .. "              \\cs_if_eq:NNTF #1 \\scriptscriptstyle { " .. def.nondisplay.noncramped .. " \\scriptscriptfont } {\n"
                     .. "                \\cs_if_eq:NNTF #1 \\crampedscriptscriptstyle { " .. def.nondisplay.cramped .. " \\scriptscriptfont } {\n"
                     .. "                  \\msg_error:nnx { fontparams } { unknown-style } { \\token_to_str:N #1 }\n"
                     .. "                }\n"
                     .. "              }\n"
                     .. "            }\n"
                     .. "          }\n"
                     .. "        }\n"
                     .. "      }\n"
                     .. "    }\n"
                     .. "  }\n"
                     .. "  \\c_two \n")
         end
         if vtype == "int" then
            io.write("  \\relax\n")
         end
         io.write("}\n")
      end
      if vtype == "int" then
         io.write("\\cs_set_protected_nopar:Npn \\fontparams_font_get_" .. key .. ":N #1 {\n"
                  .. "  \\numexpr\n"
                  .. "  \\fontdimen " .. def.nondisplay.noncramped .. " #1\n"
                  .. "  \\relax\n"
                  .. "}\n")
         io.write("\\cs_set_protected_nopar:Npn \\fontparams_font_set_" .. key .. ":Nn #1 #2 {\n"
                  .. "  \\fontdimen " .. def.nondisplay.noncramped .. " #1 \\dimexpr \\numexpr #2 \\relax sp \\relax\n"
                  .. "}\n")
      else
         io.write("\\cs_set_protected_nopar:Npn \\fontparams_font_get_" .. key .. ":N #1 {\n"
                  .. "  \\fontdimen " .. def.nondisplay.noncramped .. " #1\n"
                  .. "}\n")
         io.write("\\cs_set_protected_nopar:Npn \\fontparams_font_set_" .. key .. ":Nn #1 #2 {\n"
                  .. "  \\fontdimen " .. def.nondisplay.noncramped .. " #1 \\dimexpr #2 \\relax\n"
                  .. "}\n")
      end
      if primitive then
         io.write("\\cs_set_protected_nopar:Npn \\fontparams_style_get_" .. key .. ":N #1 {\n"
                  .. "  \\" .. primitive .. " #1\n"
                  .. "}\n")
         if vtype == "dimen" then
            io.write("\\cs_set_protected_nopar:Npm \\fontparams_style_set_" .. key .. ":Nn #1 #2 {\n"
                     .. "  \\" .. primitive .. " #1 \\dimexpr #2 \\relax\n"
                     .. "}\n")
         end
      end
   end
end

io.close()
