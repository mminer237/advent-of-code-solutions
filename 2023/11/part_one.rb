#!/usr/bin/env ruby

map = IO.readlines("input.txt")
	.map { |line| line.chomp.split("") }

empty_rows = Array.new(map.length, true)
empty_columns = Array.new(map.first.length, true)
galaxies = []
map.each_with_index do |row, y|
	row.each_with_index do |cell, x|
		if cell == "#"
			empty_rows[y] = false
			empty_columns[x] = false
			galaxies.push([x, y])
		end
	end
end

galaxies.map! { |galaxy| [
	galaxy[0] + (empty_columns.select.with_index { |empty, x| empty && x < galaxy[0] }).length,
	galaxy[1] + (empty_rows.select.with_index { |empty, y| empty && y < galaxy[1] }).length
]}

sum = 0
galaxies.each_with_index do |galaxy_one, i|
	galaxies[i + 1..-1].each do |galaxy_two|
		sum += (galaxy_one[0] - galaxy_two[0]).abs + (galaxy_one[1] - galaxy_two[1]).abs
	end
end
puts sum
