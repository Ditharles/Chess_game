extends TileMap

var GRID_SIZE: int = 8

var piece_to_atlas_coords = {}
var board = {}

signal piece_selected(position: Vector2i)

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


func _is_dark_square(row: int, col: int) -> bool:
	return (row + col) % 2 == 0

func _ready():
	_init_board()
	_init_piece_to_atlas_coords()
	_init_chess_design()
	set_board('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')


func set_piece_at_position(piece: String, position: Vector2i):
	set_cell(1, position, 1, piece_to_atlas_coords[piece])
	board[position]= piece

func clear_position(position: Vector2i):
	set_cell(1, position)
	board[position]= null
#fen format: rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1

func set_board(fen: String):
	var fen_parts = fen.split(' ')
	var piece_placemnt_data =  fen_parts[0]
	
	var ranks=piece_placemnt_data.split('/')
	
	for row in range(ranks.size()):
		var rank = ranks[row]
		var col = 0
		for value in rank :
			if value.is_valid_int():
				col = value.to_int()
			else :
			#piece place it here
				var position = Vector2i(col, row)
				set_piece_at_position(value, Vector2i(col,row))
				board[position] = value
				col+=1


#MOVEMENT
var selected_piece_position: Vector2i = Vector2i(-1 , -1)

enum PieceColor { BLACK , WHITE}

func get_color(piece: String) -> PieceColor:
	var blackpieces = 'qkrnbp'
	return PieceColor.BLACK if piece in blackpieces else PieceColor.WHITE

func are_different_colors(piece1: String, piece2: String):
	return get_color(piece1) != get_color(piece2)


func highlight_positions (positions: Array[Vector2i]):
	for position in positions:
		set_cell(2,position, 2, Vector2i.ZERO)

func clear_highlights():
	var highlight_cells = get_used_cells(2)
	for cell in highlight_cells:
		set_cell(2,Vector2i(cell.x, cell.y))
	



func _is_position_occupied(position: Vector2i) ->bool:
	return position in board and board[position] != null 

func generate_valid_pawn_positions(piece: String,from_position: Vector2i) -> Array[Vector2i] :

	var direction = Vector2i.UP if piece == 'P' else Vector2i.DOWN
	var base_position = 6 if piece == 'P' else 1
	var valid_positions: Array[Vector2i] = []
	
	var target_position= from_position+direction
	if not _is_position_occupied(target_position):
		valid_positions.append(target_position)
	
	#base position, two steps allowed
	if from_position.y == base_position :
		target_position=from_position + (direction * 2)
		if not _is_position_occupied(target_position):
			valid_positions.append(target_position)
	#capture positions
	#if in any of the 2 diagonales, there is an opponen piece, it's a valid position
	var diagonal_positions= [from_position + direction + Vector2i.RIGHT, from_position+ direction + Vector2i.LEFT]
	for position in diagonal_positions:
		if _is_position_occupied(position):
			if are_different_colors(piece, board[position]):
				valid_positions.append(position)
	return valid_positions

func generate_valid_rook_positions(piece: String, from_position: Vector2i) -> Array[Vector2i] :
	var valid_positions: Array[Vector2i] = []
	
	for direction in [Vector2i.UP,Vector2i.LEFT,Vector2i.RIGHT,Vector2i.DOWN] :
		var target_position = from_position + direction
		while target_position in board and not _is_position_occupied(target_position) :
			valid_positions.append(target_position)
			target_position+=direction
		if target_position in board:
			if are_different_colors(piece,board[target_position]):
				#capture
				valid_positions.append(target_position)
	return valid_positions
	
func generate_valid_move_positions(from_position: Vector2i) -> Array[Vector2i]:
	var piece = board[from_position]

	var valid_move_positions = []
	
	if piece == 'p' or piece == 'P':
		valid_move_positions = generate_valid_pawn_positions(piece, from_position)
		
	elif piece== 'r' or piece == 'R':
		valid_move_positions = generate_valid_rook_positions(piece, from_position)
	elif piece== 'n' or piece == 'n':
		valid_move_positions = generate_valid_rook_positions(piece, from_position)
	
	return valid_move_positions


func is_valid_move(from_position: Vector2i, to_position: Vector2i) :
	# check within bounds
	if from_position not in board or  to_position not in board:
		return false
	
	var valid_move_positions = generate_valid_move_positions(from_position)
	return to_position in valid_move_positions
	
	
func move_piece(from_position: Vector2i, to_position:Vector2i):
	var piece =  board [from_position]
	set_piece_at_position(piece,to_position)
	clear_position(from_position)

func _input(event):
	if event is InputEventMouseButton :
		
		if event.get_button_index() == MOUSE_BUTTON_LEFT and event.is_pressed():
			var click_position=local_to_map(get_local_mouse_position())
			clear_highlights()
			if selected_piece_position == Vector2i(-1, -1) :
			# piece is not selected yet, update selected place posiion
				if click_position in board and board[click_position] != null : 
					selected_piece_position = Vector2i(-1 , -1)
				selected_piece_position=click_position
				print('Selected pieces at  position: ',selected_piece_position)
				emit_signal("piece_selected",selected_piece_position)
			else :
				if click_position in board : 
					#piece already selected 
					var already_selected_piece = board[selected_piece_position]
					if board[click_position] != null:
						#the is a place at a target positioncheck if friendly piece selected
						if not are_different_colors(already_selected_piece, board[click_position]):
							# change selection to the new piece
							selected_piece_position=click_position
							emit_signal("piece_selected",selected_piece_position)
							return
					#attempt to move the piece 
					print('Move requests from : ', selected_piece_position , ' to :', click_position)
					if is_valid_move(selected_piece_position, click_position) :
						move_piece(selected_piece_position,click_position)
				clear_highlights()
				selected_piece_position = Vector2i(-1 , -1)
			print(click_position)
			


func _on_piece_selected(position):
	var valid_more_positions=generate_valid_move_positions(position)
	highlight_positions(valid_more_positions)
	
