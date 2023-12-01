local Vec2D = require("utils.Vec2D")
local Stack = require("utils.Stack")
local Node = require("utils.Node")

local SYMBOL = {
  PATH = "path",
  WALL = "wall"
}

local ASCII_COLORS = {
  reset = "\27[0m",
  red = "\27[31m",
  green = "\27[32m",
  white = "\27[37m",
  yellow = "\27[33m",
  blue = "\27[34m",
  magenta = "\27[35m",
}

local DFS = {}

DFS.find = function(start, goal, is_walkable, map, size)
  local q = Stack()
  local seen = {}
  local visited = {}
  local start_node = Node(start)

  local current

  seen[start_node.node:to_string()] = start_node
  q:push(start_node)

  while (not q:empty()) do
    current = q:pop()
    visited[current.node:to_string()] = current
    if current.node:equals(goal) then break end

    for _, neighbour in ipairs(current.node:neighbours()) do
      if DFS.not_seen(neighbour, seen) and is_walkable(neighbour, map) and DFS.is_inside(neighbour, size) then
        seen[neighbour:to_string()] = neighbour
        q:push(Node(neighbour, current))
      end
    end

    DFS.print_map(map, visited, goal, size)
  end

  local result = DFS.backtrack(current, start)
  for _, path in ipairs(result) do
    map[path:to_string()] = SYMBOL.PATH
    DFS.print_map(map, seen, goal, size)
  end
end

DFS.is_inside = function(node, size) return node.x >= 0 and node.x <= size and node.y >= 0 and node.y <= size end

DFS.not_seen = function(node, visited) return visited[node:to_string()] == nil end

DFS.backtrack = function(current, result)
  if current == nil then
    return result
  end
  table.insert(result, current.node)
  return DFS.backtrack(current.parent, result)
end


DFS.print_map = function(map, visited, goal, size)
  os.execute("sleep 0.04")
  os.execute("clear")
  for y = 0, size, 1 do
    for x = 0, size, 1 do
      local v = x .. " " .. y
      if x == goal.x and y == goal.y then
        io.write(ASCII_COLORS.yellow)
        io.write(" G ")
        io.write(ASCII_COLORS.reset)
      elseif map[v] == SYMBOL.WALL then
        io.write(" # ")
      elseif map[v] == SYMBOL.PATH then
        io.write(ASCII_COLORS.blue)
        io.write(" @ ")
        io.write(ASCII_COLORS.reset)
      elseif visited[v] then
        io.write(ASCII_COLORS.red)
        io.write(" * ")
        io.write(ASCII_COLORS.reset)
      else
        io.write(" . ")
      end
    end
    io.write("\n")
  end
end


--
--TEST DATA
--

local function walkable(vec, map)
  if map[vec:to_string()] == SYMBOL.WALL then
    return false
  end
  return true
end

function generateRandomMaze(rows, cols)
  local maze = {}

  -- Add random walls to the maze
  for i = 1, rows do
    for j = 1, cols do
      local key = string.format("%d %d", i, j)
      maze[key] = math.random() < 0.2 -- Adjust the probability to control the density of walls
    end
  end

  return maze
end

local map = {}

map["8 0"] = SYMBOL.WALL
map["8 1"] = SYMBOL.WALL
map["8 2"] = SYMBOL.WALL
map["8 3"] = SYMBOL.WALL
map["8 4"] = SYMBOL.WALL
map["8 5"] = SYMBOL.WALL
map["8 6"] = SYMBOL.WALL
map["8 7"] = SYMBOL.WALL
map["8 8"] = SYMBOL.WALL
map["7 8"] = SYMBOL.WALL
map["6 7"] = SYMBOL.WALL
map["3 10"] = SYMBOL.WALL
map["4 10"] = SYMBOL.WALL
map["5 10"] = SYMBOL.WALL
map["6 10"] = SYMBOL.WALL
map["7 10"] = SYMBOL.WALL
map["8 10"] = SYMBOL.WALL
map["9 10"] = SYMBOL.WALL
map["10 7"] = SYMBOL.WALL
map["10 8"] = SYMBOL.WALL
map["10 9"] = SYMBOL.WALL
map["10 10"] = SYMBOL.WALL
map["10 11"] = SYMBOL.WALL
map["10 12"] = SYMBOL.WALL
map["11 11"] = SYMBOL.WALL
map["12 11"] = SYMBOL.WALL
map["13 11"] = SYMBOL.WALL
map["16 7"] = SYMBOL.WALL
map["16 8"] = SYMBOL.WALL
map["16 9"] = SYMBOL.WALL
map["16 10"] = SYMBOL.WALL
map["16 11"] = SYMBOL.WALL
map["16 12"] = SYMBOL.WALL
map["16 13"] = SYMBOL.WALL
map["14 13"] = SYMBOL.WALL
map["14 12"] = SYMBOL.WALL
map["14 11"] = SYMBOL.WALL
map["14 10"] = SYMBOL.WALL
map["14 9"] = SYMBOL.WALL
map["14 8"] = SYMBOL.WALL
map["16 8"] = SYMBOL.WALL
map["17 8"] = SYMBOL.WALL
map["18 8"] = SYMBOL.WALL
map["12 8"] = SYMBOL.WALL
map["11 8"] = SYMBOL.WALL
map["10 8"] = SYMBOL.WALL
map["19 11"] = SYMBOL.WALL
map["8 15"] = SYMBOL.WALL
map["9 15"] = SYMBOL.WALL
map["10 15"] = SYMBOL.WALL
map["11 15"] = SYMBOL.WALL
map["12 15"] = SYMBOL.WALL
map["13 15"] = SYMBOL.WALL
map["14 15"] = SYMBOL.WALL
map["15 15"] = SYMBOL.WALL
map["14 17"] = SYMBOL.WALL
map["15 17"] = SYMBOL.WALL
map["16 17"] = SYMBOL.WALL
map["17 17"] = SYMBOL.WALL
map["18 17"] = SYMBOL.WALL
map["18 16"] = SYMBOL.WALL
map["18 15"] = SYMBOL.WALL
map["18 14"] = SYMBOL.WALL
map["18 13"] = SYMBOL.WALL
map["18 12"] = SYMBOL.WALL
map["18 11"] = SYMBOL.WALL
map["14 18"] = SYMBOL.WALL
map["14 19"] = SYMBOL.WALL
map["13 19"] = SYMBOL.WALL
map["12 19"] = SYMBOL.WALL
map["11 19"] = SYMBOL.WALL
map["10 19"] = SYMBOL.WALL
map["10 18"] = SYMBOL.WALL
DFS.find(Vec2D(3, 3), Vec2D(11, 10), walkable, map, 20)
-- M.DFS(Vec2D(3, 3), Vec2D(12, 10), walkable, map)
-- M.AStar(Vec2D(3, 3), Vec2D(17, 18), walkable, map)



return DFS
