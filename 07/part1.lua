local input_file = require 'input_file'

local lines = input_file.read_file_lines("input.txt")

local orders = {}
local ready = {}
local done = {}
local r = ""

for _, order in ipairs(lines) do
    local before = order:match("(%a) must")
    local after = order:match("(%a) can")
    if not orders[before] then orders[before] = {} end
    if not orders[before].next then orders[before].next = {} end
    if not orders[after] then orders[after] = {} end
    if not orders[after].prev then orders[after].prev = {} end
    table.insert(orders[before].next, after)
    table.insert(orders[after].prev, before)
end


for c in string.gmatch("ABCDEFGHIJKLMNOPQRSTUVWXYZ", "%a") do
    if not orders[c].prev then
        ready[c] = true
    end
end

for _=1,26 do
    local added = false
    local next_ready = ""
    for c in string.gmatch("ABCDEFGHIJKLMNOPQRSTUVWXYZ", "%a") do
        if ready[c] then
            if not added then
                r = r .. c
                added = true
                ready[c] = nil
                done[c] = true
            end
            if orders[c].next then
                for _, k in ipairs(orders[c].next) do
                    if not orders[k].prev then
                        next_ready = next_ready .. k
                    else
                        local add = true
                        for _, prev in ipairs(orders[k].prev) do
                            if not done[prev] then
                                add = false
                                break
                            end
                        end
                        if add then next_ready = next_ready .. k end
                    end
                end
            end
        end
    end

    for c in string.gmatch(next_ready, "%a") do
        ready[c] = true
    end
end

print(r)
