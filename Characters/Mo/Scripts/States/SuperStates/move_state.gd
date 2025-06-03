class_name MoveState
extends State

var last_step_value: int = 2

static func get_state_name() -> int:
  return StatesConstants.State.MOVE

func enter() -> void:
  pass

func do(delta: float) -> void:
  var core: StateCoreEntity = self.core_entity()

  if core.cur_move_step + 1 > core.path.size():
    core.path_ended.emit()

    return

  var current_path: Vector2 = core.path[core.cur_move_step]

  var x: float = move_toward(core.position.x, current_path.x, delta * core.move_speed)
  var y: float = move_toward(core.position.y, current_path.y, delta * core.move_speed)

  if x < core.position.x:
    core.turn_left()
  else:
    core.turn_right()

  if abs(core.position.x - current_path.x) < last_step_value:
    x = current_path.x
  if abs(core.position.y - current_path.y) < last_step_value:
    y = current_path.y

  core.position = Vector2(x, y)

  var cell_coords: Vector2i = core.tile_map.local_to_map(core.position)

  var cell_tile_data: TileData = core.tile_map.get_cell_tile_data(cell_coords)

  if cell_tile_data.get_custom_data(TilemapConstants.CUSTOM_TYPE) == TilemapConstants.CUSTOM_TYPE_CLIMB:
    core.new_path_cell.emit(TilemapConstants.CUSTOM_TYPE_CLIMB)

  if current_path == core.position:
    core.cur_move_step += 1
