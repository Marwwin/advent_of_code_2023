local AOC = require('AOC')
local day = require("day2.solution")

describe("Day2", function()
  it("parse one game", function()
    local result = day.parse_game("Game 1: 2 red, 2 green; 1 red, 1 green, 2 blue")
    assert.are.same({ id = 1, games = { { red = 2, green = 2 }, { red = 1, green = 1, blue = 2 } } }, result)
  end)
end)
