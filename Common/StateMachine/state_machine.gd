class_name StateMachine
extends Node2D

var state_factory: StateFactory

var current_state: State

var state_core_entity: StateCoreEntity

var state_queue: StateQueue

func _init(core_entity: StateCoreEntity, states: Array[Script]) -> void:
	state_core_entity = core_entity
	state_factory = StateFactory.new(states)

	state_queue = StateQueue.new([])

func do(delta: float) -> void:
	current_state.do(delta)

func handle_input(event: InputEvent) -> void:
	current_state.handle_input(event)

func handle_mouse_enter_map() -> void:
	current_state.handle_mouse_enter_map()

func handle_mouse_exit_map() -> void:
	current_state.handle_mouse_exit_map()

func handle_mouse_entered_tile(tile_index: Vector2i) -> void:
	current_state.handle_mouse_entered_tile(tile_index)

func add_state_to_queue(new_state: int) -> void:
	state_queue.push(new_state)

func next_state() -> void:
	if state_queue.size() == 0:
		change_state(StatesConstants.State.IDLE)

func change_state(new_state_name: int) -> void:
	if current_state != null:
		current_state.state_ended.disconnect(_on_current_state_ended)

		current_state.exit()
		current_state.queue_free()

	if is_queued_for_deletion():
		return

	current_state = state_factory.get_state(new_state_name).new(self)

	current_state.state_ended.connect(_on_current_state_ended)

	add_child.call(current_state)
	current_state.enter()

func _on_current_state_ended():
	next_state()
