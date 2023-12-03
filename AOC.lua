local AOC = {}

function AOC.get_input(fileName, use_test_data)
  local file
  if use_test_data then
    file = io.open(fileName .. "/test.data", "r")
  else
    file = io.open(fileName .. "/input.data", "r")
  end

  if not file then
    print("File Open error")
  else
    local input = {}
    local index = 1
    for line in file:lines() do
      input[index] = line
      index = index + 1
    end
    file:close()
    return input
  end
end

function AOC.print_input(input, config)
  for _, v in pairs(input) do
    io.write(v, " ")
    if config then
      if config.newLines then io.write("\n") end
    end
  end
  io.write("\n")
end

-- CLI Commands

local args = { ... }

function AOC.parse_arg()
  local config = AOC.parse_config()

  for i, arg in ipairs(args) do
--     print(arg)
    if arg == "run" then AOC.run_day(args[i + 1], config) end
    if arg == "test" then AOC.run_test(args[i + 1], config) end
    if arg == "create" then AOC.create(args[i + 1], config) end
  end
end

function AOC.parse_config()
  local config = {}
  for _, arg in ipairs(args) do
    if arg == "--input" or arg == "-i" then config["show_input_data"] = true end
    if arg == "--test" or arg == "-t" then config["test_data"] = true end
    if arg == "--benchmark" or arg == "-b" then config["benchmark"] = true end
  end
  return config
end

function AOC.create(day_number, config)
  os.execute("mkdir " .. day_number)
  os.execute("touch " .. day_number .. "/input.data")
  os.execute("touch " .. day_number .. "/test.data")
  os.execute("cat .config/test.lua >> " .. day_number .. "/test.lua")
  os.execute("cat .config/init_day.lua >> " .. day_number .. "/solution.lua")
end

function AOC.run_day(day_number, config)
  print(day_number)
  local data = AOC.get_input(day_number, config.test_data)
  if config.show_input_data then
    AOC.print_input(data)
  end

  local day = require(day_number .. "/solution")
  local times = 1
  if config.benchmark then times = 1000 end
  local part1_result, part1_avg = AOC.perf(day.part1, day, data,times)
  print("part1:", part1_result, "time:", part1_avg .. "ms")

  local part2_result, part2_avg = AOC.perf(day.part2, day, data,times)
  print("part2: ", part2_result, "time:", part2_avg .. "ms")
end

function AOC.perf(fn, day, data, times)
  times = times or 1000
  local result = 0
  local output
  for _ = 1, times, 1 do
    local start = os.clock()
    output = fn(day, data)
    result = result + (os.clock() - start)
  end
  return output, (result / times) * 1000
end

function AOC.run_test(day_number)
  os.execute("busted " .. day_number .. "/test.lua")
end

AOC.parse_arg()

return AOC
