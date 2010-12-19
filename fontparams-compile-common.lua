require("fontparams-data")

io.output("fontparams.def")

for key, value in pairs(fontparams.data.params) do
   local primitive = value.luatex
   if primitive then
      io.write("\\luatex_if_engine:F {\n"
               .. "  \\chk_if_free_cs:N \\" .. primitive .. "\n"
               .. "}\n")
   end
   if type(key) == "string" then
      io.write("\\chk_if_free_cs:N \\fontparams_font_get_" .. key .. ":N\n")
      io.write("\\chk_if_free_cs:N \\fontparams_font_set_" .. key .. ":Nn\n")
      io.write("\\chk_if_free_cs:N \\fontparams_style_get_" .. key .. ":N\n")
      io.write("\\chk_if_free_cs:N \\fontparams_style_set_" .. key .. ":Nn\n")
   end
end

io.close()
