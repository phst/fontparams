require("fontparams-data")

io.output("fontparams-luatex.def")

for key, value in pairs(fontparams.data.params) do
   local vtype = value.type or "dimen"
   if type(key) == "string" then
      local primitive = value.luatex
      if vtype == "int" then
         io.write("\\cs_set_protected_nopar:Npn \\fontparams_font_get_" .. key .. ":N #1 {\n"
                  .. "  \\numexpr\n"
                  .. "  \\directlua {\n"
                  .. "    tex.sprint(font.getfont(font.id(\" \\cs_to_str:N #1 \")).MathConstants." .. key .. ")\n"
                  .. "  }\n"
                  .. "  \\relax\n"
                  .. "}\n")
         io.write("\\cs_set_protected_nopar:Npn \\fontparams_font_set_" .. key .. ":Nn #1 #2 {\n"
                  .. "  \\directlua {\n"
                  .. "    font.getfont(font.id(\" \\cs_to_str:N #1 \")).MathConstants." .. key .. " = \\numexpr #2 \\relax\n"
                  .. "  }\n"
                  .. "}\n")
      else
         io.write("\\cs_set_protected_nopar:Npn \\fontparams_font_get_" .. key .. ":N #1 {\n"
                  .. "  \\dimexpr\n"
                  .. "  \\directlua {\n"
                  .. "    tex.sprint(font.getfont(font.id(\" \\cs_to_str:N #1 \")).MathConstants." .. key .. ")\n"
                  .. "  } sp\n"
                  .. "  \\relax\n"
                  .. "}\n")
         io.write("\\cs_set_protected_nopar:Npn \\fontparams_font_set_" .. key .. ":Nn #1 #2 {\n"
                  .. "  \\directlua {\n"
                  .. "    font.getfont(font.id(\" \\cs_to_str:N #1 \")).MathConstants." .. key .. " = \\dimexpr #2 \\relax\n"
                  .. "  }\n"
                  .. "}\n")
      end
      if primitive then
         io.write("\\cs_set_protected_nopar:Npn \\fontparams_style_get_" .. key .. ":N #1 {\n"
                  .. "   \\" .. primitive .. " #1\n"
                  .. "}\n")
         io.write("\\cs_set_protected_nopar:Npm \\fontparams_style_set_" .. key .. ":Nn #1 #2 {\n"
                  .. "  \\" .. primitive .. " #1 \\dimexpr #2 \\relax\n"
                  .. "}\n")
      end
   end
end

io.close()
