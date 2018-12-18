local input_file = require 'input_file'

local lines = input_file.read_file_lines("input.txt")

local points = {}

local min_x, max_x, min_y, max_y = math.huge, -math.huge, math.huge, -math.huge

for _, l in ipairs(lines) do
    local p = {}
    p.x = tonumber(l:match("position=< ?(%-?%d+)"))
    p.y = tonumber(l:match("(%-?%d+)> velocity"))
    p.v_x = tonumber(l:match("velocity=< ?(%-?%d+)"))
    p.v_y = tonumber(l:match("velocity=< ?%-?%d+, *(%-?%d+)"))
    if p.x < min_x then min_x = p.x end
    if p.x > max_x then max_x = p.x end
    if p.y < min_y then min_y = p.y end
    if p.y > max_y then max_y = p.y end
    table.insert(points, p)
end

local function print_points(minx, maxx, miny, maxy)
    local repr = {}
    for i=minx, maxx do
        repr[i] = {}

        for j=miny, maxy do
            repr[i][j] = '.'
        end
    end

    for _, p in ipairs(points) do
        if p.x < maxx and p.x > minx and p.y < maxy and p.y > minx then
            repr[p.x][p.y] = "#"
        end
    end

    for j=miny, maxy do
        local line = ""
        for i=minx, maxx do
            line = line .. repr[i][j]
        end
        print(line)
    end
end

local function move_points()
    for _, p in ipairs(points) do
        p.x = p.x + p.v_x
        p.y = p.y + p.v_y
    end
end

local function move_points_backward()
    for _, p in ipairs(points) do
        p.x = p.x - p.v_x
        p.y = p.y - p.v_y
    end
end

local function horizontal_dispertion()
    local temp_min_x, temp_max_x = math.huge, -math.huge
    for _, p in ipairs(points) do
        if p.x < temp_min_x then temp_min_x = p.x end
        if p.x > temp_max_x then temp_max_x = p.x end
    end

    return temp_min_x, temp_max_x
end

local function vertical_dispertion()
    local temp_min_y, temp_max_y = math.huge, -math.huge
    for _, p in ipairs(points) do
        if p.y < temp_min_y then temp_min_y = p.y end
        if p.y > temp_max_y then temp_max_y = p.y end
    end

    return temp_min_y, temp_max_y
end

local c = 0
local prev_v_disp = math.huge

while true do
    move_points()
    local tmin, tmax = vertical_dispertion()
    local v_disp = tmax - tmin

    if v_disp >= prev_v_disp then
        local xmin, xmax = horizontal_dispertion()
        move_points_backward()
        print_points(xmin-30, xmax+30, tmin-10, tmax+10)
        print(c, "seconds")
        break
    end

    prev_v_disp = v_disp
    c = c + 1
end
