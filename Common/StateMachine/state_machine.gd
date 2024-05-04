class_name StateMachine
extends Node2D

var state_factory: StateFactory

var state: State

var state_core_entity: StateCoreEntity

func _init(core_entity: StateCoreEntity, states: Array[Script]) -> void:
	state_core_entity = core_entity
	state_factory = StateFactory.new(states)

func do(delta: float) -> void:
	state.do(delta)

func handle_input(event: InputEvent) -> void:
	state.handle_input(event)

func handle_mouse_enter_map() -> void:
	state.handle_mouse_enter_map()

func handle_mouse_exit_map() -> void:
	state.handle_mouse_exit_map()

func handle_mouse_entered_tile(tile_index: Vector2i) -> void:
	state.handle_mouse_entered_tile(tile_index)

func change_state(new_state_name: StringName) -> void:
	if state != null:
		state.exit()
		state.queue_free()

	if is_queued_for_deletion():
		return

	state = state_factory.get_state(new_state_name).new(self)

	add_child.call(state)
	state.enter()
