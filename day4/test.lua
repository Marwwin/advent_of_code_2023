local AOC = require('AOC')
local day = require("day4.solution")

describe("",function ()
  it("parse one scratch card",function()
    local card = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53"
    assert.are.same({id = 1, winning = {41,48,83,86,17}, numbers = {83,86,6,31,17,9,48,53}}, day.parse_card(card))
    
  end)
end)
