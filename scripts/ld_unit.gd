class_name LDUnit extends Node2D

var grid: LDGrid
var is_moving: bool = false
var grid_position: Vector2i:
    set(value): _set_grid_position(value)
    get: return _grid_position

var _grid_position: Vector2i


func move(direction: Vector2i, time: float) -> void:
    is_moving = true
    position = Vector2(grid_position * grid.cell_size)
    _grid_position += direction
    var tween := get_tree().create_tween()
    tween.tween_property(self, "position", Vector2(grid_position * grid.cell_size), time)
    tween.tween_property(self, "is_moving", false, 0)


func _set_grid_position(value) -> void:
    _grid_position = value
    position = Vector2(_grid_position * grid.cell_size)