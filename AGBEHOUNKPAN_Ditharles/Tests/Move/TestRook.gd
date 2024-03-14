extends Node

const RookScript = preload("res://Scripts/Move/Rook.gd")

# TestRook.gd


func _ready():
	run_tests()

func run_tests():
	test_generate_valid_positions()
	test_is_position_occupied()
	test_are_different_colors()

func test_generate_valid_positions():
	var rook = RookScript.new()

	# Define board with various pieces
	var board = {
	Vector2i(3, 3): "B",  # Bishop blocking
	Vector2i(4, 3): "p",  # Enemy pawn blocking
	Vector2i(4, 4): "R",  # Rook itself
	Vector2i(5, 3): "q",  # Enemy queen blocking
	Vector2i(6, 4): "p",  # Enemy pawn blocking
	Vector2i(2, 2): "q",  # Enemy queen blocking
	Vector2i(4, 6): "P"   # Friendly pawn blocking
	}

	# Define test position
	var from_position = Vector2i(4, 4)

	# Get valid positions
	var valid_positions = rook.generate_valid_positions(from_position, board)

	# Assertions for valid positions
	assert(Vector2i(5, 4) in valid_positions, "generate_valid_positions failed for position: (5, 4)")
	assert(Vector2i(6, 4) in valid_positions, "generate_valid_positions failed for position: (6, 4)")
	assert(Vector2i(3, 4) in valid_positions, "generate_valid_positions failed for position: (3, 4)")
	assert(Vector2i(2, 4) in valid_positions, "generate_valid_positions failed for position: (2, 4)")
	assert(Vector2i(4, 3) in valid_positions, "generate_valid_positions failed for position: (4, 3)")

	# Assertions for invalid positions
	assert(!(Vector2i(3, 3) in valid_positions), "generate_valid_positions failed for invalid position: (3, 3)")
	assert(!(Vector2i(5, 3) in valid_positions), "generate_valid_positions failed for invalid position: (5, 3)")
	assert(!(Vector2i(2, 2) in valid_positions), "generate_valid_positions failed for invalid position: (2, 2)")
	assert(!(Vector2i(4, 6) in valid_positions), "generate_valid_positions failed for invalid position: (4, 6)")

	# Assertions for out-of-bounds positions
	assert(!(Vector2i(-1, 4) in valid_positions), "generate_valid_positions failed for out-of-bounds position: (-1, 4)")
	assert(!(Vector2i(10, 4) in valid_positions), "generate_valid_positions failed for out-of-bounds position: (10, 4)")
	assert(!(Vector2i(4, -1) in valid_positions), "generate_valid_positions failed for out-of-bounds position: (4, -1)")
	assert(!(Vector2i(4, 10) in valid_positions), "generate_valid_positions failed for out-of-bounds position: (4, 10)")

func test_is_position_occupied():
	var rook = RookScript.new()
	var board = {
		Vector2i(3, 3): "B",
		Vector2i(5, 5): "Q",
		Vector2i(7, 7): "r"
	}
	assert(rook.is_position_occupied(Vector2i(3, 3), board) == true, "is_position_occupied failed")
	assert(rook.is_position_occupied(Vector2i(4, 4), board) == false, "is_position_occupied failed")

func test_are_different_colors():
	var rook = RookScript.new()
	assert(rook.are_different_colors("B", "q") == true, "are_different_colors failed")
	assert(rook.are_different_colors("r", "p") == false, "are_different_colors failed")

