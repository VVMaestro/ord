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
	a_star_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_AT_LEAST_ONE_WALKABLE
	a_star_grid.update()

	var used_cells: Array[Vector2i] = tile_map.get_used_cells()

	for cell in used_cells:
		assert(a_star_grid.is_in_boundsv(cell), "Tile map cell not in A* rect bounds")

		var cell_tile_type := get_tile_type(cell)

		if cell_tile_type == TilemapConstants.TileType.OBST:
			a_star_grid.set_point_solid(cell, true)
			
func get_tile_type(tile_cell: Vector2i) -> TilemapConstants.TileType:
	var cell_tile_data: TileData = tile_map.get_cell_tile_data(tile_cell)
	
	return cell_tile_data.get_custom_data(TilemapConstants.TILE_TYPE_KEY)

func is_in_bounds(point: Vector2) -> bool:
	var local_point: Vector2 = to_global(point)
	var map_point: Vector2i = tile_map.local_to_map(local_point)

	return a_star_grid.is_in_boundsv(map_point)

func calculate_in_global(global_from: Vector2, global_to: Vector2) -> Array[Vector2]:
	var local_from: Vector2 = to_local(global_from)
	var local_to: Vector2 = to_local(global_to)

	var map_from: Vector2i = tile_map.local_to_map(local_from)
	var map_to: Vector2i = tile_map.local_to_map(local_to)

	var path: Array[Vector2i] = calculate_in_tiles(map_from, map_to)

	var global_path: Array[Vector2] = []

	for path_id in path:
		global_path.push_back(to_global(tile_map.map_to_local(path_id)))

	return global_path

func calculate_in_tiles(tile_cell_from: Vector2i, tile_cell_to: Vector2i) -> Array[Vector2i]:
	return a_star_grid.get_id_path(tile_cell_from, tile_cell_to)
	
func transform_global_to_map(global_point: Vector2) -> Vector2i:
	var local_point: Vector2 = to_local(global_point)
	return tile_map.local_to_map(local_point)
