# Pawn.gd

extends Node

func generate_valid_positions(from_position: Vector2i, board: Dictionary) -> Array[Vector2i]:
	var piece = board[from_position]
	var direction = Vector2i.UP if piece == 'P' else Vector2i.DOWN
	var base_position = 6 if piece == 'P' else 1
	var valid_positions: Array[Vector2i] = []
	
	var target_position = from_position + direction
	if not is_position_occupied(target_position, board):
		valid_positions.append(target_position)
	
	if from_position.y == base_position:
		target_position = from_position + (direction * 2)
		if not is_position_occupied(target_position, board):
			valid_positions.append(target_position)
	
	var diagonal_positions = [from_position + direction + Vector2i.RIGHT, from_position + direction + Vector2i.LEFT]
	for position in diagonal_positions:
		if is_position_occupied(position, board):
			if are_different_colors(piece, board[position]):
				valid_positions.append(position)
	return valid_positions

func is_position_occupied(position: Vector2i, board: Dictionary) -> bool:
	return position in board and board[position] != null

func are_different_colors(piece1: String, piece2: String) -> bool:
	var black_pieces = 'qkrnbp'
	return (piece1 in black_pieces and piece2 not in black_pieces) or (piece1 not in black_pieces and piece2 in black_pieces)
