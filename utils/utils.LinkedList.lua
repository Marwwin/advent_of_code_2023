local LinkedList = {}

local metatable = {
  __call = function(self)
    local o = {}
    setmetatable(o, { __index = LinkedList })
    return o
  end
}


return LinkedList
