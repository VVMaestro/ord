class_name MoController
extends StateCoreEntity

var state_machine: StateMachine

func _ready() -> void:
	super()

	state_machine = StateMachine.new(self, get_states())

	state_machine.change_state(IdleState.get_state_name())

func _process(delta: float) -> void:
	state_machine.do(delta)

func _input(event: InputEvent) -> void:
	state_machine.handle_input(event)

func get_states() -> Array[Script]:
	return [
		IdleState,
		RunState
	]

func _on_mouse_entered_map() -> void:
	state_machine.handle_mouse_enter_map()

func _on_mouse_exit_map() -> void:
	state_machine.handle_mouse_exit_map()

func _on_mouse_entered_tile(tile_index: Vector2i) -> void:
	state_machine.handle_mouse_entered_tile(tile_index)
