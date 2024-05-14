class_name RunState
extends State

var current_step = 0

var run_speed = 40

var last_step_value = 2

static func get_state_name() -> StringName:
  return "run"

func enter() -> void:
  sm.state_core_entity.animation_player.play("run")

func do(delta: float) -> void:
  var core = self.core_entity()

  if current_step + 1 > core.path.size():
    sm.change_state("idle")

    return

  var current_path: Vector2 = core.path[current_step]

  if current_path.x > core.position.x:
    core.turn_right()
  elif current_path.x < core.position.x:
    core.turn_left()

  var x = move_toward(core.position.x, current_path.x, delta * run_speed)
  var y = move_toward(core.position.y, current_path.y, delta * run_speed)

  if abs(core.position.x - current_path.x) < last_step_value:
    x = current_path.x
  if abs(core.position.y - current_path.y) < last_step_value:
    y = current_path.y

  core.position = Vector2(x, y)

  if current_path == core.position:
    current_step += 1
