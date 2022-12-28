# frozen_string_literal: true

input = File.readlines("input.txt", chomp: true)

trees = input.map { |l| l.split("") }

def get_surrounding_trees(row_index:, column_index:, grid:)
  row = grid[row_index]

  row_before = row[0...column_index]
  row_after = row[(column_index + 1)..]
  column_trees = grid.flat_map { |r| r[column_index] }
  column_before = column_trees[0...row_index]
  column_after = column_trees[(row_index + 1)..]

  [row_before, row_after, column_before, column_after]
end

def find_visible_trees(grid)
  visible = []
  grid.each_with_index do |row, row_index|
    row.each_with_index do |tree, column_index|
      if row_index == 0 || row_index == grid.length - 1
        visible << { row: row_index, column: column_index, height: tree}
      elsif column_index == 0 || column_index == row.length - 1
        visible << { row: row_index, column: column_index, height: tree}
      else
        row_before, row_after, column_before, column_after = get_surrounding_trees(row_index: row_index, column_index: column_index, grid: grid)
        if tree > row_before.max || tree > row_after.max || tree > column_before.max || tree > column_after.max
          visible << { row: row_index, column: column_index, height: tree}
        end
      end
    end
  end

  visible
end

def get_viewing_distance(height:, other_trees:)
  return 0 if other_trees.length.zero?

  taller_index = other_trees.index { |t| t >= height }
  return other_trees.length if taller_index.nil?

  taller_index + 1
end

def get_best_senic_score(grid)
  processed = grid.each_with_index.map do |row, row_index|
    row.each_with_index.map do |tree, column_index|
      row_before, row_after, column_before, column_after = get_surrounding_trees(row_index: row_index, column_index: column_index, grid: grid)

      left_distance = get_viewing_distance(height: tree, other_trees: row_before.reverse)
      right_distance = get_viewing_distance(height: tree, other_trees: row_after)
      up_distance = get_viewing_distance(height: tree, other_trees: column_before.reverse)
      down_distance = get_viewing_distance(height: tree, other_trees: column_after)

      { 
        row: row_index, 
        column: column_index, 
        distance: [up_distance, right_distance, down_distance, left_distance], 
        score: [up_distance, down_distance, left_distance, right_distance].reduce(:*)
      }
    end
  end

  processed.flatten.max do |a,b|
    a[:score] <=> b[:score]
  end
end

puts("Part 1")
puts(find_visible_trees(trees).length)

puts("Part 2")
puts(get_best_senic_score(trees)[:score])