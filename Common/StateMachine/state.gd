class_name State
extends Node2D


var sm: StateMachine

signal state_ended

func _init(state_machine: StateMachine) -> void:
	sm = state_machine

func enter() -> void:
	pass

func exit() -> void:
	pass

func do(_delta: float) -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass

func handle_mouse_entered_tile(_tile_index: Vector2i) -> void:
	pass

func handle_mouse_enter_map() -> void:
	pass

func handle_mouse_exit_map() -> void:
	pass

func core_entity() -> StateCoreEntity:
	return sm.state_core_entity

static func get_state_name() -> int:
	return StatesConstants.State.BASE
