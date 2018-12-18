local input_file = require 'input_file'

local tree = input_file.read_file("input.txt")

local meta_sum = 0

local pos = 1

local function process_node(pos)
    local n_child, n_meta = 0, 0

    n_child = tonumber(tree:match("%d+", pos))

    if n_child < 10 then
        pos = pos + 2
    else
        pos = pos + 3
    end

    n_meta = tonumber(tree:match("%d+", pos))

    if n_meta < 10 then
        pos = pos + 2
    else
        pos = pos + 3
    end

    if n_child ~= 0 then
        for i=1, n_child do
            pos = process_node(pos)
        end
    end

    for c in tree:sub(pos):gmatch("%d+") do
        meta_sum = meta_sum + tonumber(c)
        if tonumber(c) < 10 then
            pos = pos + 2
        else
            pos = pos + 3
        end
        n_meta = n_meta - 1
        if n_meta == 0 then break end
    end

    return pos
end

process_node(pos)

print(meta_sum)
