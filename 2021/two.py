def part_one():
    with open('./inputtwo.txt') as f:
        data = f.readlines()
        pairs = [p.split(' ') for p in data]

        horizontal = 0
        vertical = 0

        for command, value in pairs:
            if command == 'forward':
                horizontal += int(value)
            elif command == 'down':
                vertical += int(value)
            else:
                vertical -= int(value)
        print(
            f"horizontal: {horizontal}, vertical: {vertical}, product: {horizontal * vertical}")


part_one()


def part_two():
    with open('./inputtwo.txt') as f:
        data = f.readlines()
        pairs = [p.split(' ') for p in data]

        horizontal = 0
        vertical = 0
        aim = 0

        for command, value in pairs:
            v = int(value)
            if command == 'forward':
                horizontal += v
                vertical += aim * v
            elif command == 'down':
                aim += v
            else:
                aim -= v

        print(
            f"horizontal: {horizontal}, vertical: {vertical}, product: {horizontal * vertical}")


part_two()
