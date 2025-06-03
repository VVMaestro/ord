class_name AStar
extends Node2D

@export
var tile_map: TileMapLayer

var a_star_grid: AStarGrid2D

func _ready() -> void:
	var tilemap_rect: Rect2i = tile_map.get_used_rect()
	var tile_size: Vector2i = tile_map.tile_set.tile_size

	a_star_grid = AStarGrid2D.new()

	a_star_grid.region = tilemap_rect
	a_star_grid.cell_size = Vector2(tile_size)
	a_star_grid.update()

	var used_cells: Array[Vector2i] = tile_map.get_used_cells()

	for cell in used_cells:
		assert(a_star_grid.is_in_boundsv(cell), "Tile map cell not in A* rect bounds")

		var cell_tile_data: TileData = tile_map.get_cell_tile_data(cell)

		if cell_tile_data.get_custom_data(TilemapConstants.CUSTOM_TYPE) == TilemapConstants.CUSTOM_TYPE_OBST:
			a_star_grid.set_point_solid(cell, true)

func calculate(global_from: Vector2, global_to: Vector2) -> Array[Vector2]:
	var local_from: Vector2 = to_local(global_from)
	var local_to: Vector2 = to_local(global_to)

	var map_from: Vector2i = tile_map.local_to_map(local_from)
	var map_to: Vector2i = tile_map.local_to_map(local_to)

	var path: Array[Vector2i] = a_star_grid.get_id_path(map_from, map_to)

	var global_path: Array[Vector2] = []

	for path_id in path:
		global_path.push_back(to_global(tile_map.map_to_local(path_id)))

	return global_path
