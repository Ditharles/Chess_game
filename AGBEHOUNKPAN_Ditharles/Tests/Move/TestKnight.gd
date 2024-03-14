extends Node

const KnightScript = preload("res://Scripts/Move/Knight.gd")

# TestKnight.gd


func _ready():
	run_tests()

func run_tests():
	test_generate_valid_positions()
	test_is_position_occupied()
	test_are_different_colors()

func test_generate_valid_positions():
	var knight = KnightScript.new()

	# Test board with various pieces
	var board = {
		Vector2i(3, 3): "B",  # Bishop blocking
		Vector2i(5, 5): "Q",  # Queen blocking
		Vector2i(7, 7): "r",  # Rook blocking
		Vector2i(4, 4): "N",  # Knight itself
		Vector2i(4, 2): "p",  # Enemy pawn
		Vector2i(5, 3): "p",  # Friendly pawn blocking
		Vector2i(4, 5): "q"   # Enemy queen
	}

	# Test position
	var from_position = Vector2i(4, 4)

	# Get valid positions
	var valid_positions = knight.generate_valid_positions(from_position, board)

	# Assertions for valid positions
	
	
	assert(Vector2i(6, 5) in valid_positions, "generate_valid_positions failed")
	assert(Vector2i(6, 3) in valid_positions, "generate_valid_positions failed")
	assert(Vector2i(5, 2) in valid_positions, "generate_valid_positions failed")
	assert(Vector2i(3, 2) in valid_positions, "generate_valid_positions failed")
	assert(Vector2i(3, 6) in valid_positions, "generate_valid_positions failed")

	# Assertions for invalid positions
	assert(!(Vector2i(3, 3) in valid_positions), "generate_valid_positions failed")
	assert(!(Vector2i(5, 5) in valid_positions), "generate_valid_positions failed")
	assert(!(Vector2i(7, 7) in valid_positions), "generate_valid_positions failed")
	assert(!(Vector2i(4, 2) in valid_positions), "generate_valid_positions failed")
	assert(!(Vector2i(5, 3) in valid_positions), "generate_valid_positions failed")
	assert(!(Vector2i(4, 5) in valid_positions), "generate_valid_positions failed")

	# Assertions for out-of-bounds positions
	assert(!(Vector2i(0, 0) in valid_positions), "generate_valid_positions failed")
	assert(!(Vector2i(9, 9) in valid_positions), "generate_valid_positions failed")

func test_is_position_occupied():
	var knight = KnightScript.new()
	var board = {
		Vector2i(3, 3): "B",
		Vector2i(5, 5): "Q",
		Vector2i(7, 7): "r"
	}
	assert(knight.is_position_occupied(Vector2i(3, 3), board) == true, "is_position_occupied failed")
	assert(knight.is_position_occupied(Vector2i(4, 4), board) == false, "is_position_occupied failed")

func test_are_different_colors():
	var knight = KnightScript.new()
	assert(knight.are_different_colors("B", "q") == true, "are_different_colors failed")
	assert(knight.are_different_colors("r", "p") == false, "are_different_colors failed")
	
