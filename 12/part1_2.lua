local input_file = require 'input_file'

local line = input_file.read_file_lines("input.txt")

local initial_state = line[1]:match("[%.#]+")
local note = {}

for i=3,#line do
    local pattern = line[i]:match("[%.#]+")
    local res = line[i]:match("=> ([%.#])")
    table.insert(note, {pattern=pattern, res=res})
end

local function next_generation(gen_str)
    local next_gen_t = {}

    for _,n in ipairs(note) do
        local b,e = 0
        while true do
            b,e = gen_str:find(n.pattern, b+1, true)
            if not b then break end
            if n.res == "#" then
                next_gen_t[b+1] = true
            else
                next_gen_t[b+1] = nil
            end
        end
    end
    return next_gen_t
end

local function gen_t_to_str(gen_table, size)
    local gen_str = ""

    for i=0, size do
        if gen_table[i] then
            gen_str = gen_str .. "#"
        else
            gen_str = gen_str .. "."
        end
    end
    return gen_str
end

local extra_pots = 200
local gen = string.rep(".", extra_pots) .. initial_state .. string.rep(".", extra_pots)
local size = #gen

local function gen_sum(gen)
    local sum = 0
    for i=1, size do
        if gen:sub(i,i) == "#" then
            sum = sum + i - extra_pots - 1
        end
    end
    return sum
end

local x1, x2, y1, y2 = 0, 0, 0, 0

for i=1,130 do
    gen = next_generation(gen)
    gen = gen_t_to_str(gen, size)
    if i == 20 then print("Sum after 20 generations", gen_sum(gen)) end
    print(gen)
    -- From gen n°110, the sum is an affine function
    if i == 110 then x1=i;y1=gen_sum(gen) end
    if i == 120 then x2=i;y2=gen_sum(gen) end
end

local a, b = 0, 0

a = (y1 - y2) / (x1 - x2)
b = y1 - (a * x1)

print("Sum after 50000000000 generations", a * 50000000000 + b)
