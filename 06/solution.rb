# frozen_string_literal: true

input = File.read("input.txt")

def is_start_of_packet(str)
  return false if str.nil? || str.length < 4
  
  counts = Hash.new { 0 }

  str.chars.each do |c|
    counts[c] += 1
  end

  counts.values.none? { |v| v > 1 }
end

def read_until_start_of_packet(input)
  buffer = []

  input.chars.each do |c|
    buffer << c
    if is_start_of_packet(buffer.join().slice(-4, 4))
      return buffer
    end
  end
end

puts("Part 1")
puts(read_until_start_of_packet(input).length)