def has_won(board):
    # checking for full columns or full rows, no diagonals
    winning_row = False
    winning_column = False

    for row in board:
        winning_row = all([n["marked"] for n in row])
        if winning_row:
            break
    for col in range(len(board[0])):
        column_values = [row[col] for row in board]
        winning_column = all([n["marked"] for n in column_values])
        if winning_column:
            break
    return winning_row or winning_column


def calculate_score(board, winning_number):
    unmarked_numbers = []
    for row in board:
        for col in row:
            if not col["marked"]:
                unmarked_numbers.append(int(col["number"]))
    print(unmarked_numbers)
    print(sum(unmarked_numbers))
    print(winning_number)
    return int(winning_number) * sum(unmarked_numbers)


def print_board(board):
    for row in board:
        values = []

        for col in row:
            if col["marked"]:
                values.append(f"{col['number']}*")
            else:
                values.append(col["number"])
        print(values)


def part_one():
    with open('inputfour.txt') as f:
        drawn_numbers = f.readline().split(',')

        board_lines = [l.strip() for l in f.readlines() if l != '\n']

        board_data = []

        slices = range(0, len(board_lines), 5)

        for slice in slices:
            rows = [r.split() for r in board_lines[slice:slice+5]]

            with_markers = [[{"number": n, "marked": False}
                             for n in row] for row in rows]

            board_data.append(with_markers)

        for num in drawn_numbers:
            for board in board_data:
                for row in board:
                    for column in row:
                        if column["number"] == num:
                            column["marked"] = True
                if has_won(board):
                    print_board(board)
                    return calculate_score(board, num)


print(part_one())
