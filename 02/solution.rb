# frozen_string_literal: true

OPPONENT_MOVES = {
  "A" => :rock,
  "B" => :paper,
  "C" => :scisors
}

MY_MOVES = {
  "X" => :rock,
  "Y" => :paper,
  "Z" => :scisors
}

MOVE_POINTS = {
  rock: 1,
  paper: 2,
  scisors: 3
}

OUTCOME_POINTS = {
  lose: 0,
  draw: 3,
  win: 6
}

OUTCOMES = {
  { opponent: :rock, me: :rock } => :draw,
  { opponent: :rock, me: :paper } => :win,
  { opponent: :rock, me: :scisors } => :lose,
  { opponent: :paper, me: :rock } => :lose,
  { opponent: :paper, me: :paper } => :draw,
  { opponent: :paper, me: :scisors } => :win,
  { opponent: :scisors, me: :rock } => :win,
  { opponent: :scisors, me: :paper } => :lose,
  { opponent: :scisors, me: :scisors } => :draw
}

input = File.readlines("input.txt", chomp: true)

scores = input.map do |line|
  m = line.match(/(\w)\s(\w)/)
  opponent_move = OPPONENT_MOVES[m[1]]
  my_move = MY_MOVES[m[2]]

  outcome = OUTCOMES[{ opponent: opponent_move, me: my_move }]

  MOVE_POINTS[my_move] + OUTCOME_POINTS[outcome]
end

puts "Part 1 final score"
puts(scores.sum)

DESIRED_OUTCOMES = {
  "X" => :lose,
  "Y" => :draw,
  "Z" => :win
}

round_choices_by_outcome = OUTCOMES.keys.group_by do |k|
  OUTCOMES[k]
end

scores = input.map do |line|
  m = line.match(/(\w)\s(\w)/)
  opponent_move = OPPONENT_MOVES[m[1]]
  desired_outcome = DESIRED_OUTCOMES[m[2]]

  correct_round = round_choices_by_outcome[desired_outcome].find do |moves|
    moves[:opponent] == opponent_move
  end

  MOVE_POINTS[correct_round[:me]] + OUTCOME_POINTS[desired_outcome]
end

puts "Part 2 final score"
puts(scores.sum)