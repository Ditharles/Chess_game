extends TileMap

const GlobalScript = preload("res://Scripts/Board.gd")
const PawnMove = preload("res://Scripts/Move/Pawn.gd")
const RookMove = preload("res://Scripts/Move/Rook.gd")
const KnightMove = preload("res://Scripts/Move/Knight.gd")
const BishopMove = preload("res://Scripts/Move/Bishop.gd")
const KingMove = preload("res://Scripts/Move/King.gd")

const TestPawn = preload("res://Tests/Move/TestPawn.gd")
const TestRook = preload("res://Tests/Move/TestRook.gd")
const TestKnight = preload("res://Tests/Move/TestKnight.gd")
const TestBishop = preload("res://Tests/Move/TestBishop.gd")
const TestKing = preload("res://Tests/Move/TestKing.gd")


func start():

	print("Test start")
	run_tests()

func run_tests():
	test_set_piece_at_position()
	test_clear_position()
	test_set_board()
	test_get_color()
	test_are_different_colors()
	test_generate_valid_move_positions()
	test_move_piece()

func test_set_piece_at_position():
	var global_script = GlobalScript.new()
	global_script._init_board()
	global_script._init_piece_to_atlas_coords()

	global_script.set_piece_at_position("P", Vector2i(2, 3))
	assert(global_script.board[Vector2i(2, 3)] == "P", "set_piece_at_position failed")

func test_clear_position():
	var global_script = GlobalScript.new()
	global_script._init_board()
	global_script._init_piece_to_atlas_coords()

	global_script.set_piece_at_position("P", Vector2i(2, 3))
	global_script.clear_position(Vector2i(2, 3))
	assert(global_script.board[Vector2i(2, 3)] == null, "clear_position failed")


func test_set_board():
	var global_script = GlobalScript.new()
	global_script._init_board()
	global_script._init_piece_to_atlas_coords()
	
	global_script.set_board("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
	
	# Assert for white pieces
	assert(global_script.board[Vector2i(0, 0)] == "r", "set_board failed")
	assert(global_script.board[Vector2i(1, 0)] == "n", "set_board failed")
	assert(global_script.board[Vector2i(2, 0)] == "b", "set_board failed")
	assert(global_script.board[Vector2i(3, 0)] == "q", "set_board failed")
	assert(global_script.board[Vector2i(4, 0)] == "k", "set_board failed")
	assert(global_script.board[Vector2i(5, 0)] == "b", "set_board failed")
	assert(global_script.board[Vector2i(6, 0)] == "n", "set_board failed")
	assert(global_script.board[Vector2i(7, 0)] == "r", "set_board failed")
	assert(global_script.board[Vector2i(0, 1)] == "p", "set_board failed")
	assert(global_script.board[Vector2i(1, 1)] == "p", "set_board failed")
	assert(global_script.board[Vector2i(2, 1)] == "p", "set_board failed")
	assert(global_script.board[Vector2i(3, 1)] == "p", "set_board failed")
	assert(global_script.board[Vector2i(4, 1)] == "p", "set_board failed")
	assert(global_script.board[Vector2i(5, 1)] == "p", "set_board failed")
	assert(global_script.board[Vector2i(6, 1)] == "p", "set_board failed")
	assert(global_script.board[Vector2i(7, 1)] == "p", "set_board failed")
	
	# Assert for black pieces
	assert(global_script.board[Vector2i(0, 7)] == "R", "set_board failed")
	assert(global_script.board[Vector2i(1, 7)] == "N", "set_board failed")
	assert(global_script.board[Vector2i(2, 7)] == "B", "set_board failed")
	assert(global_script.board[Vector2i(3, 7)] == "Q", "set_board failed")
	assert(global_script.board[Vector2i(4, 7)] == "K", "set_board failed")
	assert(global_script.board[Vector2i(5, 7)] == "B", "set_board failed")
	assert(global_script.board[Vector2i(6, 7)] == "N", "set_board failed")
	assert(global_script.board[Vector2i(7, 7)] == "R", "set_board failed")
	assert(global_script.board[Vector2i(0, 6)] == "P", "set_board failed")
	assert(global_script.board[Vector2i(1, 6)] == "P", "set_board failed")
	assert(global_script.board[Vector2i(2, 6)] == "P", "set_board failed")
	assert(global_script.board[Vector2i(3, 6)] == "P", "set_board failed")
	assert(global_script.board[Vector2i(4, 6)] == "P", "set_board failed")
	assert(global_script.board[Vector2i(5, 6)] == "P", "set_board failed")
	assert(global_script.board[Vector2i(6, 6)] == "P", "set_board failed")
	assert(global_script.board[Vector2i(7, 6)] == "P", "set_board failed")


func test_get_color():
	var global_script = GlobalScript.new()
	assert(global_script.get_color("P") == GlobalScript.PieceColor.WHITE, "get_color failed")
	assert(global_script.get_color("p") == GlobalScript.PieceColor.BLACK, "get_color failed")

func test_are_different_colors():
	var global_script = GlobalScript.new()
	assert(global_script.are_different_colors("P", "p") == true, "are_different_colors failed")
	assert(global_script.are_different_colors("N", "Q") == false, "are_different_colors failed")

func test_generate_valid_move_positions():
	var rook_test = TestRook.new()
	rook_test.run_tests()
	var knight_test = TestKnight.new()
	knight_test.run_tests()
	var bishop_test = TestBishop.new()
	bishop_test.run_tests()
	var king_test = TestKing.new()
	king_test.run_tests()

func test_move_piece():
	var global_script = GlobalScript.new()
	global_script._init_board()
	global_script._init_piece_to_atlas_coords()
	global_script._init_chess_design()

	global_script.set_piece_at_position("P", Vector2i(2, 2))

	global_script.move_piece(Vector2i(2, 2), Vector2i(3, 3))

	assert(global_script.board[Vector2i(3, 3)] == "P", "move_piece failed: Piece not moved to the correct position")
	assert(global_script.board[Vector2i(2, 2)] == null, "move_piece failed: Starting position not cleared")
