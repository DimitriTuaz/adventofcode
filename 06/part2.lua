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
local distances = {}

for id, p in ipairs(points) do
    local cur_p = {x=0, y=0}

    for i=min_x,max_x do
        for j=min_y,max_y do
            cur_p.x = i
            cur_p.y = j

            local d = distance(cur_p, p)

            if not distances[i] then distances[i] = {} end
            if not distances[i][j] then distances[i][j] = 0 end

            distances[i][j] = distances[i][j] + d
        end
    end
end

local count = 0
for i=min_x,max_x do
    local line = ""
    for j=min_y,max_y do
        if distances[i][j] < 10000 then
            count = count + 1
            line = line .. "X"
        else
            line = line .. "."
        end
    end
    print(line)
end

print(count)
