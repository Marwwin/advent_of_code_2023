local u = require("utils.utils")
local FList = require("utils.FList")

describe("utils.split", function()
  it("should separate on whitespace", function()
    assert.are.same({ "the", "number", "42" }, u.split("the number 42"))
  end)

end)

describe("utils.chars", function()
  it("should split string into table of chars", function()
    assert.are.same({ "t", "e", "s", "t", " ", "4", "2" }, u.chars("test 42"))
  end)
end)
