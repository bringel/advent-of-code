def part_one():
    with open('inputthree.txt') as f:
        data = f.readlines()

        gamma = []
        epsilon = []
        # 12 digits in each number
        for i in range(12):
            ones = [n for n in data if n[i] == '1']
            zeros = [n for n in data if n[i] == '0']

            one_count = len(ones)
            zero_count = len(zeros)

            # gamma gets the most commonly occuring bit value, epsilon gets the least
            if one_count > zero_count:
                gamma.append('1')
                epsilon.append('0')
            else:
                gamma.append('0')
                epsilon.append('1')
        gamma_value = int("".join(gamma), base=2)
        epsilon_value = int("".join(epsilon), base=2)
        print(
            f"gamma: {gamma_value}, epsilon: {epsilon_value}, power: {gamma_value * epsilon_value}")


part_one()


def part_two():
    with open('inputthree.txt') as f:
        data = f.readlines()

        results = list(data)
        bit = 0
        while len(results) > 1:
            ones = [n for n in results if n[bit] == '1']
            zeros = [n for n in results if n[bit] == '0']

            if len(ones) >= len(zeros):
                results = ones
            else:
                results = zeros
            bit += 1
        oxygen = int(results[0], base=2)

        results = list(data)
        bit = 0
        while len(results) > 1:
            ones = [n for n in results if n[bit] == '1']
            zeros = [n for n in results if n[bit] == '0']

            if len(ones) < len(zeros):
                results = ones
            else:
                results = zeros
            bit += 1
        co2 = int(results[0], base=2)

        print(f"oxygen: {oxygen}, co2: {co2}, life support: {oxygen * co2}")


part_two()
