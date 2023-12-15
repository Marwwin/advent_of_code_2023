local Matrix = require "utils.Matrix"

describe("Matrix",function ()
  it("should move",function ()
    local m = Matrix(10)
    m:insert("0", 2,2)
    m:print()
    m:up(2,2)
    m:print()
  end)
end)
