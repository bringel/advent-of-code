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
  { opponent: :paper, me: :rock} => :lose,
  { opponent: :paper, me: :paper } => :draw,
  { opponent: :paper , me: :scisors } => :win,
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
