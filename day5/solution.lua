local AOC = require("AOC")
local d = {}
local u = require("utils.utils")

function d:part1(input_data)
  local ranges, seeds, maps = d.parse_input(input_data)
  return d.find_closest_seed(ranges, seeds, maps)
end

function d.find_closest_seed(ranges, seeds, maps)
  local result = 0x7FFFFFFFFFFFFFFF
  local fns = {}
  for _, map in ipairs(maps) do
    for _, range in ipairs(ranges[map]) do
      if fns[map] == nil then fns[map] = {} end
      table.insert(fns[map], d.do_range(range.destination, range.source, range.range))
    end
  end
  for _, seed in ipairs(seeds) do
    for _, map in ipairs(maps) do
      for _, fn in ipairs(fns[map]) do
        local v = fn(seed)
        if v ~= seed then
          seed = v
          break
        end
      end
    end
    if seed < result then result = seed end
  end
  return result
end

function d:part2(input_data)
  local ranges, seeds, maps = d.parse_input(input_data)
  return d.find_closest_seed2(ranges, seeds, maps)
end


function d.find_closest_seed2(ranges, seeds, maps)
  local result = 0x7FFFFFFFFFFFFFFF
  local fns = {}
  for _, map in ipairs(maps) do
    for _, range in ipairs(ranges[map]) do
      if fns[map] == nil then fns[map] = {} end
      table.insert(fns[map], d.do_range(range.destination, range.source, range.range))
    end
  end
  for i = 1, #seeds, 2 do
    for seed = seeds[i], seeds[i] + seeds[i + 1] - 1, 1 do
      for _, map in ipairs(maps) do
        for _, fn in ipairs(fns[map]) do
          local v = fn(seed)
          if v ~= seed then
            seed = v
            break
          end
        end
      end
      if seed < result then result = seed end
    end
  end
  return result
end

function d.do_range(dest, source, range)
  local offset = dest - source
  return function(value)
    if value >= source and value <= source + range then return value + offset end
    return value
  end
end

function d.parse_input(input_data)
  local seeds = {}
  local range = {}
  local current_map
  local maps = {}
  for index, str in ipairs(input_data) do
    local ss = str:match("seeds: ([%d%s]+)")
    if ss then
      seeds = u.split(ss):map(tonumber)
    else
      local from, _, dest = str:match("(%a+)-(%a+)-(%a+) map:")
      if from and dest then
        current_map = from .. "_" .. dest
        range[current_map] = {}
        table.insert(maps, current_map)
      end
      local destination, source, rar = str:match("(%d+) (%d+) (%d+)")
      if rar then
        table.insert(range[current_map],
          { source = tonumber(source), range = tonumber(rar), destination = tonumber(destination) })
      end
    end
  end
  return range, seeds, maps
end

return d
