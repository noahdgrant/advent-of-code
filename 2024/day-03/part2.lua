-- Day 3 part 2

local file = io.open("input.txt", "r")
if file == nil then
    print("Error: Couldn't open file")
    os.exit(1)
end
local content = file:read("*all")
file:close()

local dos = {}
local next_do = 1
local do_pattern = "do%(%)"
for _ in string.gmatch(content, do_pattern) do
    local start_index, end_index = string.find(content, do_pattern, next_do)
    print(string.format("Found: do() - start: %d end: %d", start_index, end_index))
    table.insert(dos, { start_index, end_index })
    next_do = end_index + 1
end

local donts = {}
local next_dont = 1
local dont_pattern = "don%'t%(%)"
for _ in string.gmatch(content, do_pattern) do
    local start_index, end_index = string.find(content, dont_pattern, next_dont)
    if start_index ~= nil then
        print(string.format("Found: don't() - start: %d end: %d", start_index, end_index))
        table.insert(donts, { start_index, end_index })
        next_dont = end_index + 1
    end
end

local safe = {}
local do_mult = true
local do_index = 1
local dont_index = 1
local i = 1
while i < string.len(content) do
    if do_mult == true then
        if dont_index <= #donts then
            local start_index, end_index = table.unpack(donts[dont_index])
            dont_index = dont_index + 1

            while dont_index <= #donts and start_index < i do
                start_index, end_index = table.unpack(donts[dont_index])
                dont_index = dont_index + 1
            end

            if start_index < i then
                goto continue
            end

            print("Safe until: " .. start_index)
            while i < start_index do
                table.insert(safe, i, 1)
                print(i .. " safe")
                i = i + 1
            end

            while i <= end_index do
                table.insert(safe, i, 0)
                print(i .. " unsafe")
                i = i + 1
            end

            do_mult = false
            print("'do_mult' is false")
        else
            while i < string.len(content) do
                table.insert(safe, i, 1)
                print(i .. " safe")
                i = i + 1
            end
        end
    else
        if do_index <= #dos then
            local start_index, end_index = table.unpack(dos[do_index])
            do_index = do_index + 1

            while do_index <= #dos and start_index < i do
                start_index, end_index = table.unpack(dos[do_index])
                do_index = do_index + 1
            end

            if start_index < i then
                goto continue
            end

            print("Unsafe until: " .. start_index)
            while i < start_index do
                table.insert(safe, i, 0)
                print(i .. " unsafe")
                i = i + 1
            end

            while i <= end_index do
                table.insert(safe, i, 1)
                print(i .. " safe")
                i = i + 1
            end

            do_mult = true
            print("'do_mult' is true")
        else
            while i < string.len(content) do
                table.insert(safe, i, 0)
                print(i .. " unsafe")
                i = i + 1
            end
        end
    end
    ::continue::
end

local result = ""
for _, value in ipairs(safe) do
    result = result .. value
end
print(result)

local total = 0
local pattern = "mul%((%d+),(%d+)%)"
local next_start = 1
for x, y in string.gmatch(content, pattern) do
    local start_index, end_index = string.find(content, pattern, next_start)
    print(string.format("Found: %s * %s - start: %d end: %d", x, y, start_index, end_index))
    next_start = end_index + 1

    if safe[start_index] == 1 then
        total = total + tonumber(x) * tonumber(y)
    else
        print(start_index .. " is not safe - skipping")
    end
end

print("Num do: " .. #dos)
print("Num dont: " .. #donts)
print("Total: " .. total)
