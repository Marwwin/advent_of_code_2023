local Vec2D = require("utils.Vec2D")
local u = require("utils.utils")
local Queue = require("utils.Queue")
local FList = require("utils.FList")
local D = {}

local PIPES = {
  ["|"] = function(vec) return { vec:invert_up(), vec:invert_down() } end,
  ["-"] = function(vec) return { vec:left(), vec:right() } end,
  ["L"] = function(vec) return { vec:invert_up(), vec:right() } end,
  ["J"] = function(vec) return { vec:left(), vec:invert_up() } end,
  ["7"] = function(vec) return { vec:left(), vec:invert_down() } end,
  ["F"] = function(vec) return { vec:right(), vec:invert_down() } end,
  ["."] = function(vec) return {} end,
}


function D:part1(map)
  local start = D.find_start_point(map)
  local q = Queue()
  q:push(start)
  local loop = D.walk_loop(map, q)
  return u.size(loop) / 2
end

function D:part2(map)
  local start = D.find_start_point(map)
  local q = Queue()
  q:push(start)
  local loop = D.walk_loop(map, q)

  local verticals = {}
  for y = 1, #map, 1 do
    for x = 1, #map[1], 1 do
      if loop[x .. " " .. y] == true then
        local symbol = D.at(Vec2D(x, y), map)
        if symbol == "S" then symbol = D.get_start_pipe_symbol(Vec2D(x, y), map) end
        if symbol == "J" or symbol == "L" or symbol == "|" then
          verticals[x .. " " .. y] = "|"
        end
      end
    end
  end

  local result = 0
  for y = 1, #map, 1 do
    local inside = false
    for x = 1, #map[1], 1 do
      local coord = x .. " " .. y
      if verticals[coord] == "|" then inside = not inside end
      if loop[coord] == nil and inside then result = result + 1 end
    end
  end
  return result
end

function D.walk_loop(map, q, seen)
  seen = seen or {}

  if q:top() == nil then return seen end
  local vec = q:pop()
  seen[vec:to_string()] = true

  local symbol = D.at(vec, map)
  if symbol == "S" then symbol = D.get_start_pipe_symbol(vec, map) end
  local nexts = PIPES[symbol](vec)

  for _, value in ipairs(nexts) do
    if seen[value:to_string()] == nil then
      q:push(value)
    end
  end

  return D.walk_loop(map, q, seen)
end

function D.find_start_point(map)
  for y, value in ipairs(map) do
    for x = 1, #value, 1 do
      if D.at(Vec2D(x, y), map) == "S" then return Vec2D(x, y) end
    end
  end
end

function D.get_start_pipe_symbol(vec, map)
  local result = ""

  local north = D.at(vec:invert_up(), map)
  local south = D.at(vec:invert_down(), map)
  local east = D.at(vec:right(), map)
  local west = D.at(vec:left(), map)

  if north == "|" or north == "7" or north == "F" then result = result .. "NORTH_" end
  if south == "|" or south == "J" or south == "L" then result = result .. "SOUTH_" end
  if east == "-" or east == "J" or east == "7" then result = result .. "EAST_" end
  if west == "-" or west == "F" or west == "L" then result = result .. "WEST_" end

  if result == "NORTH_SOUTH_" then return "|" end
  if result == "NORTH_EAST_" then return "L" end
  if result == "NORTH_WEST_" then return "J" end
  if result == "SOUTH_EAST_" then return "F" end
  if result == "SOUTH_WEST_" then return "7" end
  if result == "EAST_WEST_" then return "-" end
end

function D.at(vec, map)
  if vec.x <= 0 or vec.y <= 0 then return nil end
  if vec.x > #map[1] or vec.y > #map then return nil end
  return map[vec.y]:sub(vec.x, vec.x)
end

return D
