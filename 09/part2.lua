local input_file = require 'input_file'

local input = input_file.read_file("input.txt")

local pp = require 'pl.pretty'

local n_player = tonumber(input:match("(%d+) players"))
local max_idx = tonumber(input:match("(%d+) points")) * 100

local marbles = {}

local function get_left(idx)
    return marbles[idx].l
end

local function get_right(idx)
    return marbles[idx].r
end

local function print_marbles(str)
    local r, idx= "", 0
    while true do
        r = r .. string.format("%3d ", idx)
        idx = get_right(idx)
        if idx == 0 then break end
    end
    print(str .. r)
end

local function insert(idx, cur_idx)
    if idx == 0 then
        marbles[0] = {idx=0, l=0, r=0}
    else
        local idx_l = get_left(cur_idx)
        local idx_r = cur_idx
        marbles[idx_l].r = idx
        marbles[idx_r].l = idx
        marbles[idx] = {idx=idx, l=idx_l, r=idx_r}
    end
end

local function remove(idx)
    local idx_l = get_left(idx)
    local idx_r = get_right(idx)
    marbles[idx] = nil
    marbles[idx_l].r = idx_r
    marbles[idx_r].l = idx_l
end

local score = {}
for i=1,n_player do
    score[i] = 0
end
local player_idx, cur_idx = 0, 0

insert(0, 0)

for i=1,max_idx do
    player_idx = player_idx + 1
    if player_idx > n_player then player_idx = 1 end

    if i % 23 == 0 then
        for _=1,9 do cur_idx = get_left(cur_idx) end
        local next_idx = get_right(cur_idx)
        score[player_idx] = score[player_idx] + i + cur_idx
        remove(cur_idx)
        cur_idx = get_right(get_right(next_idx))
    else
        insert(i, cur_idx)
        cur_idx = get_right(cur_idx)
    end

    --print_marbles("["..player_idx.."] ")
end

table.sort(score, function(a,b) return a>b end)
print(score[1])
