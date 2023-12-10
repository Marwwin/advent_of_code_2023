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

function M.sum(list)
  local sum = 0
  for key, value in pairs(list) do
    sum = sum + value
  end
  return sum
end

function M.size(list)
  local size = 0
  for ket, value in pairs(list) do
    size = size + 1
  end
  return size
end

function M.gcd(a, b)
  while b ~= 0 do
    a, b = b, a % b
  end
  return a
end

function M.lcm(a, b) return (a * b) / M.gcd(a, b) end

function M.lcm_of_list(list)
  local result = list[1]
  for i = 2, #list do
    result = M.lcm(result, list[i])
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
      io.write(offset:sub(1, #offset - 3) .. " }\n")
    else
      io.write(offset .. key .. ": " .. value .. "\n")
    end
  end
end

return M
