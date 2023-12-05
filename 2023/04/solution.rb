# frozen_string_literal: true

input = File.readlines("./input.txt", chomp: true)

def get_cards(input:)
  input.map do |line|
    numbers = line[line.index(':') + 1, line.length]
    winning_numbers, card_numbers = numbers.split("|").map { |n| n.split(" ").map(&:to_i) }

    {
      winning_numbers: winning_numbers,
      card_numbers: card_numbers
    }
  end
end

def card_score(card)
  matches = card[:winning_numbers] & card[:card_numbers]
  matches.reduce(0) do |acc, curr|
    if acc.zero?
      1
    else
      acc * 2
    end
  end
end

def sum_card_scores(input:)
  get_cards(input: input).sum { |c| card_score(c) }
end

puts "Part 1:"
puts sum_card_scores(input: input)