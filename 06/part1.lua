local input_file = require 'input_file'

local point_list = input_file.read_file_lines("input.txt")

local points = {}

local min_x, max_x, min_y, max_y = 1000, 0, 1000, 0

for _, p in ipairs(point_list) do
    local point ={}
    point.x = tonumber(p:match("(%d+),"))
    point.y = tonumber(p:match(", (%d+)"))
    if point.x < min_x then min_x = point.x end
    if point.x > max_x then max_x = point.x end
    if point.y < min_y then min_y = point.y end
    if point.y > max_y then max_y = point.y end
    table.insert(points, point)
end

local function distance(p1, p2)
    return math.abs(p1.x - p2.x) + math.abs(p1.y - p2.y)
end

-- Table containing the current proprietary of the point and the distance
local prop = {}

local score = {}

for id, p in ipairs(points) do
    local cur_p = {x=0, y=0}
    score[id] = 0

    for i=min_x,max_x do
        for j=min_y,max_y do
            cur_p.x = i
            cur_p.y = j

            local d = distance(cur_p, p)

            if not prop[i] then prop[i] = {} end
            if not prop[i][j] then prop[i][j] = {} end

            local prev_id = prop[i][j].id

            if not prop[i][j].id or prop[i][j].d > d then
                if prev_id and score[prev_id] and score[prev_id] ~= "." then
                    score[prev_id] = score[prev_id] - 1
                end
                score[id] = score[id] + 1
                prop[i][j].id = id
                prop[i][j].d = d

            elseif prop[i][j].d == d then
                prop[i][j].id = '.'
                if prev_id and score[prev_id] and score[prev_id] ~= "." then
                    score[prev_id] = score[prev_id] - 1
                end
            end
        end
    end
end

for i=min_x,max_x do
    local id = prop[i][max_y].id
    if score[id] then score[id] = nil end
    id = prop[i][min_y].id
    if score[id] then score[id] = nil end
end

for j=min_y,max_y do
    local id = prop[min_x][j].id
    if score[id] then score[id] = nil end
    id = prop[max_x][j].id
    if score[id] then score[id] = nil end
end


print("\n-----------\n")
for id, s in pairs(score) do
    print(id, s)
end
