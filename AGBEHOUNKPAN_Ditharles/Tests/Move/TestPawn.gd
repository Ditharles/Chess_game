extends Node

const PawnScript = preload("res://Scripts/Move/Pawn.gd")

# TestPawn.gd


func _ready():
	run_tests()

func run_tests():
	test_generate_valid_positions()
	test_is_position_occupied()
	test_are_different_colors()

func test_generate_valid_positions():
	var pawn = PawnScript.new()

	# Test board with various pieces
	var board = {
		Vector2i(3, 3): "B",  # Bishop blocking
		Vector2i(4, 3): "p",  # Enemy pawn
		Vector2i(5, 5):'P',
		Vector2i(5, 3): "q",  # Enemy queen blocking
		Vector2i(4, 4): "p",  # Friendly pawn itself
		Vector2i(6, 4): "p",  # Enemy pawn blocking
		Vector2i(4, 6): "p",  # Enemy pawn blocking
		Vector2i(2, 2): "q",  # Enemy queen blocking
		Vector2i(4, 7): "p"   # Enemy pawn blocking
	}

	# Test position
	var from_position = Vector2i(4, 4)

	# Get valid positions
	var valid_positions = pawn.generate_valid_positions(from_position, board)

	# Assertions for valid positions
	assert(valid_positions.size() == 3, "generate_valid_positions failed")
	assert(Vector2i(4, 5) in valid_positions, "generate_valid_positions failed")
	assert(Vector2i(4, 6) in valid_positions, "generate_valid_positions failed")
	assert(Vector2i(5, 5) in valid_positions, "generate_valid_positions failed")

	# Assertions for invalid positions
	assert(!(Vector2i(3, 3) in valid_positions), "generate_valid_positions failed")
	assert(!(Vector2i(4, 3) in valid_positions), "generate_valid_positions failed")
	assert(!(Vector2i(5, 3) in valid_positions), "generate_valid_positions failed")
	assert(!(Vector2i(6, 4) in valid_positions), "generate_valid_positions failed")
	assert(!(Vector2i(2, 2) in valid_positions), "generate_valid_positions failed")
	assert(!(Vector2i(4, 7) in valid_positions), "generate_valid_positions failed")

	
func test_is_position_occupied():
	var pawn = PawnScript.new()
	var board = {
		Vector2i(3, 3): "B",
		Vector2i(5, 5): "Q",
		Vector2i(7, 7): "r"
	}
	assert(pawn.is_position_occupied(Vector2i(3, 3), board) == true, "is_position_occupied failed")
	assert(pawn.is_position_occupied(Vector2i(4, 4), board) == false, "is_position_occupied failed")

func test_are_different_colors():
	var pawn = PawnScript.new()
	assert(pawn.are_different_colors("B", "q") == true, "are_different_colors failed")
	assert(pawn.are_different_colors("r", "p") == true, "are_different_colors failed")
	assert(pawn.are_different_colors("N", "P") == false, "are_different_colors failed")
