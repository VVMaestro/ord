class_name RunState
extends MoveState

func get_state_name() -> StatesConstants.State:
	return StatesConstants.State.RUN
	
static func get_static_state_name() -> StatesConstants.State:
	return StatesConstants.State.RUN

func enter() -> void:
	sm.state_core_entity.animation_player.play(StatesConstants.ANIM.RUN)

func do(delta: float) -> void:
	super.do(delta)
