extends TileMapLayer

signal entered_map

signal exit_map

signal entered_tile(tile_index: Vector2i)

var is_on_map: bool = false

var last_tile_index: Vector2i = Vector2i(-1, -1)

func _input(event: InputEvent) -> void:
	if not event is InputEventMouseMotion:
		return

	var tile_index: Vector2i = get_tile_index()

	if not is_on_map and is_tile():
		is_on_map = true

		entered_map.emit()

	if is_tile() and tile_index != last_tile_index:
		last_tile_index = tile_index

		entered_tile.emit(tile_index)

	if is_on_map and not is_tile():
		is_on_map = false

		last_tile_index = Vector2i(-1, -1)
		exit_map.emit()

func is_tile() -> bool:
	var point_map_position: Vector2i = get_tile_index()

	var tile_data: TileData = get_cell_tile_data(point_map_position)

	return tile_data is TileData

func get_tile_index() -> Vector2i:
	var point: Vector2 = get_local_mouse_position()
	return local_to_map(point)
