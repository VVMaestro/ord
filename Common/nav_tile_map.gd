class_name NavTileMap
extends TileMapLayer

signal entered_map

signal exit_map

signal entered_tile(tile_index: Vector2i)

signal clicked_tile(tile_index: Vector2i)

var is_on_map: bool = false

var last_tile_index: Vector2i = Vector2i(-1, -1)

var nav_line: Line2D

@export
var a_star_grid: AStar

@export
var core_entity: StateCoreEntity

var input_event_processor: InputEventProcessor

func _ready() -> void:
	input_event_processor = InputEventProcessor.new()
	input_event_processor.add_strategy(InputEventMouseMotion.new(), process_mouse_motion_event)
	input_event_processor.add_strategy(InputEventMouseButton.new(), process_mouse_button_event)

	nav_line = Line2D.new()
	nav_line.width = 2.0

	add_child(nav_line)

func _input(event: InputEvent) -> void:
	input_event_processor.process(event)

func process_mouse_motion_event() -> void:
	var tile_index: Vector2i = get_tile_index()

	if not is_on_map and is_tile():
		is_on_map = true

		entered_map.emit()

	if is_tile() and tile_index != last_tile_index:
		last_tile_index = tile_index
		
		process_navigation_line_draw()

		entered_tile.emit(tile_index)

	if is_on_map and not is_tile():
		is_on_map = false

		last_tile_index = Vector2i(-1, -1)
		
		clear_nav_line()
		exit_map.emit()
		
func process_mouse_button_event(input_event: InputEventMouseButton) -> void:
	var tile_index: Vector2i = get_tile_index()
	
	if input_event.button_mask == MouseButtonMask.MOUSE_BUTTON_MASK_LEFT and is_tile():
		clicked_tile.emit(tile_index)

func is_tile() -> bool:
	var point_map_position: Vector2i = get_tile_index()

	var tile_data: TileData = get_cell_tile_data(point_map_position)

	return tile_data is TileData
	
func process_navigation_line_draw():
	var path := calculate_path()
	
	if path.size() > 0 and core_entity.is_state(StatesConstants.State.IDLE):
		draw_nav_line(path)

func get_tile_index() -> Vector2i:
	var point: Vector2 = get_local_mouse_position()
	
	return local_to_map(point)
	
func draw_nav_line(line_path: Array[Vector2]) -> void:
	clear_nav_line()

	for point in line_path:
		nav_line.add_point(to_local(point))

func clear_nav_line() -> void:
	nav_line.clear_points()
	
func calculate_path() -> Array[Vector2]:
	return a_star_grid.calculate_in_global(core_entity.position, get_global_mouse_position())
