class Space():

    def __init__(self, value):
        self.value = value
        self.marked = False


class Board():

    def __init__(self, rows):
        self.rows = []
        for row in rows:
            spaces = [Space(n) for n in row.split()]
            self.rows.append(spaces)

    def has_won(self):
        # checking for full columns or full rows, no diagonals
        winning_row = False
        winning_column = False

        for row in self.rows:
            winning_row = all([s.marked for s in row])
            if winning_row:
                break
        for col in range(5):
            column_values = [row[col] for row in self.rows]
            winning_column = all([s.marked for s in column_values])
            if winning_column:
                break
        return winning_row or winning_column

    def calculate_score(self, winning_number):
        unmarked_numbers = []
        for row in self.rows:
            for col in row:
                if not col.marked:
                    unmarked_numbers.append(int(col.value))

        return int(winning_number) * sum(unmarked_numbers)

    def __repr__(self):
        s = ''
        for row in self.rows:
            r = ''
            for col in row:
                if col.marked:
                    r += f"{col.value}*".ljust(4)
                else:
                    r += col.value.ljust(4)
            s += f"{r}\n"
        return s


def part_one():
    with open('inputfour.txt') as f:
        drawn_numbers = f.readline().split(',')

        board_lines = [l.strip() for l in f.readlines() if l != '\n']

        boards = []

        slices = range(0, len(board_lines), 5)

        for slice in slices:
            rows = board_lines[slice:slice+5]
            boards.append(Board(rows))

        for num in drawn_numbers:
            for board in boards:
                for row in board.rows:
                    for column in row:
                        if column.value == num:
                            column.marked = True
                if board.has_won():
                    print(board)
                    return board.calculate_score(num)


print(part_one())


def part_two():
    with open('inputfour.txt') as f:
        drawn_numbers = f.readline().split(',')

        board_lines = [l.strip() for l in f.readlines() if l != '\n']

        boards = []

        slices = range(0, len(board_lines), 5)

        for slice in slices:
            rows = board_lines[slice:slice+5]
            boards.append(Board(rows))

        winning_boards = []
        for num in drawn_numbers:
            for board_index, board in enumerate(boards):
                for row in board.rows:
                    for column in row:
                        if column.value == num:
                            column.marked = True
                if board.has_won() and board_index not in [b["index"] for b in winning_boards]:
                    winning_boards.append(
                        {"index": board_index, "winning_number": num})

                if all([board.has_won() for board in boards]):
                    break

        last_winner = winning_boards[-1]

        print(boards[last_winner["index"]])
        print(last_winner["winning_number"])
        return boards[last_winner["index"]].calculate_score(last_winner["winning_number"])


print(part_two())
