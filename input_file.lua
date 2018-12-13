local M = {}

function M.read_file(filename)
    local f = assert(io.open(filename, r))
    local r = assert(f:read("a"))
    f:close()
    return r
end

function M.read_file_lines(filename)
    local f = assert(io.open(filename, r))
    local r = {}
    while true do
        local l = f:read("l")
        if not l then break end
        table.insert(r, l)
    end
    f:close()
    return r
end

return M
