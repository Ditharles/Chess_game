extends GutTest

const BishopScript = preload("res://Scripts/Move/Bishop.gd")

func test_generate_valid_positions():
	var bishop = BishopScript.new()
	var board = {
		Vector2i(3, 3): "B",
		Vector2i(4, 4): "b",
		Vector2i(5, 5): "Q",
		Vector2i(7, 7): "r",
		Vector2i(1, 1): "P", # Friendly piece
		Vector2i(2, 2): "p", # Enemy piece
		Vector2i(8, 8): "P", # Enemy piece
		Vector2i(1, 5): "P" # Friendly piece
	}
	var valid_positions = bishop.generate_valid_positions(Vector2i(4, 4), board)

	# Asserting valid positions
	assert_has(Vector2i(5, 5), valid_positions, "generate_valid_positions failed")
	assert_has(Vector2i(3, 3), valid_positions, "generate_valid_positions failed")
	assert_has(Vector2i(7, 7), valid_positions, "generate_valid_positions failed")
	assert_has(Vector2i(8, 8), valid_positions, "generate_valid_positions failed")
	assert_has(Vector2i(2, 2), valid_positions, "generate_valid_positions failed")

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
	assert_does_not_have(Vector2i(2, 6), valid_positions, "generate_valid_positions failed")

func test_is_position_occupied():
	var bishop = BishopScript.new()
	var board = {
		Vector2i(3, 3): "B",
		Vector2i(5, 5): "Q",
		Vector2i(7, 7): "r"
	}
	assert_false(bishop.is_position_occupied(Vector2i(3, 3), board), "is_position_occupied failed")
	assert_true(bishop.is_position_occupied(Vector2i(4, 4), board), "is_position_occupied failed")

func test_are_different_colors():
	var bishop = BishopScript.new()
	assert_false(bishop.are_different_colors("B", "q"), "are_different_colors failed")
	assert_true(bishop.are_different_colors("r", "p"), "are_different_colors failed")
