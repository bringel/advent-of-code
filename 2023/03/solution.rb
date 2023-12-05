# frozen_string_literal: true

input = File.readlines("./input.txt", chomp: true)

def gather_part_numbers(input:, matcher: %r{(\d+)})
  parts = []

  input.each_with_index do |line, index|
    line_matches = []

    # scan will only return the matched string, by passing to a block and using last_match, we can get the
    # MatchData object for each
    line.scan(matcher) { line_matches << Regexp.last_match }

    line_matches.each do |match|
      start_position, end_position = match.offset(0)
      parts << { text: match[0], line: index, start_position: start_position, end_position: end_position - 1  }
    end
  end

  parts
end


def get_adjacent_indicies(part:, max_row:, max_col:)
  x_start = (part[:start_position] - 1).clamp(0, max_col)
  x_end = (part[:end_position] + 1).clamp(0, max_col)
  y_start = (part[:line] - 1).clamp(0, max_row)
  y_end = (part[:line] + 1).clamp(0, max_row)

  x_range = x_start..x_end
  y_range = y_start..y_end

  y_range.flat_map do |y|
    x_range.map do |x|
      { x: x, y: y }
    end
  end
end

def is_real_part_number?(part, input:)
  symbol_matcher = %r{[^\.0-9\s]}
  indicies = get_adjacent_indicies(part: part, max_row: input.length - 1, max_col: input.first.length - 1)

  indicies.each do |index|
    c = input[index[:y]][index[:x]]
    if c.match?(symbol_matcher)
      return true
    end
  end

  return false
end

def sum_part_numbers(input:)
  prospective_parts = gather_part_numbers(input: input)
  part_numbers = prospective_parts.filter { |p| is_real_part_number?(p, input: input) }

  part_numbers.sum { |p| p[:text].to_i }
end

puts "Part 1:"
puts sum_part_numbers(input: input)

def fetch_gears(input:)
  prospective_parts = gather_part_numbers(input: input)
  part_numbers = prospective_parts.filter { |p| is_real_part_number?(p, input: input) }

  all_stars = gather_part_numbers(input: input, matcher: %r{(\*)})

  all_stars.filter_map do |star_part|
    adjacent_indicies = get_adjacent_indicies(part: star_part, max_row: input.length - 1, max_col: input.first.length - 1)
    adjacent_parts = part_numbers.filter do |part|
      part_range = part[:start_position]..part[:end_position]
      part_indicies = part_range.map do |x|
        { x: x, y: part[:line]}
      end

      part_indicies.any? { |index| adjacent_indicies.include?(index) }
    end
    if adjacent_parts.length == 2
      { star_part: star_part, adjacent_parts: adjacent_parts}
    end
  end
end

def get_gear_ratios(input:)
  gears = fetch_gears(input: input)

  gears.map do |gear|
    part_numbers = gear[:adjacent_parts].map { |p| p[:text].to_i }
    part_numbers.reduce(:*)
  end
end

def sum_gear_ratios(input:)
  get_gear_ratios(input: input).sum
end

puts "Part 2:"
puts sum_gear_ratios(input: input)