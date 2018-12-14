local input_file = require 'input_file'

local p = input_file.read_file("input.txt")

local function is_upper(l)
    return l == l:upper()
end

local function reacting(polymer)
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

    return polymer:len()
end

local function remove_unit(polymer, unit)
    local pos_1 = 1
    local pos_2 = 1
    local clean_polymer = {}

    for l in polymer:gmatch("%a") do
        if l:lower() == unit then
            table.insert(clean_polymer, polymer:sub(pos_1, pos_2 - 1))
            pos_1 = pos_2 + 1
        end
        pos_2 = pos_2 + 1
    end

    table.insert(clean_polymer, polymer:sub(pos_1, pos_2 - 1))

    return table.concat(clean_polymer)
end

local polymers = {}

for c in string.gmatch("abcdefghyjklmnopqrstuvwxyz", "%a") do
    print(string.format("Working for unit \'%s\'...", c))
    local length = reacting(remove_unit(p, c))
    table.insert(polymers, {unit=c, length=length})
end

table.sort(polymers, function(a, b) return a.length < b.length end)

print("\n-------------\n")

for _, t in ipairs(polymers) do
    print(string.format("Unit %s : %10d", t.unit, t.length))
end

