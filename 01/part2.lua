local input_file = require 'input_file'

local s = input_file.read_file("input.txt")
local total = 0
local frequencies = {}

while true do
    for n in s:gmatch("[+-]%d+") do
        total = total + tonumber(n)

        if frequencies[total] then
            print(total)
            return
        end

        frequencies[total] = 1
    end
end

