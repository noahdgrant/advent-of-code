-- Day 4 part 1

local contents = {}

for line in io.lines("input.txt") do
	table.insert(contents, line)
end

for i = 1, #contents do
	print(contents[i])
end

local xmas = "XMAS"
local count = 0

local function starts_with(word, prefix)
	return string.find(word, "^" .. prefix) == 1
end

local function check_direction(grid, word, row, rows, col, cols, direction)
	local current_word = grid[row]:sub(col, col)
	if starts_with(word, current_word) == false then
		return
	end

	local valid = true
	while valid do
		local new_row, new_col = row + direction[1], col + direction[2]
		if new_row < 1 or new_row > rows or new_col < 1 or new_col > cols then
			break
		end
		current_word = current_word .. grid[new_row]:sub(new_col, new_col)

		if starts_with(word, current_word) == false then
			break
		end

		if #word == #current_word then
			if starts_with(word, current_word) then
				print("Found XMAS", new_row, new_col)
				count = count + 1
			else
				break
			end
		end
		row, col = new_row, new_col
	end
end

local function find_word(grid, word)
	local rows = #grid
	local cols = #grid[1]

	for row = 1, rows do
		for col = 1, cols do
			check_direction(grid, word, row, rows, col, cols, { 0, 1 }) -- Right
			check_direction(grid, word, row, rows, col, cols, { 0, -1 }) -- Left
			check_direction(grid, word, row, rows, col, cols, { 1, 0 }) -- Down
			check_direction(grid, word, row, rows, col, cols, { -1, 0 }) -- Up
			check_direction(grid, word, row, rows, col, cols, { 1, 1 }) -- Diagonal Down-Right
			check_direction(grid, word, row, rows, col, cols, { -1, -1 }) -- Diagonal Up-Left
			check_direction(grid, word, row, rows, col, cols, { 1, -1 }) -- Diagonal Down-Left
			check_direction(grid, word, row, rows, col, cols, { -1, 1 }) -- Diagonal Up-Rightd
		end
	end
end

find_word(contents, xmas)
print(count)
