
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
    with open('inputone.txt') as f:
        data = [int(l) for l in f.readlines()]

        windows = []
        for i in range(0, len(data)):
            if i < len(data) - 2:
                windows.append(data[i:i+3])

        sums = [sum(w) for w in windows]

        increased = 0
        prev = sums.pop(0)
        while len(sums) > 0:
            current = sums.pop(0)
            if current > prev:
                increased += 1
            prev = current
        print(increased)


part_two()
