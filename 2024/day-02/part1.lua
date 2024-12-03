-- Day 2 part 1

local safe = 0

local function split(str)
	local t = {}
	for word in string.gmatch(str, "%S+") do
		table.insert(t, word)
	end
	return t
end

for line in io.lines("input.txt", "l") do
	local parts = split(line)
	local row = {}
	for i = 1, #parts do
		table.insert(row, math.tointeger(parts[i]))
	end

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

	if safe_row == true then
		safe = safe + 1
	end
end

print("Safe: " .. safe)
