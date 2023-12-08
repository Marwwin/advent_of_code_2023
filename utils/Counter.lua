local u = require("utils.utils")
local FList = require("utils.FList")
local Counter = {}

local metatable = {
  __call = function(self, obj)
    local c = {}
    if type(obj) == "string" then
      for i = 1, #obj do
        local e = obj:sub(i, i)
        if c[e] == nil then
          c[e] = { key = e, amount = 1 }
        else
          c[e].amount = c[e].amount + 1
        end
      end
    end
    local cc = {}
    for key, value in pairs(c) do
      table.insert(cc, value)
    end
    table.sort(cc, function(a, b) return a.amount > b.amount end)
    local o = setmetatable(cc, { __index = self })
    return o
  end
}
setmetatable(Counter, metatable)

function Counter:most_common(n)
  n = n or 1
  return FList(self):take(n)
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
