local input_file = require 'input_file'

local lines = input_file.read_file_lines("input.txt")

local guard_sleep = {}
local guard_days = {}
local actions = {}

local function line_to_time(l)
    local month = l:match("%-(%d+)%-")
    local day = l:match("%-(%d+) ")
    local hour = l:match("(%d+):")
    local time = os.time{year=2018, month=month, day=day}

    if hour == "23" then
        time = time + (24*3600)
        month = os.date("%m", time)
        day = os.date("%d", time)
    end

    return time
end

local function update_sleep_schedule(day)
    local id = guard_days[day]
    if not guard_sleep[id] then guard_sleep[id] = {} end
    local state = "awake"
    local minute = 0

    if not actions[day] then
        -- Guard stay awake all shift long
        for i=0,59 do
            if not guard_sleep[id][i] then guard_sleep[id][i] = 0 end
            guard_sleep[id][i] = guard_sleep[id][i] + 1
        end
        return
    end

    for _, t in pairs(actions[day]) do
        if state == "awake" then
            if t.action ~= 'f' then
                print("ERROR, if awake, can only fall asleep")
                return -1
            else
                for i=minute+1,t.minute do
                    if not guard_sleep[id][i] then guard_sleep[id][i] = 0 end
                end
                state = "asleep"
            end
        else
             if t.action ~= 'w' then
                print("ERROR, if asleep, can only wake up")
                return -1
            else
                for i=minute+1,t.minute do
                    if not guard_sleep[id][i] then guard_sleep[id][i] = 0 end
                    guard_sleep[id][i] = guard_sleep[id][i] + 1
                end
                state = "awake"
            end
        end
        minute = t.minute
    end

    for i=minute+1, 60 do
        if state == "awake" then
            if not guard_sleep[id][i] then guard_sleep[id][i] = 0 end

        else
            if not guard_sleep[id][i] then guard_sleep[id][i] = 0 end
            guard_sleep[id][i] = guard_sleep[id][i] + 1
        end
    end
end

for _, l in ipairs(lines) do
    local time = line_to_time(l)

    local id = l:match("#(%d+)")
    if id then
        guard_days[time] = tonumber(id)
    else
        local minute = l:match("(%d+)%]")
        if not actions[time] then actions[time] = {} end
        if l:match("wakes") then
            table.insert(actions[time], {minute = minute, action = 'w'})
        else
            table.insert(actions[time], {minute = minute, action = 'f'})
        end
    end
end

for time, t in pairs(actions) do
    table.sort(t, function(a, b) return a.minute < b.minute end)
end

for time, _ in pairs(guard_days) do
    update_sleep_schedule(time)
end

local total_sleep = {}
local best_minute = {}

for id,t in pairs(guard_sleep) do
    local sleep = 0
    for _, s in pairs(t) do
        sleep = sleep + s
    end
    table.insert(total_sleep, {sleep=sleep, id=id})
end
table.sort(total_sleep, function(a,b) return a.sleep > b.sleep end)

for minute, n_sleep in pairs(guard_sleep[total_sleep[1].id]) do
    table.insert(best_minute, {minute=minute-1, n_sleep=n_sleep})
end

table.sort(best_minute, function(a, b) return a.n_sleep > b.n_sleep end)

print(total_sleep[1].id * best_minute[1].minute)
