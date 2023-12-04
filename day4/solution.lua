local u = require("utils.utils")
local FList = require("utils.FList")
local d = {}

function d:part1(input_data)
  local cards = FList(input_data):map(d.parse_card)
  local result = 0
  for _, card in ipairs(cards) do
    local score = d.get_score(card)
    if score > 0 then result = result + (2 ^ (score - 1)) end
  end
  return result
end

function d:part2(input_data)
  local cards = FList(input_data):map(d.parse_card)
  local result = 0
  for id = 1, #cards, 1 do
    result = result + d.count_copies(id, cards)
  end
  return result
end

function d.get_score(card)
  local score = 0
  for _, number in ipairs(card.numbers) do
    if card.winning:has(number) then score = score + 1 end
  end
  return score
end

function d.count_copies(id, cards, memo)
  memo = memo or {}
  local result = 1
  for i = id + 1, id + d.get_score(cards[id]), 1 do
    if memo[i] then
      result = result + memo[i]
    else
      memo[i] = d.count_copies(i, cards, memo)
      result = result + memo[i]
    end
  end
  return result
end

function d.parse_card(card)
  local id, winning, numbers = card:match("Card %s*(%d+):([%d%s]+) | ([%d%s]+)")
  return {
    id = tonumber(id),
    winning = u.split(winning):map(tonumber),
    numbers = u.split(numbers):map(tonumber)
  }
end

return d
