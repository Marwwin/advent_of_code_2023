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

describe("utils.print_t", function()
  it("test print_t", function()
    local t = { f2 = "42", te = { t = "test",  w = "width", t = { id = 42, t = {f = 42, test = "I am deep"} }},
      obj = { inner_table = "gong", deeper = { one = { two = 2 }, two = 2, three = 3, four = 4 } } }
    u.print_t(t)
  end)
end)
