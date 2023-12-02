local AOC = require("AOC")
local utils = require("utils.utils")
local day = {}


function day:part1(input_data)
  local MAX_CUBES = { red = 12, green = 13, blue = 14 }
  local result = 0
  for _, str in ipairs(input_data) do
    local game = day.parse_game(str)
    local went_over = false
    for _, subset in ipairs(game.games) do
      if (subset.red or 0) > MAX_CUBES.red or
          (subset.green or 0) > MAX_CUBES.green or
          (subset.blue or 0) > MAX_CUBES.blue then
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
    for _, subset in ipairs(game.games) do
      local red = subset.red or 0
      local green = subset.green or 0
      local blue = subset.blue or 0
      if red > game_result.red then game_result.red = red end
      if green > game_result.green then game_result.green = green end
      if blue > game_result.blue then game_result.blue = blue end
    end
    result = result + (game_result.red * game_result.green * game_result.blue)
  end
  return result
end

function day.parse_game(str)
  local result = {}
  local first_split = utils.split(str, ":")
  local game_id = utils.split(first_split[1])
  result.id = tonumber(game_id[2])
  result.games = {}

  for _, game in ipairs(utils.split(first_split[2], ";")) do
    local current_game = {}
    for _, cube in ipairs(utils.split(game, ",")) do
      local n, color = cube:match("(%d+) (%a+)")
      current_game[color] = tonumber(n)
    end
    table.insert(result.games, current_game)
  end
  return result
end

return day
