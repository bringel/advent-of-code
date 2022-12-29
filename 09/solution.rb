# frozen_string_literal: true

input = File.readlines("input.txt", chomp: true)
# input = [
# "R 4",
# "U 4",
# "L 3",
# "D 1",
# "R 4",
# "D 1",
# "L 5",
# "R 2",
# ]

Position = Struct.new("Position", :x, :y)

class Position
  def is_touching?(other_position)
    return true if self == other_position

    if x == other_position.x
      (y - other_position.y).abs == 1
    elsif y == other_position.y
      (x - other_position.x).abs == 1
    else
      (x - other_position.x).abs == 1 && (y - other_position.y).abs == 1
    end
  end
end

class Rope
  attr_reader :head, :tail, :position_history

  def initialize
    @head = Position.new(0, 0)
    @tail = Position.new(0, 0)
    @position_history = []
  end

  def head_position_history
    @position_history.map { |p| p[:head] }
  end

  def tail_position_history
    @position_history.map { |p| p[:tail] }
  end

  def move_up
    @position_history << { head: @head, tail: @tail }
    @head = Position.new(@head.x, @head.y + 1)

    @tail = Position.new(@head.x, @tail.y + 1) unless @head.is_touching?(@tail) 
  end

  def move_down
    @position_history << { head: @head, tail: @tail }
    @head = Position.new(@head.x, @head.y - 1)

    @tail = Position.new(@head.x, @tail.y - 1) unless @head.is_touching?(@tail) 
  end

  def move_left
    @position_history << { head: @head, tail: @tail }
    @head = Position.new(@head.x - 1, @head.y)

    @tail = Position.new(@tail.x - 1, @head.y) unless @head.is_touching?(@tail)
  end

  def move_right
    @position_history << { head: @head, tail: @tail }
    @head = Position.new(@head.x + 1, @head.y)

    @tail = Position.new(@tail.x + 1, @head.y) unless @head.is_touching?(@tail)
  end

  def must_move_tail_diagonally
    @head.x != @tail.x && @head.y != @tail.y
  end
end

moves = input.map do |line|
  direction, count = line.split(" ")

  { direction: direction, count: count.to_i }
end

rope = Rope.new

moves.each do |move|
  move[:count].times do 
    case move[:direction]
    when "U"
      rope.move_up()
    when "D"
      rope.move_down()
    when "L"
      rope.move_left()
    when "R"
      rope.move_right()
    end
  end
end

puts("Part 1")
puts(rope.tail_position_history.uniq.length)