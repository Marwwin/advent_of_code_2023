local Vec2D = require("utils.Vec2D")
local u = require("utils.utils")
local AOC = require("AOC")
local Matrix = require("utils.matrix")
local day = {}


function day:part1(input_data)
  print(#input_data, #input_data[1])
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

function day:part2(input_data)
  local board = Matrix(#input_data[1])
  for y, row in ipairs(input_data) do
    for x = 1, #row, 1 do
      local char = row:sub(x, x)
      if char ~= "." then
        print("insert", char)
        board:insert(char, x, y)
      end
    end
  end

  board = day.cycle(board)

  board:print()
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

function day.cycle(board)
  local predicate = function(v) return v == "O" end
  board:scan_up_down(predicate, board.up)
  board:print()
  board:scan_up_down(predicate, board.left)
  board:print()
  board:scan_down_up(predicate, board.down)
  board:print()
  board:scan_right_left(predicate, board.right)
  board:print()
  return board
end

return day
