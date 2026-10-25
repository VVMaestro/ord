class_name StateCoreEntity
extends CharacterBody2D

var animation_player: AnimationPlayer

var state_machine: StateMachine

var state_factory: StateFactory

var sprite: Sprite2D

var nav_line: Line2D

@export
var a_star_grid: AStar

@export
var move_speed: int = 40

@export
var tile_map: TileMapLayer

var path: Array[Vector2] = []

var cur_move_step: int = 0

signal path_ended

signal new_path_cell(cell_type: StringName)

func _ready() -> void:
	animation_player = $AnimationPlayer
	sprite = $Sprite2D
	state_machine = StateMachine.new(self, get_states())
	state_factory = StateFactory.new(get_states())

	nav_line = Line2D.new()
	nav_line.width = 2.0

	add_child(nav_line)

func set_target_path(new_path: Array[Vector2]) -> void:
	path = new_path

func clear_target_point() -> void:
	path = []
	cur_move_step = 0

func get_mouse_position() -> Vector2:
	return get_global_mouse_position()

func get_states() -> Array[Script]:
	return []

func is_state(state: StatesConstants.State) -> bool:
	return state_machine.current_state.get_state_name() == state

func turn_left() -> void:
	sprite.flip_h = true

func turn_right() -> void:
	sprite.flip_h = false

# TODO: По координатам тайлов вычислять наличие в точке объектов (персонажей или др.)
func load_states(target_tile: Vector2i) -> void:
	var full_path := calculate_path_to(target_tile)

	# TODO: Каждому тайлу - один экземпляр состояния, если новое состояние совпадает со старым, то не переключать анимацию
	for tile in full_path:
		var tile_type: = a_star_grid.get_tile_type(tile)
		var state = state_factory.get_state_by_tile_type(tile_type).new()

		state_machine.add_state_to_queue(state)

	state_machine.add_state_to_queue(state_factory.get_state(StatesConstants.State.IDLE).new(state_machine))

func calculate_path_to(tile_cell: Vector2i) -> Array[Vector2i]:
	var entity_tile := get_entity_tile()

	return a_star_grid.calculate_in_tiles(entity_tile, tile_cell)

func get_entity_tile() -> Vector2i:
	return a_star_grid.transform_global_to_map(position)
