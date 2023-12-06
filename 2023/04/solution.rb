# frozen_string_literal: true

input = File.readlines("./input.txt", chomp: true)

def get_cards(input:)
  input.map.with_index do |line, index|
    numbers = line[line.index(':') + 1, line.length]
    winning_numbers, card_numbers = numbers.split("|").map { |n| n.split(" ").map(&:to_i) }

    {
      card_number: index + 1,
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

#---

def process_scratch_cards(cards:)
  processed_cards = []

  while cards.length > 0
    card_number = cards.first[:card_number]
    cards_to_remove = cards.count { |c| c[:card_number] == card_number }
    current_cards = cards.shift(cards_to_remove)
    copies = current_cards.flat_map do |c|
      matches = c[:winning_numbers] & c[:card_numbers]
      match_copies = (1..matches.length).map do |index|
        cards.find { |original_card| original_card[:card_number] == (card_number + index) }
      end
    end
    processed_cards.concat(current_cards)
    cards.unshift(*copies).sort! { |a,b| a[:card_number] <=> b[:card_number] }
  end

  processed_cards
end

def count_processed_cards(input:)
  process_scratch_cards(cards: get_cards(input: input)).length
end

puts "Part 2:"
puts count_processed_cards(input: input)
