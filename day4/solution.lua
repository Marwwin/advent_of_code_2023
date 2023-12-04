local AOC = require("AOC")
local u = require("utils.utils")
local FList = require("utils.FList")
local Stack = require("utils.Stack")
local day = {}

function day:part1(input_data)
  local cards = FList(input_data):map(day.parse_card)
  local result = 0
  for _, card in ipairs(cards) do
    local score = day.get_amount_of_winning_numbers(card)
    if score > 0 then
      result = result + (2 ^ (score - 1))
    end
  end
  return result
end

function day:part2(input_data)
  local cards = FList(input_data):map(day.parse_card)
  local result = 0
  local memo = {}
  for i = 1, #cards, 1 do
    local current = cards[i]
    result = result + day.count_copies(current, cards, memo)
  end
  return result
end

function day.get_amount_of_winning_numbers(card)
  local winning_nums = 0
  for _, number in ipairs(card.numbers) do
    if card.winning:has(number) then winning_nums = winning_nums + 1 end
  end
  return winning_nums
end

function day.count_copies(current, cards, memo)
  local result = 1
  local score = day.get_amount_of_winning_numbers(current)
  for i = current.id + 1, current.id + score, 1 do
    if memo[i] then
      result = result + memo[i]
    else
      memo[i] = day.count_copies(cards[i], cards, memo)
      result = result + memo[i]
    end
  end
  return result
end

function day.parse_card(card)
  local id, winning, numbers = card:match("Card %s*(%d+):([%d%s]+) | ([%d%s]+)")
  return {
    id = tonumber(id),
    winning = u.split(winning):map(tonumber),
    numbers = u.split(numbers):map(tonumber)
  }
end

return day
