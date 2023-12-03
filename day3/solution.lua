local AOC = require("AOC")
local day = {}
local Vec2D = require("utils.Vec2D")
local FList = require("utils.FList")
local Set = require("utils.Set")

function day:part1(input_data)
  local result = 0
  local nums, symbols = day.parse_input(input_data)
  for _, num in pairs(nums) do
    local has_symbol_neighbour = false
    for y = num.start.y - 1, num.start.y + 1 do
      for x = num.start.x - 1, num.start.x + num.width do
        local s = symbols[x .. " " .. y]
        if s ~= nil then has_symbol_neighbour = true end
      end
    end
    if has_symbol_neighbour then
      result = result + num.value
    end
  end
  return result
end

function day:part2(input_data)
  local result = 0
  local res, symbols, map = day.parse_input(input_data)
  for coord, symbol in pairs(symbols) do
    if symbol == '*' then
      local v = Vec2D:from_string(coord)
      local neighbours = v:neighbours(true)
      local parts = Set()
      for index, neighbour in ipairs(neighbours) do
        if map[neighbour:to_string()] ~= nil then
          parts:add(map[neighbour:to_string()])
        end
      end
      if parts:size() == 2 then
        local a = parts:pop()
        local b = parts:pop()
        result = result + res[a].value * res[b].value
      end
    end
  end
  return result
end

local SYMBOLS = FList { '#', '%', '&', '*', '+', '-', '/', '=', '@', '$' }

function day.parse_input(input_data)
  local width, height = #input_data[1], #input_data
  local result = {}
  local symbols = {}
  local map = {}
  local id = 1
  for y = 1, height do
    local first, last = 0, 0
    while true do
      first, last = input_data[y]:find("(%d+)", last + 1)
      if first == nil then break end

      local v = input_data[y]:sub(first, last)
      table.insert(result, {
        value = v,
        start = Vec2D(first, y),
        width = last - first + 1,
      })
      for i = first, last, 1 do
        map[i .. " " .. y] = id
      end
      id = id + 1
    end
    for x = 1, width do
      local s = input_data[y]:sub(x, x)
      if SYMBOLS:has(s) then symbols[x .. " " .. y] = s end
    end
  end
  return result, symbols, map
end

return day
