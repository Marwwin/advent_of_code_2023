local AOC = require("AOC")
local u = require("utils.utils")
local Counter = require("utils.Counter")
local d = {}

local TYPE = {
  FIVE_OF_A_KIND = 7,
  FOUR_OF_A_KIND = 6,
  FULL_HOUSE = 5,
  THREE_OF_A_KIND = 4,
  TWO_PAIR = 3,
  ONE_PAIR = 2,
  HIGH_CARD = 1
}
function d:part1(input_data)
  local cc = d.parse_input(input_data)
  table.sort(cc, function(a, b) return d.play(a.hand, b.hand) or false end)
  local result = 0
  for index, hand in ipairs(cc) do
    result = result + hand.bid * index
  end
  return result
end

function d:part2(input_data)
  local cc = d.parse_input(input_data)
  table.sort(cc, function(a, b) return d.play(a.hand, b.hand, { joker = true }) or false end)
  local result = 0
  for index, value in ipairs(cc) do
    result = result + value.bid * index
  end
  return result
end

function d.play(a, b, t)
  t = t or {}
  local a_type = d.get_type(a)
  local b_type = d.get_type(b)
  if t.joker then
    a_type = d.add_jokers(a, a_type)
    b_type = d.add_jokers(b, b_type)
  end
  if a_type == b_type then return d.get_higher_value_hand(a, b, t) end
  return a_type < b_type
end

function d.get_type(hand)
  local c = Counter(hand)
  local mc = c:most_common(2)
  if mc[1].amount == 5 then return TYPE.FIVE_OF_A_KIND end
  if mc[1].amount == 4 then return TYPE.FOUR_OF_A_KIND end
  if mc[1].amount == 3 and mc[2].amount == 2 then return TYPE.FULL_HOUSE end
  if mc[1].amount == 3 then return TYPE.THREE_OF_A_KIND end
  if mc[1].amount == 2 and mc[2].amount == 2 then return TYPE.TWO_PAIR end
  if mc[1].amount == 2 then return TYPE.ONE_PAIR end
  return TYPE.HIGH_CARD
end

function d.add_jokers(hand, type)
  local jokers = Counter.count_char("J", hand)
  if jokers > 0 then return d.raise_type(type, jokers) end
  return type
end

function d.raise_type(type, jokers)
  if type == TYPE.HIGH_CARD then return TYPE.ONE_PAIR end
  if type == TYPE.ONE_PAIR then return TYPE.THREE_OF_A_KIND end
  if type == TYPE.TWO_PAIR then
    if jokers == 1 then return TYPE.FULL_HOUSE end
    if jokers == 2 then return TYPE.FOUR_OF_A_KIND end
  end
  if type == TYPE.THREE_OF_A_KIND then
    if jokers == 1 then return TYPE.FOUR_OF_A_KIND end
    if jokers == 3 then return TYPE.FOUR_OF_A_KIND end
  end
  if type == TYPE.FULL_HOUSE then return TYPE.FIVE_OF_A_KIND end
  if type == TYPE.FOUR_OF_A_KIND then return TYPE.FIVE_OF_A_KIND end
  if type == TYPE.FIVE_OF_A_KIND then return TYPE.FIVE_OF_A_KIND end
end

function d.get_higher_value_hand(a, b, t)
  for i = 1, #a, 1 do
    local la = a:sub(i, i)
    local lb = b:sub(i, i)
    if to_label(la, t) < to_label(lb, t) then return true end
    if to_label(la, t) > to_label(lb, t) then return false end
  end
  return nil, "error same hand"
end

local function to_label(str, t)
  if str == "T" then return 10 end
  if str == "J" then
    if t.joker then return 1 else return 11 end
  end
  if str == "Q" then return 12 end
  if str == "K" then return 13 end
  if str == "A" then return 14 end
  return tonumber(str)
end


function d.parse_input(input_data)
  local result = {}
  for _, value in ipairs(input_data) do
    local hand, bid = value:match("([%d%a]+) (%d+)")
    table.insert(result, { hand = hand, bid = bid })
  end
  return result
end

return d
