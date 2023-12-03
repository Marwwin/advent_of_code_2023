local AOC = require('AOC')
local day = require("day3.solution")

describe("Day3",function ()
  it("Should parse numbers",function()
    local input = {"....",".3..","1..4",".42."}
    local result = day.parse_input(input)
    assert.are.same("3",result[1].value)
    assert.are.same("2 2",result[1].start:to_string())
    assert.are.same(1,result[1].width)

    assert.are.same("1",result[2].value)
    assert.are.same("4",result[3].value)
    assert.are.same("42",result[4].value)
    assert.are.same("2 4",result[4].start:to_string())
    assert.are.same(2,result[4].width)
  end)
  it("should parse symbols", function ()
    local input = {"..3.", "..*.", "@..$"}
    local result, symbols = day.parse_input(input)
    assert.are.same("@", symbols["1 3"])
  end)
  it("should handel duplicate nums",function ()
    local input = {"...800*......*..183..117..375......375..............807.691........981................890.......622...97.....$.515................@........."}
    local result = day.parse_input(input)
    assert.are.same(12,#result)
  end)
end)
