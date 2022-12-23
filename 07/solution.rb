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

  def to_s()
    "Directory #{@name} - parent: #{@parent&.name} children: #{@children.map { |c| c.to_s } }"
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
# directories = []
# parser.get_directories_under_100000(directory: parser.root, large_directories: directories)
# pp directories
pp (parser.get_directories_under_100000().sum do |d|
  d.size
end)