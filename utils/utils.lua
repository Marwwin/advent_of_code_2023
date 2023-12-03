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

function M.print_t(t)
  for key, value in pairs(t) do
    if type(value) == "table" then
      print(key)
      M.print_t(value)
    else
      print(key, value)
    end
  end
end

return M
