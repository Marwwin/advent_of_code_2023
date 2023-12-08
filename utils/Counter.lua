local u = require("utils.utils")
local FList = require("utils.FList")
local Counter = {}

local metatable = {
  __call = function(self, obj)
    local counter = {}
    if type(obj) == "string" then
      for i = 1, #obj do
        local e = obj:sub(i, i)
        if counter[e] == nil then
          counter[e] = { key = e, amount = 1 }
        else
          counter[e].amount = counter[e].amount + 1
        end
      end
    end
    if type(obj) == "table" then
      for key, value in pairs(obj) do
        if counter[value] == nil then
          counter[value] = { key = value, amount = 1 }
        else
          counter[value].amount = counter[value].amount + 1
        end
      end
    end
    local sortable = {}
    for _, value in pairs(counter) do
      table.insert(sortable, value)
    end
    table.sort(sortable, function(a, b) return a.amount > b.amount end)
    return setmetatable(sortable, { __index = self })
  end
}
setmetatable(Counter, metatable)

function Counter:most_common(n)
  n = n or 1
  local result = {}
  for i = 1, n, 1 do
    table.insert(result, self[i])
  end
  return result
end

function Counter.count_char(ch, str)
  local result = 0
  for i = 1, #str, 1 do
    if ch == str:sub(i, i) then
      result = result + 1
    end
  end
  return result
end

return Counter
