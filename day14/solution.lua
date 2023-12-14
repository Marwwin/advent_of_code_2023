local Vec2D = require("utils.Vec2D")
local u = require("utils.utils")
local AOC = require("AOC")
local day = {}


function day:part1(input_data)
  local board = {}
  local rocks = {}
  local boulders = {}
  for y, row in ipairs(input_data) do
    for x = 1, #row, 1 do
      local char = row:sub(x, x)
      if char == "O" then
        table.insert(rocks, Vec2D(x, y))
        board[Vec2D(x, y):to_string()] = "0"
      end
      if char == "#" then
        table.insert(boulders, Vec2D(x, y))
        board[Vec2D(x, y):to_string()] = "#"
      end
    end
  end

  for index, rock in ipairs(rocks) do
    local b, r = day.roll_rock(rock, board)
    board = b
    rocks[index] = r
  end
  local result = 0
  for index, rock in ipairs(rocks) do
    local load = #input_data - rock.y + 1
    result = result + load
  end

  for y = 1, #input_data, 1 do
    for x = 1, #input_data[1], 1 do
      local char = Vec2D(x, y):to_string()
      if board[char] then
        io.write(board[char])
      else
        io.write(".")
      end
    end
    io.write("\n")
  end

  return result
end

function day.roll_rock(rock, board, width, height, dir)
  width = width or 10000
  height = height or 10000
  dir = dir or "north"

  board[rock:to_string()] = nil
  while board[rock:move(dir):to_string()] == nil and rock.y > 1 and rock.y <= height and rock.x > 1 and rock.x <= width do
    rock = rock:move(dir)
  end
  board[rock:to_string()] = "0"
  return board, rock
end

function day:part2(input_data)
  local board = {}
  local rocks = {}
  local boulders = {}
  for y, row in ipairs(input_data) do
    for x = 1, #row, 1 do
      local char = row:sub(x, x)
      if char == "O" then
        table.insert(rocks, Vec2D(x, y))
        board[Vec2D(x, y):to_string()] = "0"
      end
      if char == "#" then
        table.insert(boulders, Vec2D(x, y))
        board[Vec2D(x, y):to_string()] = "#"
      end
    end
  end

  for i = 1, 1, 1 do
    board, rocks = day.cycle(rocks, board, input_data, "north")
    board, rocks = day.cycle(rocks, board, input_data, "west")
    --     board, rocks = day.cycle(rocks,board,input_data,"south")
    --     board, rocks = day.cycle(rocks,board,input_data,"east")
  end
  local result = 0
  for index, rock in ipairs(rocks) do
    local load = #input_data - rock.y + 1
    result = result + load
  end

  for y = 1, #input_data, 1 do
    for x = 1, #input_data[1], 1 do
      local char = Vec2D(x, y):to_string()
      if board[char] then
        io.write(board[char])
      else
        io.write(".")
      end
    end
    io.write("\n")
  end

  return result
end

function day.cycle(rocks, board, input_data, dir)
  for index, rock in ipairs(rocks) do -- this needs to be sorted each time to do the rocks in correct order
    local b, r
    b, r = day.roll_rock(rock, board, #input_data[1], #input_data, dir)
    board = b
    rocks[index] = r
  end
  return board, rocks
end

return day
