class_name LDUnit extends Node2D

@export var can_be_held: bool = false
@export var unit_layer: int = 0
@export var unit_type: StringName
var was_summoned: bool = false
var was_copied: bool = false
var grid: LDGrid
var instance: int
var is_moving: bool = false
var is_held: bool = false
var grid_position: Vector2i:
    set(value): _set_grid_position(value)
    get: return _grid_position

var _grid_position: Vector2i


func move(direction: Vector2i, move_time: float) -> void:
    is_moving = true
    position = Vector2(grid_position * grid.cell_size)
    _grid_position += direction
    var tween := get_tree().create_tween()
    tween.tween_property(self, "position", Vector2(grid_position * grid.cell_size), move_time)
    tween.tween_property(self, "is_moving", false, 0)


func _set_grid_position(value) -> void:
    _grid_position = value
    position = Vector2(_grid_position * grid.cell_size)


# Override. Called from player.gd.
func on_hold():
    pass


# Override. Called from player.gd.
func on_release():
    pass


# Override. Called from player.gd.
func on_create():
    pass


# Override. Called from main.gd.
func on_delete():
    pass
