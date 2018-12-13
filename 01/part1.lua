local input_file = require 'input_file'

local s = input_file.read_file("input.txt")

local total = 0

for n in s:gmatch("[+-]%d+") do
    total = total + tonumber(n)
end

print(total)

