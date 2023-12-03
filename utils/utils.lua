local M = {}
local FList = require("utils.FList")

-- @ param {string} str
-- @ param {string} separator
-- @ return {FList}
--
-- Splits a string at separator according to "[^" .. separator .. "]+"
-- separator will default to whitespace "%s" if nil
function M.split(str, separator)
  separator = separator or "%s"
  local result = FList({})
  for value in str:gmatch("[^" .. separator .. "]+") do
    result:add(value)
  end
  return result
end

-- @param {string} str
-- @return {FList}
--
-- Splits a string into chars
function M.chars(str)
  local result = FList({})
  for i = 1, #str, 1 do
    result:add(str:sub(i, i))
  end
  return result
end

function M.print_t(t, depth)
  depth = depth or 0
  for key, value in pairs(t) do
    local offset = ""
    for i = 1, depth, 1 do
      if i == depth then
        offset = offset .. " \u{2514}"
      else
        offset = offset .. "   "
      end
    end
    if type(value) == "table" then
      io.write(offset .. key .. " {\n")
      M.print_t(value, depth + 1)
      io.write(offset:sub(1,#offset -3) .. " }\n")
    else
      io.write(offset .. key .. ": " .. value .. "\n")
    end
  end
end

return M
