# frozen_string_literal: true

input = File.readlines("input.txt", chomp: true)

trees = input.map { |l| l.split("") }

def find_visible_trees(grid)
  visible = []
  grid.each_with_index do |row, row_index|
    row.each_with_index do |tree, column_index|
      if row_index == 0 || row_index == grid.length - 1
        visible << { row: row_index, column: column_index, height: tree}
      elsif column_index == 0 || column_index == row.length - 1
        visible << { row: row_index, column: column_index, height: tree}
      else
        row_before = row[..column_index - 1]
        row_after = row[(column_index + 1)..]
        column_trees = grid.flat_map { |r| r[column_index] }
        column_before = column_trees[..row_index - 1]
        column_after = column_trees[(row_index + 1)..]
        if tree > row_before.max || tree > row_after.max || tree > column_before.max || tree > column_after.max
          visible << { row: row_index, column: column_index, height: tree}
        end
      end
    end
  end

  visible
end

puts("Part 1")
puts(find_visible_trees(trees).length)