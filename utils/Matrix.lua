local M = {}

local metatable = {
  __call = function(self, size)
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

function M:insert(value, x, y)
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


function M:move(x, y, direction)
  if direction == "up" or direction == "north" then self:up(x, y) end
  if direction == "down" or direction == "south" then self:down(x, y) end
  if direction == "left" or direction == "west" then self:left(x, y) end
  if direction == "right" or direction == "east" then self:right(x, y) end
end

function M:up(x, y)
  if y == 1 then return x, y end
  self[y - 1][x] = self[y][x]
  self[y][x] = nil
  return x, y - 1
end

function M:down(x, y)
  if y >= self.size then return x, y end
  self[y + 1][x] = self[y][x]
  self[y][x] = nil
  return x, y + 1
end

function M:left(x, y)
  if x == 1 then return x, y end
  self[y][x - 1] = self[y][x]
  self[y][x] = nil
  return x - 1, y
end

function M:right(x, y)
  if x >= self.size then return x, y end
  self[y][x + 1] = self[y][x]
  self[y][x] = nil
  return x + 1, y
end

function M:ninety(m)
  local result = {}
  for x = 1, #m[1], 1 do
    result[x] = {}
   for y = 1, #m, 1 do
      table.insert(result[x],m[y][x] ) 
   end 
  end
  return result
end

return M
