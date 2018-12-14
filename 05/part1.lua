local input_file = require 'input_file'

local polymer = input_file.read_file("input.txt")

local function is_upper(l)
    return l == l:upper()
end

local reacted_polymer = {}
local comp_func

while true do
    local pos_1 = 1
    local pos_2 = 1
    local react = false
    local jump = false

    for l in polymer:gmatch("%a") do
        if not jump then
            if is_upper(l) then
                comp_func = l.lower
            else
                comp_func = l.upper
            end

            if comp_func(l) == polymer:sub(pos_2 + 1, pos_2 + 1) then
                table.insert(reacted_polymer, polymer:sub(pos_1, pos_2 - 1))
                jump = true
                react = true
                pos_1 = pos_2 + 2
            end
        else
            jump = false
        end
        pos_2 = pos_2 + 1
    end

    table.insert(reacted_polymer, polymer:sub(pos_1, pos_2 - 1))

    polymer = table.concat(reacted_polymer)
    reacted_polymer = {}

    if not react then break end
end

print(polymer:len())
