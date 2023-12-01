local AOC = require("AOC")
local FList = require("utils/FList")
local nums = FList({ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten" })
local reversed_nums = FList({ "eno", "owt", "eerht", "ruof", "evif", "xis", "neves", "thgie", "enin", "net" })

local day = {}

function day:part1(input_data)
  local result = 0
  for _, str in ipairs(input_data) do
    result = result + tonumber(day.first_num(str) .. day.first_num(str:reverse()))
  end
  return result
end

function day:part2(input_data)
  local result = 0
  for _, str in ipairs(input_data) do
    local first_converted = day.convert_first_spelled_digit_to_int(str, nums)
    local last_converted = day.convert_first_spelled_digit_to_int(str:reverse(), reversed_nums)
    result = result + tonumber(day.first_num(first_converted) .. day.first_num(last_converted))
  end
  return result
end

function day.first_num(str)
  for i = 1, #str, 1 do
    local ch = str:sub(i, i)
    if tonumber(ch) then return ch end
  end
  return nil
end

function day.convert_first_spelled_digit_to_int(str, list)
  local pos, value
  for _, n in ipairs(list) do
    local startPos, endPos = str:find(n)
    if startPos then
      if not pos or startPos < pos then
        pos = startPos
        value = str:sub(startPos, endPos)
      end
    end
  end
  if value then return str:gsub(value, list:index(value), 1) end
  return str
end

return day
