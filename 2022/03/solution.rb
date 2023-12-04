# frozen_string_literal: true

def get_priority(char)
  if char.between?("a","z")
    char.ord - 96
  elsif char.between?("A","Z")
    char.ord - 38
  else
    0
  end
end

input = File.readlines("input.txt", chomp: true)

def find_common_item(item_list)
  compartment1 = item_list[0, item_list.length / 2].chars
  compartment2 = item_list[(item_list.length / 2), item_list.length / 2].chars
  compartment1 & compartment2
end

common_items = input.map { |l| find_common_item(l).first }

puts("Part 1")
puts(common_items.sum { |i| get_priority(i) })

elf_groups = input.each_slice(3).to_a

priority_sum = elf_groups.sum do |group|
  common_item = group[0].chars & group[1].chars & group[2].chars

  get_priority(common_item.first)
end

puts("Part 2")
puts(priority_sum)