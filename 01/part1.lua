local total = 0

local f = assert(io.open("input.txt", r))
local s = f:read("a")

for n in s:gmatch("[+-]%d+") do
    total = total + tonumber(n)
end

f:close()

print(total)

