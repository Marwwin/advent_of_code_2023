local M = {}

local metatable = {
  __call = function(self,size)
    local matrix = {}
    for _ = 1, size do
      local row = {}
      for _ = 1, size do
        table.insert(row, nil)
      end
      table.insert(matrix, row)
    end
    matrix.size = size
    setmetatable(matrix, { __index = M })
    return matrix
  end
}
setmetatable(M, metatable)

function M:insert(value,x,y)
  self[y][x] = value
end

function M:print()
  print(self)
  for x = 1, self.size do
    for y = 1, self.size do
      local value = self[x][y]
      if value then
        io.write(value)
      else
        io.write(".")
      end
    end
    io.write("\n")
  end
end

function M:scan_up_down(predicate, fn)
  for y = 1, self.size, 1 do
    for x = 1, self.size, 1 do
      print(self[y][x],predicate(self[y][x]))
      if predicate(self[y][x]) then print("moving") fn(self,x, y) end
    end
  end
end

function M:scan_down_up(predicate, fn)
  for y = self.size, 1, -1 do
    for x = 1, self.size, 1 do
      if predicate(self[y][x]) then fn(self,x, y) end
    end
  end
end

function M:scan_right_left(predicate, fn)
  for y = 1, self.size, 1 do
    for x = self.size, 1, -1 do
      if predicate(self[y][x]) then fn(self,x, y) end
    end
  end
end

function M:move(x, y, direction)
  if direction == "up" or direction == "north" then self:up(x, y) end
  if direction == "down" or direction == "south" then self:down(x, y) end
  if direction == "left" or direction == "west" then self:left(x, y) end
  if direction == "right" or direction == "east" then self:right(x, y) end
end

function M:up(x, y)
  self[y - 1][x] = self[y][x]
  self[y][x] = nil
end

function M:down(x, y)
  self[y + 1][x] = self[y][x]
  self[y][x] = nil
end

function M:left(x, y)
  self[y][x - 1] = self[y][x]
  self[y][x] = nil
end

function M:rigth(x, y)
  self[y][x + 1] = self[y][x]
  self[y][x] = nil
end

return M
