class_name MoController
extends StateCoreEntity

func _ready() -> void:
	super()

	state_machine.change_state(StatesConstants.State.IDLE)

	path_ended.connect(_on_path_ended)

func _process(delta: float) -> void:
	state_machine.do(delta)

func _input(event: InputEvent) -> void:
	state_machine.handle_input(event)

func get_states() -> Array[Script]:
	return [
		IdleState,
		RunState,
		ClimbState
	]

func _on_path_ended() -> void:
	state_machine.change_state(StatesConstants.State.IDLE)
