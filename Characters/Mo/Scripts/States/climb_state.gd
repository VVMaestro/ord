class_name ClimbState
extends MoveState

func get_state_name() -> StatesConstants.State:
	return StatesConstants.State.CLIMB
	
static func get_static_state_name() -> StatesConstants.State:
	return StatesConstants.State.CLIMB

func enter() -> void:
	sm.state_core_entity.animation_player.play(StatesConstants.ANIM.CLIMB)

func do(delta: float) -> void:
	super.do(delta)
