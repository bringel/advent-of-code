# frozen_string_literal: true

input = File.readlines('./input.txt', chomp: true)

def sum_possible_game_ids(input:, red_count:, green_count:, blue_count:)
  get_possible_games(input: input, red_count: red_count, green_count: green_count, blue_count: blue_count).sum do |game_line|
    id_matcher = %r{Game (\d+):.*}
    id_matcher.match(game_line).captures.first.to_i
  end
end

def get_possible_games(input:, red_count:, green_count:, blue_count:)
  game_matcher = %r{Game \d+: (.*)}

  input.filter do |line|
    game_input = line.match(game_matcher).captures.first

    game_possible?(game: game_input, red_count: red_count, green_count: green_count, blue_count: blue_count)
  end
end

def game_possible?(game:, red_count:, green_count:, blue_count:)
  sets = game.split(";")

  matcher = %r{(?:(?=(?<blue>\d+) blue)|(?=(?<green>\d+) green)|(?=(?<red>\d+) red))}

  sets.each do |set|
    values = set.split(",")
    value_matches = values.map { |v| v.match(matcher).named_captures }
  
    value_matches.each do |set_match|
      red_over = set_match["red"] ? set_match["red"].to_i > red_count : false
      green_over = set_match["green"] ? set_match["green"].to_i > green_count : false
      blue_over = set_match["blue"] ? set_match["blue"].to_i > blue_count : false

      if red_over || green_over || blue_over
        return false
      end
    end
  end
  return true
end

puts "Part 1:"
puts sum_possible_game_ids(input: input, red_count: 12, green_count: 13, blue_count: 14)