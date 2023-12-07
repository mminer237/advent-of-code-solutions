#!/usr/bin/env ruby

puts IO.readlines("input.txt")
	.map { |line| line.chomp.split(" ")[1..-1] }
	.transpose.reduce(1) { |result, (time, distance)|
		time = time.to_i
		distance = distance.to_i
		limit = (time / 2).floor - 1
		sum = 0
		if (limit + 1) * 2 === time
			sum += 1
		else
			sum += 2
		end
		limit.downto(1) do |i|
			if i * (time - i) > distance
				sum += 2
			else
				break
			end
		end
		result * sum
	}