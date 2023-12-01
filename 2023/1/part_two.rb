#!/usr/bin/env ruby

def find_numbers(input)
	number_names = {
		"one" => "1",
		"two" => "2",
		"three" => "3",
		"four" => "4",
		"five" => "5",
		"six" => "6",
		"seven" => "7",
		"eight" => "8",
		"nine" => "9"
	}
	number_names_regex = Regexp.new(number_names.keys().join("|"))
	"^\\D*?(\\d|" + number_names.keys().join("|") + ")"
	input.match(Regexp.new("^\\D*?(\\d|" + number_names.keys().join("|") + ")"))
	first_number_input = $1 ? $1.sub(number_names_regex, number_names) : input
	first_number = first_number_input.match(/\d/)[0]

	last_name_start = input.rindex(number_names_regex)
	if last_name_start
		input = input[last_name_start..-1].sub(number_names_regex, number_names)
	end
	second_number = input.match(/(\d)\D*?$/)[1]

	if second_number
		first_number + second_number
	else
		first_number + first_number
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
