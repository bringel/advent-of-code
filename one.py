
def part_one():
    with open('inputone.txt') as f:
        data = f.readlines()
        prev = int(data.pop(0).strip())

        increased = 0
        while len(data) > 0:
            current = int(data.pop(0).strip())
            if current > prev:
                increased += 1
            prev = current
        print(increased)


def part_two():
