# frozen_string_literal: true

input = File.readlines('./input.txt', chomp: true)

calibration_values = input.map do |line|
  numbers = line.scan(/\d/)
  (numbers.first + numbers.last).to_i
end

puts "Part 1:"
puts "#{calibration_values.sum}"

digit_map = {
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

digit_matcher = Regexp.new("(?=(#{digit_map.keys.join("|")}|\\d))")

calibration_values_2 = input.map do |line|
  numbers = line.scan(digit_matcher).flatten.map { |digit| digit_map.key?(digit) ? digit_map[digit]: digit }
  (numbers.first + numbers.last).to_i
end

puts "Part 2:"
puts "#{calibration_values_2.sum}"