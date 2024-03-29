# Init.gd

extends "res://Scripts/Init.gd"

# Importing scripts for piece movements
const PawnMove = preload("res://Scripts/Move/Pawn.gd")
const RookMove = preload("res://Scripts/Move/Rook.gd")
const KnightMove = preload("res://Scripts/Move/Knight.gd")
const BishopMove = preload("res://Scripts/Move/Bishop.gd")
const KingMove = preload("res://Scripts/Move/King.gd")

# Signal emitted when a piece is selected
signal piece_selected(position: Vector2i)
# Signal emitted when a piece is moved
signal piece_move(piece: String)

# Function called when the game starts
func _ready():
	# Initializes the game board
	_init_board()
	# Initializes the piece coordinates on the atlas
	_init_piece_to_atlas_coords()
	# Initializes the chess game design
	_init_chess_design()
	# Sets the initial state of the board based on the FEN notation
	set_board('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')

# Places a piece at a given position
func set_piece_at_position(piece: String, position: Vector2i):
	set_cell(1, position, 1, piece_to_atlas_coords[piece])
	board[position] = piece

# Clears a given position
func clear_position(position: Vector2i):
	set_cell(1, position)
	board[position] = null

# Sets the board state from a FEN notation
func set_board(fen: String):
	var fen_parts = fen.split(' ')
	var piece_placement_data = fen_parts[0]
	
	var ranks = piece_placement_data.split('/')
	
	for row in range(ranks.size()):
		var rank = ranks[row]
		var col = 0
		for value in rank:
			if value.is_valid_int():
				col += value.to_int()
			else:
				var position = Vector2i(col, row)
				set_piece_at_position(value, position)
				board[position] = value
				col += 1

# Currently selected position by the player
var selected_piece_position: Vector2i = Vector2i(-1 , -1)
# Color of the piece currently being moved
var current_move = PieceColor.WHITE

# Enumeration of piece colors
enum PieceColor { BLACK, WHITE }

# Returns the color of a given piece
func get_color(piece: String) -> PieceColor:
	var black_pieces = 'qkrnbp'
	return PieceColor.BLACK if piece in black_pieces else PieceColor.WHITE

# Checks if two pieces are of different colors
func are_different_colors(piece1: String, piece2: String):
	return get_color(piece1) != get_color(piece2)

# Highlights the given positions on the game board
func highlight_positions(positions: Array[Vector2i]):
	for position in positions:
		set_cell(2, position, 2, Vector2i.ZERO)

# Clears the highlights of positions on the game board
func clear_highlights():
	var highlight_cells = get_used_cells(2)
	for cell in highlight_cells:
		set_cell(2, Vector2i(cell.x, cell.y))

# Checks if a given position is occupied by a piece
func _is_position_occupied(position: Vector2i) -> bool:
	return position in board and board[position] != null

# Generates valid move positions for a given piece from a starting position
func generate_valid_move_positions(from_position: Vector2i) -> Array[Vector2i]:
	var piece = board[from_position]
	var valid_move_positions: Array[Vector2i] = []
	var pawn_move = PawnMove.new()
	var rook_move = RookMove.new()
	var knight_move = KnightMove.new()
	var bishop_move = BishopMove.new()
	var king_move = KingMove.new()

	if piece == 'p' or piece == 'P':
		valid_move_positions = pawn_move.generate_valid_positions(from_position, board)
	elif piece == 'r' or piece == 'R':
		valid_move_positions = rook_move.generate_valid_positions(from_position, board)
	elif piece == 'n' or piece == 'N':
		valid_move_positions = knight_move.generate_valid_positions(from_position, board)
	elif piece == 'b' or piece == 'B':
		valid_move_positions = bishop_move.generate_valid_positions(from_position, board)
	elif piece == 'q' or piece == 'Q':
		valid_move_positions = bishop_move.generate_valid_positions(from_position, board) + rook_move.generate_valid_positions(from_position, board)
	elif piece == 'k' or piece == 'K':
		valid_move_positions = king_move.generate_valid_positions(from_position, board)
		
		
	for position in valid_move_positions :
		if _is_position_occupied(position):
			set_cell(0, position, 3, Vector2i(0,0))
	return valid_move_positions

# Checks if a move from the starting position to the destination position is valid
func is_valid_move(from_position: Vector2i, to_position: Vector2i):
	if from_position not in board or to_position not in board:
		return false
	
	var valid_move_positions = generate_valid_move_positions(from_position)
	return to_position in valid_move_positions

# Moves a piece from a starting position to a destination position
func move_piece(from_position: Vector2i, to_position: Vector2i):
	var piece = board[from_position]
	emit_signal("piece_move", piece)
	set_piece_at_position(piece, to_position)
	clear_position(from_position)
	_init_chess_design() 

# Handles user interactions
func _input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == MOUSE_BUTTON_LEFT and event.is_pressed():
			var click_position = local_to_map(event.position)
			clear_highlights()
			if selected_piece_position == Vector2i(-1, -1):
				if click_position in board and board[click_position] != null:
					if get_color(board[click_position]) == current_move:
						selected_piece_position = click_position
						emit_signal("piece_selected", selected_piece_position)
						set_cell(0, click_position, 3, Vector2i(0,0))
			else:
				_init_chess_design()
				if click_position in board:
					set_cell(0, click_position, 3, Vector2i(0,0))
					var already_selected_piece = board[selected_piece_position]
					if board[click_position] != null:
						if not are_different_colors(already_selected_piece, board[click_position]):
							selected_piece_position = click_position
							emit_signal("piece_selected", selected_piece_position)
							return
					print('Move requested from:', selected_piece_position, 'to:', click_position)
					if is_valid_move(selected_piece_position, click_position):
						move_piece(selected_piece_position, click_position)
						
				clear_highlights()
				selected_piece_position = Vector2i(-1, -1)
				_init_chess_design()

# Handles the event when a piece is selected
func _on_piece_selected(position):
	var valid_move_positions = generate_valid_move_positions(position)
	highlight_positions(valid_move_positions)
	

# Handles the event when a piece is moved
func _on_piece_move(piece):
	if current_move == PieceColor.BLACK:
		current_move = PieceColor.WHITE
	else:
		current_move = PieceColor.BLACK
