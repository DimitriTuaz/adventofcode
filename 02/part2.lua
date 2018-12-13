local input_file = require 'input_file'

local function correct_id(id1, id2)
    local len = id1:len()
    local diff = 0

    for i=1,len do
        if id1:byte(i) ~= id2:byte(i) then
            diff = diff + 1
        end

        if diff == 2 then return false end
    end

    return true
end

local s = input_file.read_file("input.txt")
local id1 = s:match("%a+")
local pos = id1:len() + 1
local pos_g = pos

while true do
    while true do
        local id2 =  s:match("%a+", pos)
        if not id2 then break end
        pos = pos + id2:len() + 1

        if correct_id(id1, id2) then
            print("Correct ids :")
            print(id1, "| line :", pos_g // (id1:len() + 1))
            print(id2, "| line :", pos // (id2:len() + 1))
            return
        end
    end
    id1 =  s:match("%a+", pos_g)
    pos_g = pos_g + id1:len() + 1
    pos = pos_g
    if not id1 then return end
end
