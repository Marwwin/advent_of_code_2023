local Node = {}

local metatable = {
  __call = function(self, value)
    if value == nil then return nil, "Node value cannot be nil" end
    local o = { value = value }
    setmetatable(o, { __index = self })
    return o
  end
}

setmetatable(Node, metatable)

function Node:get_value() return self.value end

function Node:set_left(node) self.left = node end

function Node:get_left()
  if self.left == nil then return nil, (self.value .. " left child not set") end
  return self.left
end

function Node:set_right(node) self.right = node end

function Node:get_right()
  if self.right == nil then return nil end
  return self.right
end

function Node:add_child(child)
  if not self.children then self.children = {} end
  table.insert(self.children, child)
end

function Node:get_children()
  if self.children == nil then return nil, (self.value .. " has no children") end
  return self.children
end

function Node:get_parent()
  if self.parent == nil then return nil, (self.value .. " has no parent") end
  return self.parent
end

function Node:set_parent(node)
  self.parent = node
end

return Node
