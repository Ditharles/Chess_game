extends Node

const KingScript = preload("res://Scripts/Move/King.gd")

# TestKing.gd


func _ready():
	run_tests()

func run_tests():
	test_generate_valid_positions()
	test_is_position_occupied()
	test_are_different_colors()

func test_generate_valid_positions():
	var king = KingScript.new()
	var board = {
		Vector2i(3, 3): "B",
		Vector2i(5, 5): "Q",
		Vector2i(4, 4): "k",
		Vector2i(7, 7): "r",
		Vector2i(1, 1): "p", 
		Vector2i(2, 2): "p", 
		Vector2i(8, 8): "p", 
		Vector2i(1, 5): "p" 
	}
	var valid_positions = king.generate_valid_positions(Vector2i(4, 4), board)


	# Asserting valid positions
	assert(Vector2i(5, 5) in valid_positions, "generate_valid_positions failed")
	assert(Vector2i(3, 3) in valid_positions, "generate_valid_positions failed")
	assert(Vector2i(4, 5) in valid_positions, "generate_valid_positions failed")
	assert(Vector2i(5, 4) in valid_positions, "generate_valid_positions failed")
	assert(Vector2i(3, 4) in valid_positions, "generate_valid_positions failed")
	assert(Vector2i(4, 3) in valid_positions, "generate_valid_positions failed")
	assert(Vector2i(3, 5) in valid_positions, "generate_valid_positions failed")

	# Asserting invalid positions
	assert(!(Vector2i(1, 1) in valid_positions), "generate_valid_positions failed")
	assert(!(Vector2i(1, 5) in valid_positions), "generate_valid_positions failed")

	# Asserting out-of-bounds positions
	assert(!(Vector2i(0, 0) in valid_positions), "generate_valid_positions failed")
	assert(!(Vector2i(9, 9) in valid_positions), "generate_valid_positions failed")

func test_is_position_occupied():
	var king = KingScript.new()
	var board = {
		Vector2i(3, 3): "B",
		Vector2i(5, 5): "Q",
		Vector2i(7, 7): "r"
	}
	assert(king.is_position_occupied(Vector2i(3, 3), board) == true, "is_position_occupied failed")
	assert(king.is_position_occupied(Vector2i(4, 4), board) == false, "is_position_occupied failed")

func test_are_different_colors():
	var king = KingScript.new()
	assert(king.are_different_colors("B", "q") == true, "are_different_colors failed")
	assert(king.are_different_colors("r", "p") == false, "are_different_colors failed")

