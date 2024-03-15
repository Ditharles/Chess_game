extends GutTest

const BishopScript = preload("res://Scripts/Move/Bishop.gd")
const InitScript = preload("res://Scripts/Init.gd")

func test_generate_valid_positions():
	gut.p('Movement of Bishop ')
	var bishop = BishopScript.new()
	var init_script = InitScript.new()
	init_script._init_board()

	# Test board with various pieces
	init_script.board[Vector2i(3, 3)] = "B"  # Bishop blocking
	init_script.board[Vector2i(5, 5)] = "Q"  # Queen blocking
	init_script.board[Vector2i(7, 7)] = "r"  # Rook blocking
	init_script.board[Vector2i(1, 1)] = "P"  # Friendly piece
	init_script.board[Vector2i(2, 2)] = "p"  # Enemy piece
	init_script.board[Vector2i(1, 5)] = "P"  # Friendly piece
	init_script.board[Vector2i(4,4)]= "b"
	var valid_positions = bishop.generate_valid_positions(Vector2i(4, 4), init_script.board)

	# Asserting valid positions
	assert_has(Vector2i(5, 5), valid_positions, "generate_valid_positions failed")
	assert_has(Vector2i(2, 6), valid_positions, "generate_valid_positions failed")
	assert_has(Vector2i(3, 3), valid_positions, "generate_valid_positions failed")
	assert_does_not_have(Vector2i(7, 7), valid_positions, "generate_valid_positions failed")
	assert_does_not_have(Vector2i(8, 8), valid_positions, "generate_valid_positions failed")
	assert_does_not_have(Vector2i(2, 2), valid_positions, "generate_valid_positions failed")

	# Asserting invalid positions
	assert_does_not_have(Vector2i(1, 1), valid_positions, "generate_valid_positions failed")
	assert_does_not_have(Vector2i(1, 5), valid_positions, "generate_valid_positions failed")

	# Asserting out-of-bounds positions
	assert_does_not_have(Vector2i(0, 0), valid_positions, "generate_valid_positions failed")
	assert_does_not_have(Vector2i(9, 9), valid_positions, "generate_valid_positions failed")

	# Asserting positions outside of the bishop's diagonal movement
	assert_does_not_have(Vector2i(4, 5), valid_positions, "generate_valid_positions failed")
	assert_does_not_have(Vector2i(4, 3), valid_positions, "generate_valid_positions failed")
	assert_does_not_have(Vector2i(6, 4), valid_positions, "generate_valid_positions failed")
