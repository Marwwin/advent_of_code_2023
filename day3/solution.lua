local day = {}
local Vec2D = require("utils.Vec2D")
local FList = require("utils.FList")
local Set = require("utils.Set")

function day:part1(input_data)
  local result = 0
  local nums, symbols = day.parse_input(input_data)
  for _, n in pairs(nums) do
    if day.has_symbol_as_neighbour(n, symbols) then result = result + n.value end
  end
  return result
end

function day.has_symbol_as_neighbour(n, symbols)
  for y = n.pos.y - 1, n.pos.y + 1 do
    for x = n.pos.x - 1, n.pos.x + #n.value do
      if symbols[x .. " " .. y] ~= nil then return true end
    end
  end
  return false
end

function day:part2(input_data)
  local result = 0
  local nums, symbols, map = day.parse_input(input_data)
  for coord, symbol in pairs(symbols) do
    local parts = day.get_parts(symbol, coord, map)
    if parts ~= nil and parts:size() == 2 then
      local num_a_id = parts:pop()
      local num_b_id = parts:pop()
      result = result + nums[num_a_id].value * nums[num_b_id].value
    end
  end
  return result
end

function day.get_parts(symbol, coord, map)
  if symbol ~= '*' then return nil end

  local vec = Vec2D:from_string(coord)
  if vec == nil then return nil, "error creating Vec2D" end

  local parts = Set()
  for _, neighbour in ipairs(vec:neighbours({ diagonals = true })) do
    if map[neighbour:to_string()] ~= nil then
      parts:add(map[neighbour:to_string()])
    end
  end
  return parts
end

local SYMBOLS = FList({ '#', '%', '&', '*', '+', '-', '/', '=', '@', '$' })

function day.parse_input(input_data)
  local width, height = #input_data[1], #input_data
  local nums = FList({})
  local symbols = {}
  local map = {}
  local id = 1
  for y = 1, height do
    -- Populate nums and map tables
    local first, last = 0, 0
    while true do
      first, last = input_data[y]:find("(%d+)", last + 1)
      if first == nil then break end

      local n = input_data[y]:sub(first, last)
      nums:add({ value = n, pos = Vec2D(first, y) })
      for i = first, last, 1 do map[i .. " " .. y] = id end
      id = id + 1
    end

    -- Populate symbols table
    for x = 1, width do
      local symbol = input_data[y]:sub(x, x)
      if SYMBOLS:has(symbol) then symbols[x .. " " .. y] = symbol end
    end
  end
  return nums, symbols, map
end

return day
