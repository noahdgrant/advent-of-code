-- Day 3 part 1

local file = io.open("input.txt", "r")
if file == nil then
    print("Error: Couldn't open file")
    os.exit(1)
end
local content = file:read("*all")
file:close()

print(content)

local total = 0
for x, y in string.gmatch(content, "mul%((%d+),(%d+)%)") do
    print("Found: " .. x .. " * " .. y)
    total = total + tonumber(x) * tonumber(y)
end

print("Total: " .. total)
