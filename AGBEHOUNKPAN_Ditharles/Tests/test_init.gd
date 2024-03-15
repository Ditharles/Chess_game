extends GutTest

const InitScript = preload("res://Scripts/Init.gd")

func test_init_board():
	var init_script = InitScript.new()
	init_script._init_board()

	for cell in init_script.board.values():
		assert_null(cell, "Board initialization failed: a cell is null.")

func test_init_piece_to_atlas_coords():
	# Initialisation
	var init_script = InitScript.new()
	
	# Exécution de la fonction à tester
	init_script._init_piece_to_atlas_coords()
	
	# Données de test pour les pièces
	var expected_coords = {
		"q": Vector2i(0, 0), "Q": Vector2i(0, 1),
		"k": Vector2i(1, 0), "K": Vector2i(1, 1),
		"r": Vector2i(2, 0), "R": Vector2i(2, 1),
		"n": Vector2i(3, 0), "N": Vector2i(3, 1),
		"b": Vector2i(4, 0), "B": Vector2i(4, 1),
		"p": Vector2i(5, 0), "P": Vector2i(5, 1)
	}

	# Vérification
	for piece in expected_coords:
		var got_coords = init_script.piece_to_atlas_coords[piece]
		assert_eq(got_coords, expected_coords[piece], "Piece to atlas coordinates initialization failed for piece " + piece + ": expected " + str(expected_coords[piece]) + ", got " + str(got_coords) + ".")
