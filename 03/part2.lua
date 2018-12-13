local input_file = require 'input_file'

local lines = input_file.read_file_lines("input.txt")

local col = {}
local overlap = {}

for _, l in ipairs(lines) do
    local x = string.sub(l:match("%d+,"), 1, -2)
    local y = string.sub(l:match(",%d+"), 2)
    local w = string.sub(l:match("%d+x"), 1, -2)
    local h = string.sub(l:match("x%d+"), 2)
    local id = tonumber(string.sub(l:match("#%d+"), 2))

    for i=1,w do
        for j=1,h do
            if not col[x+i] then col[x+i] = {} end
            if not col[x+i][y+j] then
                col[x+i][y+j] = {}
                col[x+i][y+j][id] = true
            else
                for ids, _ in pairs(col[x+i][y+j]) do
                    overlap[ids] = true
                end
                overlap[id] = true
            end
        end
    end
end

for i=1,#lines do
    if not overlap[i] then
        print(i)
        return
    end
end
