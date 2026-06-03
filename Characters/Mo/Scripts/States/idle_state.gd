class_name IdleState
extends State


func get_state_name() -> StatesConstants.State:
	return StatesConstants.State.IDLE
	
static func get_static_state_name() -> StatesConstants.State:
	return StatesConstants.State.IDLE

func enter() -> void:
	super()
	sm.state_core_entity.animation_player.play(StatesConstants.ANIM.IDLE)
	sm.state_core_entity.clear_target_point()

func exit() -> void:
	pass

func do(_delta: float) -> void:
	pass

func handle_input(event: InputEvent) -> void:
	super(event)

#	TODO: Заполнять всю очередь состояний из расчёта, возможно вынести на уровень контроллера
	if event.is_action_pressed("mouse_click") and is_possible_path():
		var core: StateCoreEntity = self.core_entity()

		core.set_target_path(calculate_path())

		sm.change_state(StatesConstants.State.RUN)

func is_possible_path() -> bool:
	var path: Array[Vector2] = calculate_path()
	
	return path.size() > 0

func calculate_path() -> Array[Vector2]:
	var core: StateCoreEntity = self.core_entity()

	return core.a_star_grid.calculate_in_global(core.position, core.get_mouse_position())
