local type = type
local pairs = pairs
local select = select

module("fontparams.compile")

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

local function equal_numbers(...)
   local length = select("#", ...)
   if length > 0 then
      local first = select(1, ...)
      for index = 2, length do
         if select(index, ...) ~= first then
            return false
         end
      end
   end
   return true
end

function is_simple(def)
   return equal_numbers(def.display.cramped, def.display.noncramped,
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
   local s = integer_constants[number]
   if s then
      return "\\c_" .. s
   else
      return number .. "~"
   end
end
