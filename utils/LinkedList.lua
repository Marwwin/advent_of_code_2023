local Node = require("utils.Node")
local LinkedList = {}

local metatable = {
  __call = function(self)
    local o = {}
    setmetatable(o, { __index = LinkedList })
    o._root = nil
    return o
  end
}

setmetatable(LinkedList, metatable)

function LinkedList:add(value)
  if self._root == nil then
    self._root = Node(value)
  else
    local node = self:last()
    node:set_right(Node(value))
  end
end

function LinkedList:root()
  if self._root == nil then return nil, "List has no root" end
  return self._root
end

function LinkedList:pop()
  if self._root == nil then return nil, "List has no root" end
  local to_pop = self._root
  self._root = to_pop:get_right()
  to_pop:set_right(nil)
  return to_pop
end

function LinkedList:last()
  local node = self._root
  if node == nil then return nil, "List has no root" end
  while node:get_right() ~= nil do
    node = node:get_right()
  end
  return node
end

function LinkedList:size()
  local size = 0

  local node = self._root
  while node ~= nil do
    size = size + 1
    node = node:get_right()
  end
  return size
end

function LinkedList:contains(val)
  local node = self._root
  while node ~= nil do
    if node:get_value() == val then return true end
    node = node:get_right()
  end
  return false
end

return LinkedList
