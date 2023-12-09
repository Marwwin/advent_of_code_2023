local AOC = require("AOC")
local u = require("utils.utils")
local day = {}

function day:part1(input_data)
  local result = {}
  for row_idx, row in ipairs(input_data) do
    local history = day.create_history(row)
    for i = #history, 1, -1 do
      if i == #history then
        table.insert(history[i], 0)
      else
        local last_in_current_sequence = history[i][#history[i]]
        local last_in_next_sequence = history[i + 1][#history[i + 1]]
        local n = last_in_current_sequence + last_in_next_sequence
        table.insert(history[i], n)
      end
    end
    result[row_idx] = history[1][#history[1]]
  end
  return u.sum(result)
end

function day:part2(input_data)
  local result = {}
  for index, row in ipairs(input_data) do
    local history = day.create_history(row)
    for i = #history, 1, -1 do
      if i == #history then
        table.insert(history[i], 1, 0)
      else
        local first_in_current_sequence = history[i][1]
        local first_in_next_sequence = history[i + 1][1]
        local n = first_in_current_sequence - first_in_next_sequence
        table.insert(history[i], 1, n)
      end
    end
    result[index] = history[1][1]
  end
  return u.sum(result)
end

function day.create_history(row)
  local nums = u.split(row):map(tonumber)
  local history = {}
  table.insert(history, nums)
  local row_idx = 1
  while true do
    local new_row = {}
    local zeroes = true
    for i = 1, #history[row_idx] - 1 do
      local n = history[row_idx][i + 1] - history[row_idx][i]
      if n ~= 0 then zeroes = false end
      table.insert(new_row, n)
    end
    row_idx = row_idx + 1
    history[row_idx] = new_row
    if zeroes then break end
  end
  return history
end

return day
