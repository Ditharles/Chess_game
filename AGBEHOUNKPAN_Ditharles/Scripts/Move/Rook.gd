# Rook.gd

extends Node

func generate_valid_positions(from_position: Vector2i, board: Dictionary) -> Array[Vector2i]:
	var valid_positions: Array[Vector2i] = []
	
	for direction in [Vector2i.UP, Vector2i.LEFT, Vector2i.RIGHT, Vector2i.DOWN]:
		var target_position = from_position + direction
		while target_position in board and not is_position_occupied(target_position, board):
			valid_positions.append(target_position)
			target_position += direction
		if target_position in board:
			if are_different_colors(board[from_position], board[target_position]):
				valid_positions.append(target_position)
	return valid_positions

func is_position_occupied(position: Vector2i, board: Dictionary) -> bool:
	return position in board and board[position] != null

func are_different_colors(piece1: String, piece2: String) -> bool:
	var black_pieces = 'qkrnbp'
	return (piece1 in black_pieces and piece2 not in black_pieces) or (piece1 not in black_pieces and piece2 in black_pieces)
