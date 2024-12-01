-- Day 1 part 2

local total = 0
local left = {}
local right = {}

for line in io.lines("input.txt", "l") do
    local s, e = string.find(line, "   ")
    local l = string.sub(line, 1, s)
    local r = nil
    if e ~= nil then
        r = string.sub(line, e + 1, -1)
    else
        print("Error: string pattern not found in line - " .. line)
        os.exit(1)
    end
    table.insert(left, math.tointeger(l))
    table.insert(right, math.tointeger(r))
end

assert(#left == #right, "Error: Left (%d) != right (%d)", #left, #right)

for i = 1, #left do
    local times = 0
    for j = 1, #right do
        if left[i] == right[j] then
            times = times + 1
        end
    end
    total = total + (left[i] * times)
end

print("Total: " .. total)
