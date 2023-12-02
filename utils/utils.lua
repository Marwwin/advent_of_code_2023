local M = {}
local FList = require("utils.FList")

function M.split(str, separator)
  separator = separator or "%s"
  local result = FList({})
  for value in str:gmatch("[^" .. separator.. "]+") do
    table.insert(result, value)
  end
  return result
end

return M
