local input_file = require 'input_file'

local tree_str = input_file.read_file("input.txt")

local pos = 1

local depth = 0
local node = 0
local tree = {}

local function process_node(pos, test)
    local n_child, n_meta = 0, 0

    depth = depth + 1

    n_child = tonumber(tree_str:match("%d+", pos))

    if n_child < 10 then
        pos = pos + 2
    else
        pos = pos + 3
    end

    n_meta = tonumber(tree_str:match("%d+", pos))

    if n_meta < 10 then
        pos = pos + 2
    else
        pos = pos + 3
    end

    node = node + 1

    local child_id

    if n_child ~= 0 then
        child_id = {}
        for i=1, n_child do
            table.insert(child_id, node + i)
        end
    end

    table.insert(tree, {node=node, child_id=child_id, depth=depth})

    local parent = node
    local yolo = 1

    if n_child ~= 0 then
        for i=1, n_child do
            pos, yolo = process_node(pos, parent)
        end
    end

    local meta = nil

    for c in tree_str:sub(pos):gmatch("%d+") do
        if n_child == 0 then
            if not meta then meta = 0 end
            meta = meta + tonumber(c)
        else
            if not meta then meta = {} end
            table.insert(meta, tonumber(c))
        end
        if tonumber(c) < 10 then
            pos = pos + 2
        else
            pos = pos + 3
        end
        n_meta = n_meta - 1
        if n_meta == 0 then break end
    end


    if n_child == 0 then
        tree[node].meta = meta
    else
        tree[yolo].meta = meta
    end

    depth = depth - 1

    return pos, test
end

process_node(pos, 0)

local meta_sum = 0

local function comp_meta(node_id)
    if type(tree[node_id].meta) == "table" then
        for _, child_id in ipairs(tree[node_id].meta) do
            if tree[node_id].child_id[child_id] then
                comp_meta(tree[node_id].child_id[child_id])
            end
        end
    else
        meta_sum = meta_sum + tree[node_id].meta
    end
end

comp_meta(1)

print(meta_sum)


