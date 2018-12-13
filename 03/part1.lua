local input_file = require 'input_file'

local lines = input_file.read_file_lines("input.txt")

local col = {}
local max_w, max_h = 0, 0

local function print_piece()
    for i=1,max_w do
        line = ""
        for j=1,max_h do
            if not col[i] or not col[i][j] then
                line = line .. "."
            else
                line = line .. tostring(col[i][j])
            end
        end
        print(line)
    end
end

for _, l in ipairs(lines) do
    local x = string.sub(l:match("%d+,"), 1, -2)
    local y = string.sub(l:match(",%d+"), 2)
    local w = string.sub(l:match("%d+x"), 1, -2)
    local h = string.sub(l:match("x%d+"), 2)

    for i=1,w do
        for j=1,h do
            if not col[x+i] then col[x+i] = {} end
            if not col[x+i][y+j] then
                col[x+i][y+j] = 1
            else
                col[x+i][y+j] = col[x+i][y+j] + 1
            end
            if i+x >= max_w then max_w = i+x+1 end
            if j+y >= max_h then max_h = j+y+1 end
        end
    end
end

local c = 0

for i=1,max_w do
    for j=1,max_h do
        if col[i] and col[i][j] then
            if col[i][j] >=2 then c = c + 1 end
        end
    end
end

print(c)


