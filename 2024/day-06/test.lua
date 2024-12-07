local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

local function table_find(tbl, element)
    for _, value in ipairs(tbl) do
        if value == element then
            return true
        end
    end
    return false
end

local grid = {}

-- Read the input file
local file = io.open("input.txt", "r")
if file then
    for line in file:lines() do
        table.insert(grid, {})
        for char in line:gmatch(".") do
            table.insert(grid[#grid], char)
        end
    end
    file:close()
end

local rows = #grid
local cols = #grid[1]
local guard_pos_y, guard_pos_x = 0, 0
local grid_visited = {}

for i = 1, rows do
    grid_visited[i] = {}
    for j = 1, cols do
        grid_visited[i][j] = false
        if grid[i][j] == "^" then
            guard_pos_y, guard_pos_x = i, j
            grid_visited[i][j] = true
        end
    end
end

local count = 0
local dirs = { { -1, 0 }, { 1, 0 }, { 0, -1 }, { 0, 1 } }
local dir_next = { [0] = 3, [1] = 2, [2] = 0, [3] = 1 }
local dir_index = 0
local dy, dx = -1, 0

local function check_loop(_grid, _dy, _dx, _guard_pos_y, _guard_pos_x, _dir_index)
    local _grid_visited = {}
    while true do
        if not _grid_visited[_guard_pos_y] then
            _grid_visited[_guard_pos_y] = {}
        end
        if not _grid_visited[_guard_pos_y][_guard_pos_x] then
            _grid_visited[_guard_pos_y][_guard_pos_x] = { _dir_index }
        elseif not table_find(_grid_visited[_guard_pos_y][_guard_pos_x], _dir_index) then
            table.insert(_grid_visited[_guard_pos_y][_guard_pos_x], _dir_index)
        else
            count = count + 1
            return
        end
        if _guard_pos_y + _dy >= 1 and _guard_pos_y + _dy <= rows and _guard_pos_x + _dx >= 1 and _guard_pos_x + _dx <= cols then
            if _grid[_guard_pos_y + _dy][_guard_pos_x + _dx] == "#" then
                _dir_index = dir_next[_dir_index]
                _dy, _dx = dirs[_dir_index + 1][1], dirs[_dir_index + 1][2]
                goto continue
            end
        else
            return
        end
        _guard_pos_y = _guard_pos_y + _dy
        _guard_pos_x = _guard_pos_x + _dx
        ::continue::
    end
end

while true do
    if guard_pos_y + dy >= 1 and guard_pos_y + dy <= rows and guard_pos_x + dx >= 1 and guard_pos_x + dx <= cols then
        if grid[guard_pos_y + dy][guard_pos_x + dx] == "#" then
            dir_index = dir_next[dir_index]
            dy, dx = dirs[dir_index + 1][1], dirs[dir_index + 1][2]
            goto continue
        elseif not grid_visited[guard_pos_y + dy][guard_pos_x + dx] then
            grid_visited[guard_pos_y + dy][guard_pos_x + dx] = true
            local grid_copy = deepcopy(grid)
            grid_copy[guard_pos_y + dy][guard_pos_x + dx] = "#"
            check_loop(grid_copy, dy, dx, guard_pos_y, guard_pos_x, dir_index)
        end
        guard_pos_y = guard_pos_y + dy
        guard_pos_x = guard_pos_x + dx
        ::continue::
    else
        break
    end
end

print(count)
