extends GutTest

const PawnScript = preload("res://Scripts/Move/Pawn.gd")
const InitScript = preload("res://Scripts/Init.gd")

func run_tests():
	test_generate_valid_positions()

func test_generate_valid_positions():
	gut.p('Movement of Pawn ')
	var pawn = PawnScript.new()
	var init_script = InitScript.new()
	init_script._init_board()

	# Test board with various pieces
	init_script.board[Vector2i(3, 3)] = "B"  # Bishop blocking
	init_script.board[Vector2i(4, 3)] = "p"  # Enemy pawn
	init_script.board[Vector2i(5, 5)] = 'P'
	init_script.board[Vector2i(5, 3)] = "q"  # Enemy queen blocking
	init_script.board[Vector2i(4, 4)] = "p"  # Friendly pawn itself
	init_script.board[Vector2i(6, 4)] = "p"  # Enemy pawn blocking
	init_script.board[Vector2i(4, 6)] = "p"  # Enemy pawn blocking
	init_script.board[Vector2i(2, 2)] = "q"  # Enemy queen blocking
	init_script.board[Vector2i(4, 7)] = "p"  # Enemy pawn blocking

	# Test position
	var from_position = Vector2i(4, 4)

	# Get valid positions
	var valid_positions = pawn.generate_valid_positions(from_position, init_script.board)

	# Assertions for valid positions
	assert_has(Vector2i(4, 5), valid_positions, "generate_valid_positions failed")
	assert_has(Vector2i(5, 5), valid_positions, "generate_valid_positions failed")

	# Assertions for invalid positions
	assert_does_not_have(Vector2i(4, 6), valid_positions, "generate_valid_positions failed")	
	assert_does_not_have(Vector2i(3, 3), valid_positions, "generate_valid_positions failed")
	assert_does_not_have(Vector2i(4, 3), valid_positions, "generate_valid_positions failed")
	assert_does_not_have(Vector2i(5, 3), valid_positions, "generate_valid_positions failed")
	assert_does_not_have(Vector2i(6, 4), valid_positions, "generate_valid_positions failed")
	assert_does_not_have(Vector2i(2, 2), valid_positions, "generate_valid_positions failed")
	assert_does_not_have(Vector2i(4, 7), valid_positions, "generate_valid_positions failed")
