local u = require("utils.utils")
local FList = require("utils.FList")
local day = {}

function day:part1(input_data)
  local s = u.split(input_data[1], ",")
  local result = 0
  for _, value in ipairs(s) do
    result = result + day.hash(value)
  end
  return result
end

function day:part2(input_data)
  local boxes = {}
  for i = 1, 256, 1 do
    boxes[i] = FList({})
  end
  local s = u.split(input_data[1], ",")
  for _, value in ipairs(s) do
    local label = value:match("(%a+)")
    local operation = value:match("(%p)")
    local lens = value:match("(%d+)")
    local box_id = day.hash(label) + 1
    local box = boxes[box_id]

    if operation == "=" then
      if box:has_fn(function(e) return e.label == label end) then
        boxes[box_id] = box:map(function(e)
          if e.label == label then e.lens = lens end
          return e
        end)
      else
        box:add(FList({ label = label, lens = lens }))
      end
    end
    if operation == "-" then
      boxes[box_id] = box:filter(function(e)
        if e.label ~= label then return e end
      end)
    end
  end

  local result = 0
  for i = 1, 256, 1 do
    for slot, box in ipairs(boxes[i]) do
      local power = i * slot * box.lens
      result = result + power
    end
  end
  return result
end

function day.hash(str)
  local result = 0
  for i = 1, #str, 1 do
    local ch = str:sub(i, i)
    result = result + ch:byte()
    result = result * 17
    result = result % 256
  end
  return result
end

return day
