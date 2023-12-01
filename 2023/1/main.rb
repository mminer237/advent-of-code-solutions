#!/usr/bin/env ruby

def find_numbers(input)
	if
		input.match(/(\d).*(\d)/)
		$1 + $2
	else
		input.match(/(\d)/)
		$1 + $1
	end
end

sum = 0
for line in STDIN
	n = find_numbers(line)
	puts n
	sum += n.to_i
end
puts "---"
puts sum
