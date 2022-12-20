# frozen_string_literal: true

input = File.readlines("input.txt", chomp: true)

class CargoShip
  attr_reader :input, :stacks, :instructions

  def initialize(input)
    @input = input
    @stacks = parse_stacks(input)
    @instructions = parse_instructions(input)
  end

  def part1()
    @instructions.each do |i|
      handle_instruction(i)
    end

    @stacks.map(&:last).join("")
  end

  def parse_stacks(lines)
    matcher = /(?:\s(\s)\s|\[(\w)\])\s?/

    stack_lines = lines.filter_map do |l|
      l.scan(matcher).map(&:compact).flatten if l.match?(matcher)
    end
    stacks = Array.new(stack_lines.first.length) { [] }
    stack_lines.each do |l|
      l.each_with_index do |s, i|
        stacks[i].unshift(s) unless s == ' '
      end
    end

    stacks
  end

  def parse_instructions(lines)
    matcher = /move (\d+) from (\d+) to (\d+)/

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

  def handle_instruction(instruction)
    starting_stack = @stacks[instruction[:starting_stack] - 1]
    ending_stack = @stacks[instruction[:ending_stack] - 1]

    instruction[:total_to_move].times do
      item = starting_stack.pop()
      ending_stack.push(item)
    end
  end
end

ship = CargoShip.new(input)
puts("Part 1")
puts(ship.part1())