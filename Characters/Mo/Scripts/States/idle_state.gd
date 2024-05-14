class_name IdleState
extends State


static func get_state_name() -> StringName:
	return "idle"

func enter() -> void:
	super()
	sm.state_core_entity.animation_player.play("idle")

func exit() -> void:
	self.core_entity().clear_nav_line()

func do(_delta: float) -> void:
	pass

func handle_input(event: InputEvent) -> void:
	super(event)

	if event.is_action_pressed("mouse_click") and is_possible_path():
		var core = self.core_entity()

		core.set_target_path(calculate_path())

		sm.change_state("run")

func handle_mouse_entered_tile(_tile_index: Vector2i) -> void:
	var core = self.core_entity()
  
	var path: Array[Vector2] = calculate_path()

	core.draw_nav_line(path)

func handle_mouse_exit_map() -> void:
	super()

	var core = self.core_entity()
	core.clear_nav_line()

func is_possible_path() -> bool:
	var core = self.core_entity()
	
	return core.a_star_grid.is_in_bounds(core.get_mouse_position())

func calculate_path() -> Array[Vector2]:
	var core = self.core_entity()

	return core.a_star_grid.calculate(core.position, core.get_mouse_position())
