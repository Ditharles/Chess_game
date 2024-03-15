extends GutTest

const KingScript = preload("res://Scripts/Move/King.gd")
const InitScript = preload("res://Scripts/Init.gd")

func run_tests():
	test_generate_valid_positions()

func test_generate_valid_positions():
	gut.p('Movement of King ')
	var king = KingScript.new()
	var init_script = InitScript.new()
	init_script._init_board()

	# Test board with various pieces
	init_script.board[Vector2i(3, 3)] = "B"  # Bishop blocking
	init_script.board[Vector2i(5, 5)] = "Q"  # Queen blocking
	init_script.board[Vector2i(7, 7)] = "r"  # Rook blocking
	init_script.board[Vector2i(1, 1)] = "p"  # Enemy pawn
	init_script.board[Vector2i(2, 2)] = "p"  # Enemy pawn
	init_script.board[Vector2i(1, 5)] = "p"  # Enemy pawn
	init_script.board[Vector2i(4, 4)] = "k"  # Enemy pawn

	var valid_positions = king.generate_valid_positions(Vector2i(4, 4), init_script.board)

	# Assertions for valid positions
	assert_has(Vector2i(5, 5), valid_positions, "generate_valid_positions failed")
	assert_has(Vector2i(3, 3), valid_positions, "generate_valid_positions failed")
	assert_has(Vector2i(3, 5), valid_positions, "generate_valid_positions failed")
	assert_has(Vector2i(5, 3), valid_positions, "generate_valid_positions failed")
	assert_has(Vector2i(5, 4), valid_positions, "generate_valid_positions failed")
	
	# Assertions for invalid positions
	assert_does_not_have(Vector2i(1, 1), valid_positions, "generate_valid_positions failed")
	assert_does_not_have(Vector2i(1, 5), valid_positions, "generate_valid_positions failed")

	# Assertions for out-of-bounds positions
	assert_does_not_have(Vector2i(0, 0), valid_positions, "generate_valid_positions failed")
	assert_does_not_have(Vector2i(9, 9), valid_positions, "generate_valid_positions failed")
