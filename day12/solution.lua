local u = require("utils.utils")
local day = {}

function day:part1(input_data)
  local result = 0
  for index, value in ipairs(input_data) do
    local ss = u.split(value)
    local springs = ss[1]
    local num_springs = u.split(ss[2], ",")
    --     print(springs)
    --     print(springs:match("[#%?]+"))
    --     for c in springs:gmatch("[(#%?%.)]+") do
    --       print("f",c)
    --     end
    local ways = day.count(springs, num_springs)
    --     result = result + ways
  end
end

function day:part2(input_data)
end

function day.count(springs, num_springs)
  print("p", springs)
  if #num_springs == 0 then print("end") end

  if springs == nil or #springs == 0 then return 0 end
  local pattern = "[#%?]+"

  local spring = springs:match(pattern)

  if spring == nil then return day.count(springs:sub(2, #springs), num_springs) end

  print("spring",spring)
  local n = num_springs[1]

  local replaced = spring:gsub("(%?)", "%%?")
  local start = springs:find(replaced)

  day.count(springs:sub(start + #spring, #springs), num_springs)
end

return day
