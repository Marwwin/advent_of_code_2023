local AOC = require("AOC")
local u = require("utils.utils")
local day = {}

function day:part1(input_data)
  local times = u.split(u.split(input_data[1], ":")[2]):map(tonumber)
  local records = u.split(u.split(input_data[2], ":")[2]):map(tonumber)
  local result = 1
  for i, record in ipairs(records) do
    local amount_of_records_beat = 0
    for time_held = 1, times[i], 1 do
      local distance = time_held * (times[i] - time_held)
      -- This seems to work from test and real input. Not sure if I would trust it for other inputs
      if distance > record then amount_of_records_beat = (time_held * 2) - times[i] +1  end
    end
    result = result * amount_of_records_beat
  end
  return result
end

function day:part2(input_data)
  local times = tonumber(u.split(u.split(input_data[1], ":")[2]):reduce(function(acc, e) return acc .. e end, ""))
  local record = tonumber(u.split(u.split(input_data[2], ":")[2]):reduce(function(acc, e) return acc .. e end, ""))
  local result = 0
  for time_held = 0, times, 1 do
    local distance = time_held * (times - time_held)
    if distance > record then
      -- This is not that scientific, would not work for all inputs :D
      return times - (time_held * 2) + 1
    end
  end
  return result
end

return day
