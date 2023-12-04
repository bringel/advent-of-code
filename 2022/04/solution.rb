# frozen_string_literal: true

input = File.readlines("input.txt", chomp: true)

ranges = input.map do |l|
  one, two = l.split(",")
  one_sections = one.split("-").map(&:to_i)
  two_sections = two.split("-").map(&:to_i)

  [Range.new(*one_sections), Range.new(*two_sections)]
end

overlapping = ranges.count do |r|
  r[0].cover?(r[1]) || r[1].cover?(r[0])
end

puts("Part 1")
puts(overlapping)

any_overlaps = ranges.count do |r|
  r1, r2 = r

  r1.include?(r2.begin) || r2.include?(r1.begin)

end

puts("Part 2")
puts(any_overlaps)