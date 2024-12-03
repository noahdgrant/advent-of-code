-- Day 2 part 2

local safe = 0

local function split(str)
    local t = {}
    for word in string.gmatch(str, "%S+") do
        table.insert(t, word)
    end
    return t
end

local function deep_copy(t)
    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            -- Recursively copy nested tables
            copy[k] = deep_copy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

local function check_row(row)
    local up = false
    if row[2] > row[1] then
        up = true
    end

    local safe_row = true
    for i = 1, #row - 1 do
        if up == true then
            if row[i + 1] <= row[i] or row[i + 1] - 3 > row[i] then
                safe_row = false
                break
            end
        else
            if row[i + 1] >= row[i] or row[i + 1] + 3 < row[i] then
                safe_row = false
                break
            end
        end
    end

    return safe_row
end

for line in io.lines("input.txt", "l") do
    local parts = split(line)
    local row = {}
    for i = 1, #parts do
        table.insert(row, math.tointeger(parts[i]))
    end

    local safe_row = check_row(row)
    if safe_row == false then
        for i = 1, #row do
            local tmp = deep_copy(row)
            table.remove(tmp, i)
            safe_row = check_row(tmp)
            if safe_row == true then
                break
            end
        end
    end

    if safe_row == true then
        safe = safe + 1
    end
end

print("Safe: " .. safe)
