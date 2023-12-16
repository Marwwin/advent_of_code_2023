local AOC = require("AOC")
local FList = require("utils.FList")
local Vec2D = require("utils.Vec2D")
local Queue = require("utils.Queue")
local Stack = require("utils.Stack")
local day = {}

local DIRECTION = Vec2D.DIRECTIONS
local COLOR = {
  reset = "\27[0m",
  red = "\27[31m",
  green = "\27[32m",
  white = "\27[37m",
  yellow = "\27[33m",
  blue = "\27[34m",
  magenta = "\27[35m",
}

function day:part1(input_data)
  local matrix = {}
  local width = #input_data[1]

  for y = 1, #input_data, 1 do
    table.insert(matrix, {})
    for x = 1, #input_data[1], 1 do
      if input_data[y]:sub(x, x) ~= "." then
        matrix[y][x] = input_data[y]:sub(x, x)
      end
    end
  end

  local i = 0
  local prev_set_size = 0
  local prev_set_size2 = 0
  local q = Queue()
  local created = FList {}
  local set = FList {}
  q:push(day.create_beam(Vec2D(1, 1), DIRECTION.RIGHT))
  while q:top() do
    local current = q:pop()

    print(current)
    set[current.position:to_string()] = true
    local beam, split = day.move(current, matrix, width, created)

    if beam ~= nil then
      --       print("beam", beam.position:to_string(), beam.direction)
      if day.is_in_loop(beam) == false then
      
        q:push(beam)
      end
    end
    if split ~= nil then
      if day.is_in_loop(split) == false then
        --       print("stack", split.position:to_string(), split.direction)
        q:push(split)
      end
    end
    --     print("iteration:",i,"visited amount:",set:size())
    --     if i % 5000 == 0 and set:size() == prev_set_size and set:size() == prev_set_size2 then return set:size() end
    --     prev_set_size2 = prev_set_size
    --     prev_set_size = set:size()
    --     print(set:size())
    --     day.print(current, matrix, width, set)
    i = i + 1
  end

  return set:size()
end

function day.is_in_loop(bean, start, count)
  if bean == nil then return false end
  start = start or bean
  count = count or 0
  if bean.position:equals(start) and bean.direction == start.direction then
    count = count + 1
    if count > 3 then return true end
  end
  return day.is_in_loop(bean.parent, start, count)
end

function day.print(current, matrix, width, set)
  os.execute("sleep 0.01")
  os.execute("clear")
  for y = 1, width, 1 do
    for x = 1, width, 1 do
      local symbol = matrix[y][x]
      if current.position.x == x and current.position.y == y then
        io.write(COLOR.yellow .. " * " .. COLOR.reset)
      elseif set[x .. " " .. y] == true then
        io.write(COLOR.red .. " # " .. COLOR.reset)
      elseif matrix[y][x] ~= nil then
        io.write(" " .. symbol .. " ")
      else
        io.write(" . ")
      end
      io.flush()
    end
    print()
  end
end

function day:part2(input_data)
end

function day.create_beam(position, direction, parent)
  position = position or Vec2D(1, 1)
  direction = direction or DIRECTION.RIGHT

  return { position = position, direction = direction, parent = parent }
end

function day.move(beam, matrix, width, created)
  local pos = beam.position
  local dir = beam.direction
  --   print(beam.position:str(), "moving", beam.direction, "size", #matrix, width)

  if (pos.x == 1 and dir == DIRECTION.LEFT) or
      (pos.x == width and dir == DIRECTION.RIGHT) or
      (pos.y == 1 and dir == DIRECTION.INVERT_UP) or
      (pos.y == #matrix and dir == DIRECTION.INVERT_DOWN) then
    return nil
  end



  local map_char = matrix[pos.y][pos.x]

  --   print("symbol at new pos", map_char)
  local split
  if map_char == "\\" then
    if beam.direction == DIRECTION.RIGHT then
      beam.direction = DIRECTION.INVERT_DOWN
    elseif beam.direction == DIRECTION.LEFT then
      beam.direction = DIRECTION.INVERT_UP
    elseif beam.direction == DIRECTION.INVERT_UP then
      beam.direction = DIRECTION.LEFT
    elseif beam.direction == DIRECTION.INVERT_DOWN then
      beam.direction = DIRECTION.RIGHT
    end
  end
  if map_char == "/" then
    --     print("  sohuld go up", beam.direction == DIRECTION.RIGHT)
    if beam.direction == DIRECTION.RIGHT then
      beam.direction = DIRECTION.INVERT_UP
    elseif beam.direction == DIRECTION.LEFT then
      beam.direction = DIRECTION.INVERT_DOWN
    elseif beam.direction == DIRECTION.INVERT_DOWN then
      beam.direction = DIRECTION.LEFT
    elseif beam.direction == DIRECTION.INVERT_UP then
      beam.direction = DIRECTION.RIGHT
    end
    --     print("  ", beam.direction)
  end
  if map_char == "|" then
    if beam.direction == DIRECTION.LEFT or beam.direction == DIRECTION.RIGHT then
      beam.direction = DIRECTION.INVERT_UP
      split = day.create_beam(beam.position, DIRECTION.INVERT_DOWN, beam)
    end
  end
  if map_char == "-" then
    if beam.direction == DIRECTION.INVERT_UP or beam.direction == DIRECTION.INVERT_DOWN then
      beam.direction = DIRECTION.LEFT
      split = day.create_beam(beam.position, DIRECTION.RIGHT, beam)
    end
  end
  local new_pos = beam.position:move(beam.direction)
  beam.position = new_pos
  if new_pos == nil then return nil end

  return day.create_beam(beam.position, beam.direction, beam), split
end

function day.turn(beam, direction)
  beam.direction = direction
  return beam
end

return day
