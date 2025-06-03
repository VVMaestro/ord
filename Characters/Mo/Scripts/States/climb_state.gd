class_name ClimbState
extends MoveState

static func get_state_name() -> int:
  return StatesConstants.State.CLIMB

func enter() -> void:
  sm.state_core_entity.animation_player.play(StatesConstants.ANIM.CLIMB)

func do(delta: float) -> void:
  super.do(delta)
