local FList = require("utils.FList")
local Q = {}

local metatable = {
  __call = function(self)
    return Q.new()
  end,
  __index = Q
}

function Q.new()
  return setmetatable({heap = FList({})},metatable)
end

setmetatable(Q, metatable)

function Q:top()
  return self.heap[1]
end

function Q:push(value, priority)
  if type(priority) == "function" then
    priority = priority(value)
  end
  table.insert(self.heap, { value = value, priority = priority })
  self:upheap()
end

function Q:pop()
  local heap = self.heap
  if #heap == 0 then return nil end
  if #heap == 1 then return table.remove(heap) end

  local top = heap[1]
  heap[1] = table.remove(heap)
  self:downheap()
  return top
end

function Q:upheap()
  local heap = self.heap
  local child = #heap
  while child > 1 do
    local parent = math.floor(child / 2)
    if heap[child].priority < heap[parent].priority then
      heap[parent], heap[child] = heap[child], heap[parent]
      child = parent
    else
      break
    end
  end
end

function Q:downheap()
  local heap = self.heap
  local parent = 1
  local heapSize = #heap
  while true do
    local left = parent * 2
    local right = parent * 2 + 1
    local smallest = parent

    if left <= heapSize and heap[left].priority < heap[smallest].priority then smallest = left end
    if right <= heapSize and heap[right].priority < heap[smallest].priority then smallest = right end

    if smallest ~= parent then
      heap[parent], heap[smallest] = heap[smallest], heap[parent]
      parent = smallest
    else
      break
    end
  end
end

function Q:print()
  for _, value in pairs(self.heap) do
    print(value.value,value.priority)
  end
end

function Q.from_keys(list, priority_fn)
  local heap = Q()
  for key, _ in pairs(list) do
    heap:push(key,priority_fn)
  end
  return heap
end

function Q:size()
  local result = 0
  for _, _ in pairs(self.heap) do
    result = result + 1
  end
  return result
end

local priority = {}
Q.priority = priority
function priority.char_value(char)
  return char:byte() - 96
end

return Q
