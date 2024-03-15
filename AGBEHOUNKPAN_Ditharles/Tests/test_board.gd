extends GutTest


const PawnMove = preload("res://Scripts/Move/Pawn.gd")
const RookMove = preload("res://Scripts/Move/Rook.gd")
const KnightMove = preload("res://Scripts/Move/Knight.gd")
const BishopMove = preload("res://Scripts/Move/Bishop.gd")
const KingMove = preload("res://Scripts/Move/King.gd")

const BoardScript = preload("res://Scripts/Board.gd")

func setup_board_script():
	var board_script = BoardScript.new()
	board_script._init_board()
	board_script._init_piece_to_atlas_coords()
	board_script._init_chess_design()
	return board_script

func test_set_piece_at_position():
	var board_script = setup_board_script()
	board_script.set_piece_at_position("P", Vector2i(2, 3))
	assert_true(board_script.board[Vector2i(2, 3)] == "P", "Failed to set piece at position.")

func test_clear_position():
	var board_script = setup_board_script()
	board_script.set_piece_at_position("P", Vector2i(2, 3))
	board_script.clear_position(Vector2i(2, 3))
	assert_true(board_script.board[Vector2i(2, 3)] == null, "Failed to clear piece at position.")

func test_set_board():
	var board_script = setup_board_script()
	board_script.set_board("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")

	var black_pieces = ["rnbqkbnr", "pppppppp"]
	var white_pieces = ["RNBQKBNR", "PPPPPPPP"]
	var black_row = ""
	var white_row = ""
	for row_index in range(8):
		if row_index < 2:
			black_row = black_pieces[row_index]
		elif row_index > 5:
			white_row = white_pieces[7 - row_index]
		if row_index>5 or row_index<2:
			for col_index in range(8):
				var position = Vector2i(col_index, row_index)
				var piece = black_row.substr(col_index, 1) if row_index < 2 else white_row.substr(col_index, 1)
				assert_true(board_script.board[position] == piece, "Failed to set piece at position: " + str(position))




func test_get_color():
	var board_script = setup_board_script()
	assert_true(board_script.get_color("P") == BoardScript.PieceColor.WHITE, "Incorrect color for white piece.")
	assert_true(board_script.get_color("p") == BoardScript.PieceColor.BLACK, "Incorrect color for black piece.")

func test_are_different_colors():
	var board_script = setup_board_script()
	assert_true(board_script.are_different_colors("P", "p"), "Pieces with different colors are not detected.")
	assert_true(board_script.are_different_colors("N", "Q") == false, "Pieces with same color are detected as different.")

func test_move_piece():
	var board_script = setup_board_script()
	board_script.set_piece_at_position("P", Vector2i(2, 2))
	board_script.move_piece(Vector2i(2, 2), Vector2i(3, 2))
	assert_true(board_script.board[Vector2i(3, 2)] == "P", "Piece not moved to the correct position.")
	assert_true(board_script.board[Vector2i(2, 2)] == null, "Starting position not cleared after moving piece.")
