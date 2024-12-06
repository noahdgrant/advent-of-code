-- Day 5 part 2

local filename = "input.txt"
local file = io.open(filename, "r")
local content = nil
if file then
	content = file:read("*a")
	file:close()
else
	print("Error reading file")
end

local s, e = string.find(content, "\n\n")
local rule_block = string.sub(content, 1, s - 1)
local update_block = nil
if e ~= nil then
	update_block = string.sub(content, e + 1, -1)
end

local rules = {}
local updates = {}

for line in string.gmatch(rule_block, "([^\n]+)") do
	local num1, num2 = string.match(line, "(%d+)|(%d+)")
	-- numbers that must come after the given number
	if rules[num1] == nil then
		rules[num1] = {}
		table.insert(rules[num1], num2)
	else
		table.insert(rules[num1], num2)
	end
end

if update_block ~= nil then
	for line in string.gmatch(update_block, "([^\n]+)") do
		local row = {}
		for num in string.gmatch(line, "%d+") do
			table.insert(row, num)
		end
		table.insert(updates, row)
	end
end

local function print_table(t, indent)
	indent = indent or 0
	for k, v in pairs(t) do
		local prefix = string.rep("  ", indent)
		if type(v) == "table" then
			print(prefix .. tostring(k) .. ":")
			print_table(v, indent + 1)
		else
			print(prefix .. tostring(k) .. ": " .. tostring(v))
		end
	end
end

-- print_table(rules, 1)
-- print_table(updates, 1)

local function is_in(t, value)
	if t == nil then
		return false
	end
	for _, v in pairs(t) do
		if v == value then
			return true
		end
	end
	return false
end

local total = 0
for row_num, update in ipairs(updates) do
	print("Row", table.concat(update, ", "))
	local valid = false
	local updated = false
	while valid == false do
		for page = 1, #update - 1 do
			for next_page = page + 1, #update do
				-- print("Checking", update[page], update[next_page])
				valid = is_in(rules[update[page]], update[next_page])
				if valid == false then
					-- invalid order
					print("Invalid row", table.concat(update, ", "))
					-- swap positions until valid order
					local temp = update[page]
					update[page] = update[next_page]
					update[next_page] = temp
					print("Updated row", table.concat(update, ", "))
					updated = true
					goto continue
				end
			end
		end
		::continue::
	end
	if updated == true then
		local middle_index = math.ceil(#update / 2)
		print("Adding", update[middle_index])
		total = total + tonumber(update[middle_index])
	end
end

print("Total", total)
