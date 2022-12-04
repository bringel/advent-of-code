# frozen_string_literal: true

input = File.readlines("input.txt", chomp: true).each_with_object([[]]) do |line, acc|
  if line.empty?
    acc << []
  else
    acc.last << line.to_i
  end
end

def part_two
  totals = input.map { |arr| arr.sum }

  puts totals.max(3).sum
end

totals = input.map { |arr| arr.sum }
puts "Part 1"
puts totals.max

puts "Part 2"
puts totals.max(3).sum