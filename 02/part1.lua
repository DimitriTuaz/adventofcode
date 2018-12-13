local f = assert(io.open("input.txt", r))
local s = f:read("a")

local two, three = 0, 0

for id in s:gmatch("%a+") do
    local l_freq = {}
    for l in id:gmatch("%a") do
        if not l_freq[l] then l_freq[l] = 0 end
        l_freq[l] = l_freq[l] + 1
    end

    for i, v in pairs(l_freq) do
        if v == 2 then two = two + 1; break end
    end

    for i, v in pairs(l_freq) do
        if v == 3 then three = three + 1; break end
    end
end

f:close()
print(two * three)

