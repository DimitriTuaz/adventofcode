local total = 0
local frequencies = {}

local f = assert(io.open("input.txt", r))
local s = f:read("a")

local count = 0

while true do
    for n in s:gmatch("[+-]%d+") do
        total = total + tonumber(n)

        if frequencies[total] then
            print(total)
            f:close()
            return
        end

        frequencies[total] = 1
    end
end

