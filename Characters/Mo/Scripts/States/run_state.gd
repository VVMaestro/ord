class_name RunState
extends MoveState

static func get_state_name() -> int:
  return StatesConstants.State.RUN

func enter() -> void:
  sm.state_core_entity.animation_player.play(StatesConstants.ANIM.RUN)

func do(delta: float) -> void:
  super.do(delta)
