local input_file = require 'input_file'

local lines = input_file.read_file_lines("input.txt")

local orders = {}
local ready = {}
local done = {}
local in_progress = {}

local function task_to_seconds(task)
    -- "A" is byte 65
    return task:byte() - 4
end

local function print_ready()
    local r = ""
    for c in string.gmatch("ABCDEFGHIJKLMNOPQRSTUVWXYZ", "%a") do
        if ready[c] then r = r .. c end
    end
    return r
end

local function print_done()
    local r = ""
    for c in string.gmatch("ABCDEFGHIJKLMNOPQRSTUVWXYZ", "%a") do
        if done[c] then r = r .. c end
    end
    return r
end

local function update_ready_tasks()
    for c in string.gmatch("ABCDEFGHIJKLMNOPQRSTUVWXYZ", "%a") do
        if not ready[c] and not done[c] and not in_progress[c] then
            local add = true
            if not orders[c].prev then
                ready[c] = true
            else
                for _, prev in ipairs(orders[c].prev) do
                    if not done[prev] then
                        add = false
                        break
                    end
                end
                if add then ready[c] = true end
            end
        end
    end
end

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

local second = 0
local worker = {}

while true do
    -- Find tasks ready to be executes
    update_ready_tasks()
    local next_ready = print_ready()

    for i=1,5 do
        if not worker[i] then
            worker[i] = {}
            worker[i].task = nil
            worker[i].count = 0
        end

        if not worker[i].task then
            local task
            if next_ready ~= "" then
                task = next_ready:sub(1,1)
                next_ready = next_ready:sub(2,-1)
                worker[i].task = task
                worker[i].count = task_to_seconds(task)
                ready[task] = nil
                in_progress[task] = true
            end
        end

        if worker[i].task then
            worker[i].count = worker[i].count - 1
            if worker[i].count == 0 then
                done[worker[i].task] = true
                in_progress[worker[i].task] = nil
                worker[i].task = nil
                worker[i].count = 0
            end
        end
    end
    second = second + 1
    if #(print_done()) == 26 then break end
end

print(second)
