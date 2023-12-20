sum = 0
pattern = Array(Array(Char)).new
File.each_line("input.txt") do |line|
	if (line.size > 1)
		pattern << line.chars
	else
		sum += test_pattern(pattern)
		pattern.clear
	end
end
sum += test_pattern(pattern)
puts sum

def test_pattern(pattern : Array(Array(Char))) : Int32
	valid_columns = Array(Int32).new(pattern[0].size, 2)
	pattern.each_with_index do |row, y|
		rows_to_check = [y + 1, pattern.size - y - 1].min
		valid_row = rows_to_check > 0 ? 2 : 0
		row.each_with_index do |char, x|
			if (valid_row > 0)
				(1..rows_to_check).each do |i|
					if (pattern[y + i][x] != pattern[y + 1 - i][x])
						valid_row -= 1
						break
					end
				end
			end

			cols_to_check = [x + 1, pattern[0].size - x - 1].min
			if (cols_to_check == 0)
				valid_columns[x] = 0
			end
			if (valid_columns[x] > 0)
				(1..cols_to_check).each do |i|
					if (pattern[y][x + i] != pattern[y][x + 1 - i])
						valid_columns[x] -= 1
						break
					end
				end
			end
		end
		if (valid_row == 1)
			return (y + 1) * 100
		end
	end
	valid_column = valid_columns.index { |x| x == 1 }
	if (valid_column)
		return (valid_column + 1)
	end
	return 0
end
