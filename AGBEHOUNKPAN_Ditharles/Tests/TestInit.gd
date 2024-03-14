extends TileMap

const InitScript = preload("res://Scripts/Init.gd")

func _ready():
	run_tests()

func run_tests():
	test_init_board()
	test_init_piece_to_atlas_coords()

func test_init_board():
	var init_script = InitScript.new()
	init_script._init_board()
	
	for i in range(init_script.GRID_SIZE):
		for j in range(init_script.GRID_SIZE):
			assert(init_script.board[Vector2i(i, j)] == null, "Board initialization failed")

func test_init_piece_to_atlas_coords():
	var init_script = InitScript.new()
	init_script._init_piece_to_atlas_coords()
	
	# Check if piece_to_atlas_coords dictionary is correctly initialized
	assert(init_script.piece_to_atlas_coords.size() == 12, "Piece to atlas coordinates initialization failed")
	assert(init_script.piece_to_atlas_coords["q"] == Vector2i(0, 0), "Piece to atlas coordinates initialization failed")
	assert(init_script.piece_to_atlas_coords["Q"] == Vector2i(0, 1), "Piece to atlas coordinates initialization failed")
	assert(init_script.piece_to_atlas_coords["k"] == Vector2i(5, 0), "Piece to atlas coordinates initialization failed")
	assert(init_script.piece_to_atlas_coords["K"] == Vector2i(5, 1), "Piece to atlas coordinates initialization failed")
	assert(init_script.piece_to_atlas_coords["p"] == Vector2i(6, 0), "Piece to atlas coordinates initialization failed")
	assert(init_script.piece_to_atlas_coords["P"] == Vector2i(6, 1), "Piece to atlas coordinates initialization failed")
	assert(init_script.piece_to_atlas_coords["r"] == Vector2i(3, 0), "Piece to atlas coordinates initialization failed")
	assert(init_script.piece_to_atlas_coords["R"] == Vector2i(3, 1), "Piece to atlas coordinates initialization failed")
	assert(init_script.piece_to_atlas_coords["n"] == Vector2i(1, 0), "Piece to atlas coordinates initialization failed")
	assert(init_script.piece_to_atlas_coords["N"] == Vector2i(1, 1), "Piece to atlas coordinates initialization failed")
	assert(init_script.piece_to_atlas_coords["b"] == Vector2i(2, 0), "Piece to atlas coordinates initialization failed")
	assert(init_script.piece_to_atlas_coords["B"] == Vector2i(2, 1), "Piece to atlas coordinates initialization failed")
