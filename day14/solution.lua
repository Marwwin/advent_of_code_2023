local Vec2D = require("utils.Vec2D")
local u = require("utils.utils")
local Matrix = require("utils.Matrix")
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

  --   for y = 1, #input_data, 1 do
  --     for x = 1, #input_data[1], 1 do
  --       local char = Vec2D(x, y):to_string()
  --       if board[char] then
  --         io.write(board[char])
  --       else
  --         io.write(".")
  --       end
  --     end
  --     io.write("\n")
  --   end

  return result
end

function day:part2(input_data)
  local board = Matrix(#input_data[1])
  for y, row in ipairs(input_data) do
    for x = 1, #row, 1 do
      local char = row:sub(x, x)
      if char ~= "." then
        board:insert(char, x, y)
      end
    end
  end

  for i = 1, 1000, 1 do
    board = day.cycle(board)
    print("i",i,"value",day.count_part2(board))
  end

  return day.count_part2(board)
end

function day.count_part2(board)
  local result = 0
  for y = 1, board.size, 1 do
    for x = 1, board.size, 1 do
      if board[y][x] == "O" then result = result + board.size - y + 1 end
    end
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

function day.cycle(board)
  board = day.tilt_north(board)
  board = day.tilt_west(board)
  board = day.tilt_south(board)
  board = day.tilt_east(board)
  return board
end

function day.tilt_north(board)
  for y = 1, board.size, 1 do
    for x = 1, board.size, 1 do
      if board[y][x] == "O" then
        day.move_north(board, x, y)
      end
    end
  end
  return board
end

function day.move_north(board, x, y)
  if y == 1 then return end
  while y ~= 1 and (board[y - 1][x] ~= "#" and board[y - 1][x] ~= "O") do
    x, y = board:up(x, y)
  end
end

function day.tilt_west(board)
  for y = 1, board.size, 1 do
    for x = 1, board.size, 1 do
      if board[y][x] == "O" then
        day.move_west(board, x, y)
      end
    end
  end
  return board
end

function day.move_west(board, x, y)
  if x == 1 then return end
  while x ~= 1 and (board[y][x - 1] ~= "#" and board[y][x - 1] ~= "O") do
    x, y = board:left(x, y)
  end
end

function day.tilt_south(board)
  for y = board.size, 1, -1 do
    for x = 1, board.size, 1 do
      if board[y][x] == "O" then
        day.move_south(board, x, y)
      end
    end
  end
  return board
end

function day.move_south(board, x, y)
  if y == board.size then return end
  while y ~= board.size and (board[y + 1][x] ~= "#" and board[y + 1][x] ~= "O") do
    x, y = board:down(x, y)
  end
end

function day.tilt_east(board)
  for y = 1, board.size, 1 do
    for x = board.size, 1, -1 do
      if board[y][x] == "O" then
        day.move_east(board, x, y)
      end
    end
  end
  return board
end

function day.move_east(board, x, y)
  if x == board.size then return end
  while x ~= board.size and (board[y][x + 1] ~= "#" and board[y][x + 1] ~= "O") do
    x, y = board:right(x, y)
  end
end

return day
