extends GutTest

const RookScript = preload("res://Scripts/Move/Rook.gd")
const InitScript = preload("res://Scripts/Init.gd")

func run_tests():
	test_generate_valid_positions()

func test_generate_valid_positions():
	gut.p('Movement of Rook ')
	var rook = RookScript.new()
	var init_script = InitScript.new()
	init_script._init_board()

	# Define board with various pieces
	init_script.board[Vector2i(3, 3)] = "B"  # Bishop blocking
	init_script.board[Vector2i(4, 3)] = "p"  # Enemy pawn blocking
	init_script.board[Vector2i(4, 4)] = "R"  # Rook itself
	init_script.board[Vector2i(5, 3)] = "q"  # Enemy queen blocking
	init_script.board[Vector2i(6, 4)] = "p"  # Enemy pawn blocking
	init_script.board[Vector2i(2, 2)] = "q"  # Enemy queen blocking
	init_script.board[Vector2i(4, 6)] = "P"  # Friendly pawn blocking

	# Define test position
	var from_position = Vector2i(4, 4)

	# Get valid positions
	var valid_positions = rook.generate_valid_positions(from_position, init_script.board)

	# Assertions for valid positions
	assert_has(Vector2i(5, 4), valid_positions, "generate_valid_positions failed for position: (5, 4)")
	assert_has(Vector2i(6, 4), valid_positions, "generate_valid_positions failed for position: (6, 4)")
	assert_has(Vector2i(3, 4), valid_positions, "generate_valid_positions failed for position: (3, 4)")
	assert_has(Vector2i(2, 4), valid_positions, "generate_valid_positions failed for position: (2, 4)")
	assert_has(Vector2i(4, 3), valid_positions, "generate_valid_positions failed for position: (4, 3)")

	# Assertions for invalid positions
	assert_does_not_have(Vector2i(3, 3), valid_positions, "generate_valid_positions failed for invalid position: (3, 3)")
	assert_does_not_have(Vector2i(5, 3), valid_positions, "generate_valid_positions failed for invalid position: (5, 3)")
	assert_does_not_have(Vector2i(2, 2), valid_positions, "generate_valid_positions failed for invalid position: (2, 2)")
	assert_does_not_have(Vector2i(4, 6), valid_positions, "generate_valid_positions failed for invalid position: (4, 6)")

	# Assertions for out-of-bounds positions
	assert_does_not_have(Vector2i(-1, 4), valid_positions, "generate_valid_positions failed for out-of-bounds position: (-1, 4)")
	assert_does_not_have(Vector2i(10, 4), valid_positions, "generate_valid_positions failed for out-of-bounds position: (10, 4)")
	assert_does_not_have(Vector2i(4, -1), valid_positions, "generate_valid_positions failed for out-of-bounds position: (4, -1)")
	assert_does_not_have(Vector2i(4, 10), valid_positions, "generate_valid_positions failed for out-of-bounds position: (4, 10)")
