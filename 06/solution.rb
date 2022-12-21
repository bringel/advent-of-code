# frozen_string_literal: true

input = File.read("input.txt")

def all_unique?(str)
  counts = Hash.new { 0 }

  str.chars.each do |c|
    counts[c] += 1
  end

  counts.values.none? { |v| v > 1 }
end

def start_of_packet?(str)
  !str.nil? && str.length >= 4 && all_unique?(str)
end

def start_of_message?(str)
  !str.nil? && str.length >= 14 && all_unique?(str)
end

def read_until_start_of_packet(input)
  buffer = []

  input.chars.each do |c|
    buffer << c
    if start_of_packet?(buffer.join().slice(-4, 4))
      return buffer
    end
  end
end

def read_until_start_of_message(input)
  buffer = []

  input.chars.each do |c|
    buffer << c
    if start_of_message?(buffer.join.slice(-14, 14))
      return buffer
    end
  end
end

puts("Part 1")
puts(read_until_start_of_packet(input).length)

puts("Part 2")
puts(read_until_start_of_message(input).length)