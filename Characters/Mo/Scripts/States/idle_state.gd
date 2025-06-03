class_name IdleState
extends State


static func get_state_name() -> int:
	return StatesConstants.State.IDLE

func enter() -> void:
	super()
	sm.state_core_entity.animation_player.play(StatesConstants.ANIM.IDLE)
	sm.state_core_entity.clear_target_point()

func exit() -> void:
	self.core_entity().clear_nav_line()

func do(_delta: float) -> void:
	pass

func handle_input(event: InputEvent) -> void:
	super(event)

#	TODO: Заполнять всю очередь состояний из расчёта, возможно вынести на уровень контроллера
	if event.is_action_pressed("mouse_click") and is_possible_path():
		var core: StateCoreEntity = self.core_entity()

		core.set_target_path(calculate_path())

		sm.change_state(StatesConstants.State.RUN)

func handle_mouse_entered_tile(_tile_index: Vector2i) -> void:
	var core: StateCoreEntity = self.core_entity()
  
	var path: Array[Vector2] = calculate_path()

	core.draw_nav_line(path)

func handle_mouse_exit_map() -> void:
	super()

	var core: StateCoreEntity = self.core_entity()
	core.clear_nav_line()

func is_possible_path() -> bool:
	var path: Array[Vector2] = calculate_path()
	
	return path.size() > 0

func calculate_path() -> Array[Vector2]:
	var core: StateCoreEntity = self.core_entity()

	return core.a_star_grid.calculate(core.position, core.get_mouse_position())
