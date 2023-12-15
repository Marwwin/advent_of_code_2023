local u = require("utils.utils")
local day = {}


function day:part1(input_data)
  local matrix = {}
  local matrixes = {}
  for index, row in ipairs(input_data) do
    if row == "" then
      table.insert(matrixes, matrix)
      matrix = {}
    else
      table.insert(matrix, u.chars(row))
    end
  end
  table.insert(matrixes, matrix)

  local result = 0
  for index, m in ipairs(matrixes) do
    local hor = day.find_middle_hor(m)
    local ver = day.find_middle_ver(m)
    result = result + hor + (100 * ver)
  end
  return result
end

function day:part2(input_data)
  local matrix = {}
  local matrixes = {}
  for index, row in ipairs(input_data) do
    if row == "" then
      table.insert(matrixes, matrix)
      matrix = {}
    else
      table.insert(matrix, u.chars(row))
    end
  end
  table.insert(matrixes, matrix)

  local result = 0
  for index, m in ipairs(matrixes) do
--     u.print_t(m)
    local h = day.find_middle_hor(m, 1)
    local v = day.find_middle_ver(m,1)
    print(h,v)
  end
  --   result = result + hor + (100 * ver)
  return result
end

function day.get_col(matrix, col)
  local result = ""
  for i = 1, #matrix, 1 do
    result = result .. matrix[i][col]
  end
  return result
end

function day.find_middle_hor(matrix, diff)
  local offset = 0
  local size = #matrix[2]
  for x = 1, size - 1, 1 do
    offset = 0
    local d = diff or 0
    repeat
      local low_index = x - offset
      local hi_index = x + 1 + offset
      if low_index == 0 then return offset end
      if hi_index > size then return size - offset end
      local low = day.get_col(matrix, low_index)
      local hi = day.get_col(matrix, hi_index)
      print(low, hi, day.find_diff(low,hi))

      d = d - day.find_diff(low, hi)
      offset = offset + 1
    until d < 0
  end
  return 0
end

function day.find_middle_ver(matrix, start)
  local offset = 0
  for y = 1, #matrix - 1, 1 do
    local diff = start or 0
    offset = 0
    repeat
      local low_index = y - offset
      local hi_index = y + 1 + offset
      if low_index == 0 then return offset end
      if y + 1 + offset > #matrix then return #matrix - offset end
      local low = table.concat(matrix[low_index])
      local hi = table.concat(matrix[hi_index])

      print(low, hi, day.find_diff(low,hi))

      offset = offset + 1
      local row_diff = day.find_diff(low, hi)
      diff = diff - row_diff
      if diff < 0 then return y end
    until diff < 0
  end
  return 0
end

function day.find_diff(low, hi)
  print(low, hi)
  local n_diff = 0
  for i = 1, #low, 1 do
    if low:sub(i, i) ~= hi:sub(i, i) then
      n_diff = n_diff + 1
    end
  end
  --   print(low, hi, n_diff)
  return n_diff
end

return day
