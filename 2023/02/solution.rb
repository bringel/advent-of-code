# frozen_string_literal: true

input = File.readlines('./input.txt', chomp: true)

def sum_possible_game_ids(input:, red_count:, green_count:, blue_count:)
  games = input.map { |l| parse_game_line(l) }
  max_cubes = {
    red: red_count,
    green: green_count,
    blue: blue_count
  }
  get_possible_games(games: games, max_cubes: max_cubes).sum do |game|
    game[:id].to_i
  end
end

def get_possible_games(games:, max_cubes:)
  games.filter do |game|
    game_possible?(game: game, max_cubes: max_cubes)
  end
end

def game_possible?(game:, max_cubes:)
  game[:sets].each do |set|
    red_over = set["red"] ? set["red"].to_i > max_cubes[:red] : false
    green_over = set["green"] ? set["green"].to_i > max_cubes[:green] : false
    blue_over = set["blue"] ? set["blue"].to_i > max_cubes[:blue] : false

    if red_over || green_over || blue_over
      return false
    end
  end
  return true
end

def parse_game_line(line)
  game_matcher = %r{Game (\d+): (.*)}
  match = line.match(game_matcher)
  id, game_input = match.captures

  set_parser = %r{(?:(?=(?<blue>\d+) blue)|(?=(?<green>\d+) green)|(?=(?<red>\d+) red))}

  parsed_sets = game_input.split(';').map do |set|
    values = set.split(',')
    value_matches = values.map { |v| v.match(set_parser).named_captures }
    value_matches.reduce({}) do |acc, current|
      acc.merge(current.compact)
    end
  end

  {
    id: id,
    sets: parsed_sets
  }
end

# ------
def get_min_cubes(game:)
  {
    red: game[:sets].max { |a,b| a["red"].to_i <=> b["red"].to_i }.fetch("red"),
    green: game[:sets].max { |a,b| a["green"].to_i <=> b["green"].to_i }.fetch("green"),
    blue: game[:sets].max { |a,b| a["blue"].to_i <=> b["blue"].to_i }.fetch("blue")
  }
end

def power(set:)
  set.values.map(&:to_i).reduce(:*)
end

def sum_of_game_powers(input:)
  games = input.map { |l| parse_game_line(l) }
  games.map { |g| get_min_cubes(game: g) }.sum { |s| power(set: s) }
end

puts "Part 1:"
puts sum_possible_game_ids(input: input, red_count: 12, green_count: 13, blue_count: 14)

puts "Part 2:"
puts sum_of_game_powers(input: input)