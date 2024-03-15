extends GutTest

const KnightScript = preload("res://Scripts/Move/Knight.gd")
const InitScript = preload("res://Scripts/Init.gd")

func test_generate_valid_positions():
	gut.p('Movement of Knight ')
	var knight = KnightScript.new()
	var init_script = InitScript.new()
	init_script._init_board()

	init_script.board[Vector2i(3, 3)] = "B"  # Bishop blocking
	init_script.board[Vector2i(5, 5)] = "Q"  # Queen blocking
	init_script.board[Vector2i(7, 7)] = "r"  # Rook blocking
	init_script.board[Vector2i(4, 4)] = "n"  # Knight itself
	init_script.board[Vector2i(4, 2)] = "p"  # Enemy pawn
	init_script.board[Vector2i(5, 3)] = "p"  # Friendly pawn blocking
	init_script.board[Vector2i(4, 5)] = "q"  # Enemy queen

	# Test position
	var from_position = Vector2i(4, 4)

	# Get valid positions
	var valid_positions = knight.generate_valid_positions(from_position, init_script.board)

	# Assertions for valid positions
	assert_has(Vector2i(6, 5), valid_positions, "generate_valid_positions failed")
	assert_has(Vector2i(6, 3), valid_positions, "generate_valid_positions failed")
	assert_has(Vector2i(5, 2), valid_positions, "generate_valid_positions failed")
	assert_has(Vector2i(3, 2), valid_positions, "generate_valid_positions failed")
	assert_has(Vector2i(3, 6), valid_positions, "generate_valid_positions failed")

	# Assertions for invalid positions
	assert_does_not_have(Vector2i(3, 3), valid_positions, "generate_valid_positions failed")
	assert_does_not_have(Vector2i(5, 5), valid_positions, "generate_valid_positions failed")
	assert_does_not_have(Vector2i(7, 7), valid_positions, "generate_valid_positions failed")
	assert_does_not_have(Vector2i(4, 2), valid_positions, "generate_valid_positions failed")
	assert_does_not_have(Vector2i(5, 3), valid_positions, "generate_valid_positions failed")
	assert_does_not_have(Vector2i(4, 5), valid_positions, "generate_valid_positions failed")

	# Assertions for out-of-bounds positions
	assert_does_not_have(Vector2i(0, 0), valid_positions, "generate_valid_positions failed")
	assert_does_not_have(Vector2i(9, 9), valid_positions, "generate_valid_positions failed")
