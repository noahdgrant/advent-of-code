-- Day 6 part 2

local inspect = require("inspect")

-- row, column
local directions = {
    { -1, 0 }, -- up
    { 0,  1 }, -- right
    { 1,  0 }, -- down
    { 0,  -1 }, --left
}

-- starting direction is up
local dir_index = 1
local direction = directions[dir_index]

local function load_map(filename)
    local map = {}
    local line_number = 1

    for line in io.lines(filename) do
        map[line_number] = {}
        for i = 1, #line do
            map[line_number][i] = line:sub(i, i)
        end
        line_number = line_number + 1
    end

    return map
end

local function deep_copy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == "table" then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deep_copy(orig_key)] = deep_copy(orig_value)
        end
        setmetatable(copy, deep_copy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

local function print_map(map)
    for _, value in ipairs(map) do
        print(table.concat(value, ""))
    end
end

local function find_caret(map)
    for y, row in ipairs(map) do
        for x = 1, #row do
            if row[x] == "^" then
                return { y, x }
            end
        end
    end
    return nil
end

local function is_same(table1, table2)
    if #table1 ~= #table2 then
        return false
    end

    for i = 1, #table1 do
        if table1[i] ~= table2[i] then
            return false
        end
    end

    return true
end

local function can_leave(map, pos, dir)
    local row = pos[1]
    local col = pos[2]
    local up = directions[1]
    local right = directions[2]
    local down = directions[3]
    local left = directions[4]
    local leave = false
    -- print("Leave ?", row, col, inspect(dir))
    if is_same(dir, up) and row == 1 then
        -- at top of grid
        leave = true
    elseif is_same(dir, down) and row == #map then
        -- at bottom of grid
        leave = true
    elseif is_same(dir, left) and col == 1 then
        -- left side
        leave = true
    elseif is_same(dir, right) and col == #map then
        -- right side
        leave = true
    end
    return leave
end

local function is_wall(map, pos, dir)
    local wall = false
    local row = pos[1] + dir[1]
    local col = pos[2] + dir[2]
    local char = map[row][col]
    -- print("Next pos", row, col, "is", char)
    if char == "#" then
        wall = true
    end
    return wall
end

local function next_dir_index(value)
    value = value + 1
    if value > #directions then
        value = 1
    end
    return value
end

local function create_visited_table(map)
    local visited = {}
    for y, row in ipairs(map) do
        visited[y] = {}
        for x = 1, #row do
            if map[y][x] == "^" then
                visited[y][x] = true
            else
                visited[y][x] = false
            end
        end
    end
    return visited
end

local function get_visited(map, pos, dir)
    local visited = create_visited_table(map)
    while true do
        -- check position infront of carrot
        -- if border (would leave the board), return
        if can_leave(map, pos, dir) then
            break
        end
        -- if there is a #, turn right
        if is_wall(map, pos, dir) then
            -- keep it between 1 and 4
            dir_index = next_dir_index(dir_index)
            dir = directions[dir_index]
        end
        -- move forward and ++ step count
        pos[1] = pos[1] + dir[1]
        pos[2] = pos[2] + dir[2]
        if not visited[pos[1]][pos[2]] then
            visited[pos[1]][pos[2]] = true
        end
    end
    return visited
end

local function traverse(map, pos, dir)
    local can_exit = false
    local visited = {}
    while not visited[pos[1]] or not visited[pos[1]][pos[2]] or not visited[pos[1]][pos[2]][dir] do
        visited[pos[1]] = visited[pos[1]] or {}
        visited[pos[1]][pos[2]] = visited[pos[1]][pos[2]] or {}
        visited[pos[1]][pos[2]][dir] = true
        -- check position infront of carrot
        -- if border (would leave the board), return
        if can_leave(map, pos, dir) then
            can_exit = true
            break
        end
        -- if there is a #, turn right
        if is_wall(map, pos, dir) then
            dir_index = next_dir_index(dir_index)
            dir = directions[dir_index]
        end
        -- move forward and ++ step count
        pos[1] = pos[1] + dir[1]
        pos[2] = pos[2] + dir[2]
    end
    return can_exit
end

local map = load_map("input.txt")
local starting_position = find_caret(map)
local visited = get_visited(map, starting_position, direction)

local stuck = 0

for i = 1, #map do
    for j = 1, #map do
        if map[i][j] == "#" then
            -- skip duplicates
            goto continue
        end

        -- can only be squares that were initially visited
        if not visited[i][j] then
            goto continue
        end

        starting_position = find_caret(map)
        dir_index = 1
        direction = directions[dir_index]
        local tmp = deep_copy(map)
        tmp[i][j] = "#"
        -- print(i, j)
        -- print_map(tmp)
        if not traverse(tmp, starting_position, direction) then
            stuck = stuck + 1
        end
        -- print()
        -- print_map(tmp)
        -- print()
        ::continue::
    end
end
print("Stuck count", stuck)
