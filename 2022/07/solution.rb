# frozen_string_literal: true
require 'pry'

input = File.readlines("input.txt", chomp: true)

class FileRecord
  attr_reader :name, :size

  def initialize(name:, size:)
    @name = name
    @size = size
  end

  def to_s()
    "File #{@name}"
  end
end

class DirectoryRecord
  attr_reader :name, :parent
  attr_accessor :children

  def initialize(name:, parent:, children: [])
    @name = name
    @parent = parent
    @children = children
  end

  def size()
    @children.sum do |c|
      c.size
    end
  end

  def child_directories()
    @children.filter { |c| c.instance_of?(DirectoryRecord) }
  end

  def to_s()
    "Directory #{@name} - size: #{size} parent: #{@parent&.name}"
  end
end

class Parser
  attr_reader :root
  def initialize(input)
    @input = input
    @cwd = nil
    @root = DirectoryRecord.new(name: "/", parent: nil)

    parse()
  end

  def parse()
    @input.each do |line|
      if command?(line)
        matcher = /\$ (\w+)\s?(\S*)/
        command, directory = line.match(matcher).captures
        case command
        when "cd"
          @cwd = if directory == ".."
                   @cwd.parent
                 elsif directory == "/"
                   @root
                 else
                   @cwd.children.find { |c| c.name == directory }
                 end
        when "ls"
          next
        end
      elsif file?(line)
        matcher = /(\d+) (\D+)/
        size, name = line.match(matcher).captures
        @cwd.children.push(FileRecord.new(name: name, size: size.to_i))
      elsif directory?(line)
        matcher = /dir (\w+)/
        name = line.match(matcher).captures.first
        @cwd.children.push(DirectoryRecord.new(name: name, parent: @cwd))
      end
    end
  end

  def get_directories_under_100000(starting_directory: @root)
    child_directories = starting_directory.children.filter do |c|
      c.instance_of?(DirectoryRecord)
    end
    
    starting_array = if starting_directory.size <= 100000
                       [starting_directory]
                     else
                       []
                     end
    if child_directories.empty?
      starting_array
    else
      starting_array.concat(child_directories.map { |c| get_directories_under_100000(starting_directory: c) }).flatten
    end
  end

  def get_all_directories(starting_directory: @root)
    if starting_directory.child_directories.empty?
      [starting_directory]
    else
      [starting_directory].concat(starting_directory.child_directories.map do |c|
        get_all_directories(starting_directory: c)
      end).flatten
    end
  end

  def find_directory_to_delete
    total_space = 70000000
    needed_space = 30000000
    unused_space = total_space - @root.size

    candidate_directories = get_all_directories()

    directories_that_will_give_enough_space = candidate_directories.filter do |d|
      needed_space <= (unused_space + d.size)
    end
    directories_that_will_give_enough_space.min do |a, b|
      a.size <=> b.size
    end
  end

  def command?(line)
    line.start_with?("$")
  end

  def file?(line)
    matcher = /(\d+) (\D+)/
    line.match?(matcher)
  end

  def directory?(line)
    line.start_with?("dir")
  end
end

parser = Parser.new(input)


directory_total = (parser.get_directories_under_100000().sum do |d|
  d.size
end)

puts("Part 1")
puts(directory_total)

puts("Part 2")
puts(parser.find_directory_to_delete)