local u = require("utils.utils")
local FList = require("utils.FList")

describe("utils",function ()
  it("should separate on whitespace", function ()
    assert.same({"the","number","42"}, u.split("the number 42"))
  end)
end)
