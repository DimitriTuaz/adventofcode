local input_file = require 'input_file'

local function is_cart(c)
    if c == "v" or c == "<" or c == "^" or c == ">" then return true end
    return false
end

local M = {}

local M_cart = {}

function M_cart.move(self, map)
    if self.dir == ">" then self.x = self.x + 1 end
    if self.dir == "<" then self.x = self.x - 1 end
    if self.dir == "^" then self.y = self.y - 1 end
    if self.dir == "v" then self.y = self.y + 1 end

    for _, c in ipairs(map.cart) do
        if self.x == c.x and self.y == c.y and self.id ~= c.id then
            print(string.format("Collision at (%3d, %3d) (cart %d and %d)", self.x - 1, self.y - 1, self.id, c.id))
            return {id1=self.id, id2=c.id}
        end
    end

    -- Rotate the cart if needed
    if map.map[self.x][self.y] == "\\" then
        if self.dir == ">" then self.dir = "v"
        elseif self.dir == "<" then self.dir = "^"
        elseif self.dir == "^" then self.dir = "<"
        elseif self.dir == "v" then self.dir = ">" end
    elseif map.map[self.x][self.y] == "/" then
        if self.dir == ">" then self.dir = "^"
        elseif self.dir == "<" then self.dir = "v"
        elseif self.dir == "^" then self.dir = ">"
        elseif self.dir == "v" then self.dir = "<" end
    elseif map.map[self.x][self.y] == "+" then
        if self.inter == "l" then
            if self.dir == ">" then self.dir = "^"
            elseif self.dir == "<" then self.dir = "v"
            elseif self.dir == "^" then self.dir = "<"
            elseif self.dir == "v" then self.dir = ">" end
            self.inter = "s"
        elseif self.inter == "s" then
            self.inter = "r"
        else
            if self.dir == ">" then self.dir = "v"
            elseif self.dir == "<" then self.dir = "^"
            elseif self.dir == "^" then self.dir = ">"
            elseif self.dir == "v" then self.dir = "<" end
            self.inter = "l"
        end
    end

    return nil
end

local id = 0
function M.new_cart(x, y, dir)
    id = id + 1
    return setmetatable({id=id, x=x, y=y, dir=dir, inter="l"}, {__index = M_cart})
end

function M.remove_cart(self, id)
    local idx = 1
    for _, c in ipairs(self.cart) do
        if c.id == id then table.remove(self.cart, idx); return end
        idx = idx + 1
    end
end

function M.order_carts(self)
    table.sort(self.cart, function(a,b)
        if a.y ~= b.y then return a.y < b.y else return a.x < b.x end
    end)
end

function M.tick(self)
    self:order_carts()
    local to_remove = {}
    for _, c in ipairs(self.cart) do
        local r = c:move(self)
        if r then table.insert(to_remove, r) end

    end

    for _, ids in ipairs(to_remove) do
        self:remove_cart(ids.id1)
        self:remove_cart(ids.id2)
    end
end

function M.directions(self, x, y)
    local r = {}
    if self.map[x-1] and self.map[x-1][y] and self.map[x-1][y]:find("[/\\%-%+]") then r.l = true end
    if self.map[x+1] and self.map[x+1][y] and self.map[x+1][y]:find("[/\\%-%+]") then r.r = true end
    if self.map[x][y-1] and self.map[x][y-1]:find("[/\\|%+]") then r.u = true end
    if self.map[x][y+1] and self.map[x][y+1]:find("[/\\|%+]") then r.d = true end
    return r
end

function M.connection(self, x, y)
    local r = self:directions(x, y)

    if r.l and r.r and not r.u and not r.d then return "-"
    elseif r.l and r.u and not r.r and not r.d then return "/"
    elseif r.d and r.r and not r.l and not r.u then return "/"
    elseif r.l and r.d and not r.u and not r.r then return "\\"
    elseif r.u and r.r and not r.l and not r.d then return "\\"
    elseif r.u and r.d and not r.l and not r.r then return "|"
    elseif r.l and r.r and r.u and r.d then return "+"
    else return "ERROR connection" end
end

function M.parse(self, input)
    local lines = input_file.read_file_lines(input)

    self.x_max = 1
    self.y_max = #lines

    for y, l in ipairs(lines) do
        local x = 1
        for c in l:gmatch(".") do
            if not self.map[x] then self.map[x] = {} end

            if is_cart(c) then
                table.insert(self.cart, self.new_cart(x, y, c))
            else
                self.map[x][y] = c
            end

            if x > self.x_max then self.x_max = x end
            x = x + 1
        end
    end

    for _, c in ipairs(self.cart) do
        self.map[c.x][c.y] = self:connection(c.x, c.y)
    end
end

function M.repr(self, with_carts)
    local r = {}
    for y=1,self.y_max do
        for x=1,self.x_max do
            if self.map[x][y] then
                table.insert(r, self.map[x][y])
                if with_carts then
                    for _, c in ipairs(self.cart) do
                        if x == c.x and y == c.y then
                            table.remove(r)
                            table.insert(r, c.dir)
                            break
                        end
                    end
                end
            end
        end
        table.insert(r, "\n")
    end
    return table.concat(r)
end

local function new_map()
    return setmetatable({map={}, x_max=0, y_max=0, cart={}}, {__index = M})
end

local map = new_map()

map:parse("input.txt")

while true do
    --print(map:repr(true))
    map:tick()
    if #map.cart == 1 then break end
end

print(string.format("\nLast cart : %d at (%3d,%3d)",
    map.cart[1].id,
    map.cart[1].x - 1,
    map.cart[1].y - 1
))

