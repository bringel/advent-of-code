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

# input = [
# "R 5",
# "U 8",
# "L 8",
# "D 3",
# "R 17",
# "D 10",
# "L 25",
# "U 20",
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

  def initialize(additional_knots: 1)
    @head = Position.new(0, 0)
    @additional_knots = Array.new(additional_knots) { Position.new(0, 0) }
    @tail = @additional_knots.last
    @position_history = []
  end

  def head_position_history
    @position_history.map { |p| p[:head] }
  end

  def tail_position_history
    @position_history.map { |p| p[:tail] }
  end

  def move_up
    @position_history << current_position_hash
    # @head = Position.new(@head.x, @head.y + 1)

    # @tail = Position.new(@head.x, @tail.y + 1) unless @head.is_touching?(@tail) 

    make_pairs.each_with_index do |(a, b), index|
      a.y += 1 if index.zero?

      unless a.is_touching?(b)
        # if must_move_diagonally(a, b)
          b.x += get_diagonal_x(a, b)
          b.y += get_diagonal_y(a, b)
        # else
        #   b.y += 1
        # end
      end
    end
  end

  def move_down
    @position_history << current_position_hash
    # @head = Position.new(@head.x, @head.y - 1)

    # @tail = Position.new(@head.x, @tail.y - 1) unless @head.is_touching?(@tail) 
    make_pairs.each_with_index do |(a, b), index|
      a.y -= 1 if index.zero?

      unless a.is_touching?(b)
        # if must_move_diagonally(a, b)
          b.x += get_diagonal_x(a, b)
          b.y += get_diagonal_y(a, b)
        # else
        #   b.y -= 1
        # end
      end
    end
  end

  def move_left
    @position_history << current_position_hash
    # @head = Position.new(@head.x - 1, @head.y)

    # @tail = Position.new(@tail.x - 1, @head.y) unless @head.is_touching?(@tail)
    make_pairs.each_with_index do |(a, b), index|
      a.x -= 1 if index.zero?

      unless a.is_touching?(b)
        # if must_move_diagonally(a, b)
          b.x += get_diagonal_x(a, b)
          b.y += get_diagonal_y(a, b)
        # else
        #   b.x -= 1
        # end
      end
    end
  end

  def move_right
    @position_history << current_position_hash
    # @head = Position.new(@head.x + 1, @head.y)

    # @tail = Position.new(@tail.x + 1, @head.y) unless @head.is_touching?(@tail)
    make_pairs.each_with_index do |(a, b), index|
      # puts(index)
      # pp("a: #{a} b: #{b}")
      a.x += 1 if index.zero?
      # pp("a: #{a} b: #{b}")
      unless a.is_touching?(b)
        # if must_move_diagonally(a, b)
          b.x += get_diagonal_x(a, b)
          b.y += get_diagonal_y(a, b)
        # else
        #   b.x += 1
        # end
      end
      # pp("a: #{a} b: #{b}")
    end
  end

  def must_move_diagonally(a, b)
    a.x != b.x && a.y != b.y
  end

  def current_position_hash
    { head: @head.clone, additional_knots: @additional_knots.clone.map(&:clone), tail: @tail.clone }
  end

  def make_pairs
    pairs = []

    @additional_knots.each_with_index do |p, index|
      if index.zero?
        pairs << [@head, p]
      else
        pairs << [@additional_knots[index - 1], p]
      end
    end
    pairs
  end

  def get_diagonal_x(a, b)
    a.x <=> b.x
    # if a.x == b.x
    #   0
    # elsif a.x < b.x
    #   -1
    # else
    #   1
    # end
  end

  def get_diagonal_y(a, b)
    a.y <=> b.y
  #   if a.y == b.y
  #     0
  #   elsif a.y < b.y
  #     -1
  #   else
  #     1
  #   end
  end
end

def go(rope, input)
  moves = input.map do |line|
    direction, count = line.split(" ")

    { direction: direction, count: count.to_i }
  end
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
end


puts("Part 1")
rope = Rope.new
go(rope, input)
puts(rope.tail_position_history.uniq.length)

puts("Part 2")
longer_rope = Rope.new(additional_knots: 9)

go(longer_rope, input)
history_length = longer_rope.tail_position_history.uniq.length
if longer_rope.tail == longer_rope.tail_position_history.uniq.last
  puts(history_length)
else
  puts(history_length + 1)
end