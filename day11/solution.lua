local AOC = require("AOC")
local u = require("utils.utils")
local Vec2D = require("utils.Vec2D")
local Queue = require("utils.Queue")
local Node = require("utils.Node")
local day = {}

function day.solve(matrix)
  local galaxies = {}
  local empty_rows = u.range(#matrix)
  local empty_cols = u.range(#matrix[1])

  -- find all galaxies and empty rows/columns
  for y = 1, #matrix, 1 do
    for x = 1, #matrix[1], 1 do
      if matrix[y]:sub(x, x) == "#" then
        empty_rows[x] = nil
        empty_cols[y] = nil
        table.insert(galaxies, Vec2D(x, y))
      end
    end
  end

  local expansion_rate = 1000000

  local part1 = 0
  local part2 = 0
  for i = 1, #galaxies, 1 do
    local current = galaxies[i]
    for j = i + 1, #galaxies, 1 do
      -- Distance without added empty spaces
      local galaxy = galaxies[j]
      local dist = current:manhattan(galaxy)
      local p1 = dist
      local p2 = dist

      -- Count missing columns
      for y = math.min(current.y, galaxy.y), math.max(current.y, galaxy.y), 1 do
        if empty_cols[y] ~= nil then
          p1 = p1 + 1
          p2 = p2 + expansion_rate - 1
        end
      end

      -- Count missing rows
      for x = math.min(current.x, galaxy.x), math.max(current.x, galaxy.x), 1 do
        if empty_rows[x] ~= nil then
          p1 = p1 + 1
          p2 = p2 + expansion_rate - 1
        end
      end

      part1 = part1 + p1
      part2 = part2 + p2
    end
  end
  return part1, part2
end

function day:part1(input_data)
  local part1 = day.solve(input_data)
  return part1
end

function day:part2(input_data)
  local _, part2 = day.solve(input_data)
  return part2
end

return day
