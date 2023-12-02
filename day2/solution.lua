local utils = require("utils.utils")
local day = {}

function day:part1(input_data)
  local MAX_CUBES = { red = 12, green = 13, blue = 14 }
  local result = 0
  for _, str in ipairs(input_data) do
    local game = day.parse_game(str)
    local went_over = false
    for _, subset in ipairs(game.subsets) do
      if subset.red > MAX_CUBES.red or
          subset.green > MAX_CUBES.green or
          subset.blue > MAX_CUBES.blue then
        went_over = true
      end
    end
    if went_over == false then result = result + game.id end
  end
  return result
end

function day:part2(input_data)
  local result = 0
  for _, str in ipairs(input_data) do
    local game_result = { red = 0, blue = 0, green = 0 }
    local game = day.parse_game(str)
    for _, subset in ipairs(game.subsets) do
      if subset.red > game_result.red then game_result.red = subset.red end
      if subset.green > game_result.green then game_result.green = subset.green end
      if subset.blue > game_result.blue then game_result.blue = subset.blue end
    end
    result = result + (game_result.red * game_result.green * game_result.blue)
  end
  return result
end

function day.parse_game(str)
  local result = {}
  local id, subsets = str:match("Game (%d+): (.+)")
  result.id = tonumber(id)
  result.subsets = {}

  for _, game in ipairs(utils.split(subsets, ";")) do
    local subset = { red = 0, green = 0, blue = 0 }
    for _, cubes in ipairs(utils.split(game, ",")) do
      local n, color = cubes:match("(%d+) (%a+)")
      subset[color] = tonumber(n)
    end
    table.insert(result.subsets, subset)
  end
  return result
end

return day
