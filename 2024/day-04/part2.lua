-- Day 4 part 2

local contents = {}

for line in io.lines("input.txt") do
	table.insert(contents, line)
end

local pattern1 = { "M.S", ".A.", "M.S" }
local pattern2 = { "M.M", ".A.", "S.S" }
local pattern3 = { "S.M", ".A.", "S.M" }
local pattern4 = { "S.S", ".A.", "M.M" }

local patterns = {}
table.insert(patterns, pattern1)
table.insert(patterns, pattern2)
table.insert(patterns, pattern3)
table.insert(patterns, pattern4)

local count = 0

local function check_match(chunk, opt)
	for i = 1, #chunk do
		for j = 1, #chunk[i] do
			if opt[i]:sub(j, j) ~= "." then
				if chunk[i]:sub(j, j) ~= opt[i]:sub(j, j) then
					return false
				end
			end
		end
	end
	return true
end

local function find_pattern(grid, opts)
	local rows = #grid
	local cols = #grid[1]

	for p = 1, #opts do
		for row = 1, rows - 2 do
			for col = 1, cols - 2 do
				local chunk = {}
				chunk[1] = grid[row]:sub(col, col + 2)
				chunk[2] = grid[row + 1]:sub(col, col + 2)
				chunk[3] = grid[row + 2]:sub(col, col + 2)
				if check_match(chunk, opts[p]) then
					count = count + 1
				end
			end
		end
	end
end

find_pattern(contents, patterns)
print("Count: " .. count)
