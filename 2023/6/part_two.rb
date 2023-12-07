#!/usr/bin/env ruby

(time, distance) = IO.readlines("input.txt")
	.map { |line| line.chomp.split(" ")[1..-1].join() }.map(&:to_i)
for i in 1..time
	if i * (time - i) > distance
		puts time - i * 2 + time % 2
		break
	end
end
