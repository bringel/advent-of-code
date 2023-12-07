# frozen_string_literal: true

input = File.readlines("./input.txt", chomp: true)


def parse_map(input:)
  mapping_matcher = %r{(?<dest_start>\d+) (?<source_start>\d+) (?<length>\d+)}

  parsed_map = input.map do |line|
    match = mapping_matcher.match(line).named_captures

    destination_range = (match["dest_start"].to_i)...(match["dest_start"].to_i + match["length"].to_i)
    source_range = (match["source_start"].to_i)...(match["source_start"].to_i + match["length"].to_i)

    source_range.zip(destination_range).to_h
  end.reduce(&:merge)
  
  parsed_map.default_proc = proc { |h, k| k }
  
  parsed_map
end

def parse_mappings(input:)
mapping_name_matcher = %r{([a-zA-Z-]+) map:}

  slices = input.slice_after("").to_h do |line|
    key, *value = line.reject(&:empty?)
    name = key.match(mapping_name_matcher).captures.first.gsub("-", "_")
    [name, value]
  end

  slices.transform_values! do |v|
    parse_map(input: v)
  end
end

def get_seed_location(seed:, mappings:)
  # seed, soil, fertilizer, water, light, temperature, humidity, location
  soil = mappings["seed_to_soil"][seed]
  fertilizer = mappings["soil_to_fertilizer"][soil]
  water = mappings["fertilizer_to_water"][fertilizer]
  light = mappings["water_to_light"][water]
  temperature = mappings["light_to_temperature"][light]
  humidity = mappings["temperature_to_humidity"][temperature]
  mappings["humidity_to_location"][humidity]
end

def get_lowest_seed_location(input:)
  seeds = input.shift
  input.shift
  parsed_seeds = seeds.scan(/\d+/).map(&:to_i)
  mappings = parse_mappings(input: input)

  parsed_seeds.map { |s| get_seed_location(seed: s, mappings: mappings) }.min
end

puts "Part 1:"
puts get_lowest_seed_location(input: input)