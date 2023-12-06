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

# def process_scratch_cards(cards:)
#   processed_cards = []

#   while cards.length > 0
#     card_number = cards.first[:card_number]
#     cards_to_remove = cards.count { |c| c[:card_number] == card_number }
#     current_cards = cards.shift(cards_to_remove)
#     copies = current_cards.flat_map do |c|
#       matches = c[:winning_numbers] & c[:card_numbers]
#       match_copies = (1..matches.length).map do |index|
#         cards.find { |original_card| original_card[:card_number] == (card_number + index) }
#       end
#     end
#     processed_cards.concat(current_cards)
#     cards.unshift(*copies).sort! { |a,b| a[:card_number] <=> b[:card_number] }
#   end

#   processed_cards
# end

# def count_processed_cards(input:)
#   process_scratch_cards(cards: get_cards(input: input)).length
# end

def process_scratch_cards(cards:)
  copy_map = Hash.new(1)
  copy_map[1] = 1

  cards.each do |c|
    card_number = c[:card_number]
    matches = c[:winning_numbers] & c[:card_numbers]
    next if matches.length.zero?
    
    copies_to_add = ((card_number + 1)..(card_number + matches.length))
    current_card_copies = copy_map[card_number]

    copies_to_add.each do |copy_card_number|
      copy_map[copy_card_number] = copy_map[copy_card_number] + current_card_copies
    end
  end

  copy_map
end

def count_processed_cards(input:)
  cards = get_cards(input:input)
  processed_cards = process_scratch_cards(cards: cards)
  card_copies = (1..cards.length).map { |i| processed_cards[i] }
  card_copies.sum
end

puts "Part 2:"
puts count_processed_cards(input: input)
