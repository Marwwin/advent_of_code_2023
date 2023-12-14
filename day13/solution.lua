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
    --     local hor = day.find_middle_hor(m, 1)
    --     local ver = day.find_middle_ver(m, 1)
    --
    --     print("i", index, ver, hor)
    --     result = result + hor + (100 * ver)
    for y, row in ipairs(m) do
      print(index)
      print(day.find_diff())
      for x, value in ipairs(row) do
        print(m[y][x])
      end
    end
  end
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
      if x - offset == 0 then return offset end
      if x + 1 + offset > size then return size - offset end
      local low = day.get_col(matrix, x - offset)
      local hi = day.get_col(matrix, x + 1 + offset)
      d = d - day.find_diff(low, hi)
      offset = offset + 1
    until d < 0
  end
  return 0
end

function day.find_middle_ver(matrix, diff)
  local offset = 0
  for y = 1, #matrix - 1, 1 do
    local d = diff or 0
    offset = 0
    repeat
      if y - offset == 0 then
        return offset
      end
      if y + 1 + offset > #matrix then
        return #matrix - offset
      end
      local low = table.concat(matrix[y - offset])
      local hi = table.concat(matrix[y + 1 + offset])

      offset = offset + 1
      local dd = day.find_diff(low, hi)
      d = d - dd
      if dd == diff then return y end
    until d < 0
  end
  return 0
end

function day.find_diff(low, hi)
  local n_diff = 0
  for i = 1, #low, 1 do
    local l = low:sub(i, i)
    local h = hi:sub(i, i)

    if l ~= h then
      n_diff = n_diff + 1
    end
  end
  --   print(low, hi, n_diff)
  return n_diff
end

return day
