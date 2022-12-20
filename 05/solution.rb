# frozen_string_literal: true

input = File.readlines("input.txt", chomp: true)

def parse_stacks(lines)
  matcher = /(?:\s(\s)\s|\[(\w)\])\s?/

  stack_lines = lines.filter_map do |l|
    l.scan(matcher).map(&:compact).flatten if l.match?(matcher)
  end
  stacks = Array.new(stack_lines.first.length) { [] }
  stack_lines.each do |l|
    l.each_with_index do |s, i|
      stacks[i].unshift(s) unless s.strip.empty?
    end
  end
end

def parse_instructions(lines)
  matcher = /move (\d) from (\d) to (\d)/

  lines.filter_map do |l|
    if l.match?(matcher)
      m = l.match(matcher)
      {
        total_to_move: m[1].to_i,
        starting_stack: m[2].to_i,
        ending_stack: m[3].to_i
      }
    end
  end
end

