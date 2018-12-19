local serial_number = 7400
local max = 300

local function print_subgrid(grid, xa, xb, ya, yb)
    for j=ya, yb do
        local line = ""
            for i=xa, xb do
            line = line .. string.format("%2d",grid[i][j]) .. " "
        end
        print(line)
    end
end

local power_grid = {}
local max_power = -math.huge
local x_max_power = 1
local y_max_power = 1
local size_max_power = 1

for i=1,max do
    power_grid[i] = {}
    for j=1,max do
        local power_level = (((i + 10) * j) + serial_number) * (i + 10)
        power_level = tonumber(tostring(power_level):sub(-3, -3)) - 5
        power_grid[i][j] = power_level
    end
end

for s=1,300 do
    for i=1,max-s do
        for j=1,max-s do
            local total_power = 0
            for k=0,s-1 do
                for l=0,s-1 do
                    total_power = total_power + power_grid[i + k][j + l]
                end
            end
            if total_power > max_power then
                max_power = total_power
                x_max_power = i
                y_max_power = j
                size_max_power = s
            end
        end
    end
    print("Size = ", s)
    print(string.format("<%3d,%3d> %d (%d)", x_max_power, y_max_power, size_max_power, max_power))
end

print("------")
print(string.format("<%3d,%3d> %d (%d)", x_max_power, y_max_power, size_max_power, max_power))
