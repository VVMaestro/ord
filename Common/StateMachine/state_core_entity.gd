class_name StateCoreEntity
extends CharacterBody2D

var animation_player: AnimationPlayer
var nav_line: Line2D

@onready
var sprite: Sprite2D = $Sprite2D

@export
var a_star_grid: Node2D

var path: Array[Vector2] = []

func _ready() -> void:
  animation_player = $AnimationPlayer

  nav_line = Line2D.new()
  nav_line.width = 2.0

  add_child(nav_line)

func set_target_path(new_path: Array[Vector2]) -> void:
  path = new_path

func clear_target_point() -> void:
  path = []

func get_mouse_position() -> Vector2:
  return get_global_mouse_position()

func get_states() -> Array[Script]:
  return []

func draw_nav_line(line_path: Array[Vector2]) -> void:
  clear_nav_line()

  for point in line_path:
    nav_line.add_point(to_local(point))

func clear_nav_line() -> void:
   nav_line.clear_points()

func turn_left() -> void:
  sprite.flip_h = true

func turn_right() -> void:
  sprite.flip_h = false
