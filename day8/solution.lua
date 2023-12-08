local AOC = require("AOC")
local Node = require("utils.Node")
local u = require("utils.utils")
local d = {}

function d:part1(input_data)
  local instructions, nodes = d.parse_input(input_data)
  local current = nodes.AAA
  local condition = function(c) return c:get_value() ~= "ZZZ" end
  return d.traverse(current, instructions, nodes, condition)
end

function d:part2(input_data)
  local instructions, nodes = d.parse_input(input_data)
  local starting_points = {}
  for _, node in pairs(nodes) do
    if node:get_value():sub(3, 3) == "A" then
      table.insert(starting_points, node)
    end
  end

  local condition = function(c) return c:get_value():sub(3, 3) ~= "Z" end
  local routes = {}
  for _, current in ipairs(starting_points) do
    local i = d.traverse(current, instructions, nodes, condition)
    table.insert(routes, i)
  end
  return math.floor(u.lcm_of_list(routes))
end

function d.traverse(current, instructions, nodes, condition)
  local i = 0
  while condition(current) do
    local mod_i = (i % #instructions) + 1
    local instruction = instructions:sub(mod_i, mod_i)
    if instruction == "R" then
      current = nodes[current:get_right()]
    elseif instruction == "L" then
      current = nodes[current:get_left()]
    end
    i = i + 1
  end
  return i
end

function d.parse_input(input_data)
  local instructions = input_data[1]
  local nodes = {}
  for index, value in ipairs(input_data) do
    local n, l, r = value:match("([%a%d]+) = %(([%a%d]+), ([%a%d]+)%)")
    if n ~= nil then
      local node = Node(n)
      node:set_left(l)
      node:set_right(r)
      nodes[n] = node
    end
  end
  return instructions, nodes
end

return d
