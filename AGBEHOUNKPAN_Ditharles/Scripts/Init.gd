extends TileMap


var GRID_SIZE: int = 8

var piece_to_atlas_coords = {}
var board = {}

func _is_dark_square(row: int, col: int) -> bool:
	return (row + col) % 2 == 0


func _init_board():
	for i in range(GRID_SIZE):
		for j in range(GRID_SIZE):
			board[Vector2i(i,j)] = null

func _init_piece_to_atlas_coords():
	var pieces = "qkrnbp"  # Combine black and white pieces
	for index in range(pieces.length()):
		# Utilisons une boucle pour ajouter à la fois les pièces noires et blanches
		piece_to_atlas_coords[pieces[index]] = Vector2i(index, 0)
		piece_to_atlas_coords[pieces[index].to_upper()] = Vector2i(index, 1)

func _init_chess_design():
	for i in range(GRID_SIZE):
		for j in range(GRID_SIZE):
			var is_dark_square = _is_dark_square(i, j)
			var atlas_coords = Vector2i(0 ,1) if is_dark_square else Vector2i(0, 0)
			set_cell(0, Vector2i(i, j), 0, atlas_coords)

