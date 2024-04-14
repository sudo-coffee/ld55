class_name LDGrid extends Node2D

@export var grid_size: Vector2i
@export var cell_size: Vector2i

var units: Array[LDUnit]


func add_unit(unit: LDUnit, instance: int, pos: Vector2i) -> void:
    if not is_node_ready():
        await ready
    unit.grid = self
    unit.instance = instance
    unit.grid_position = pos
    add_child(unit)
    units.append(unit)


func remove_unit(unit: LDUnit):
    units.remove_at(units.find(unit))
    remove_child(unit)
    


func cell_in_wall(pos: Vector2i) -> bool:
    if pos.x < 0 or pos.x >= grid_size.x or pos.y < 0 or pos.y >= grid_size.y:
        return true
    return false


func get_units_in_cell(pos: Vector2i) -> Array[LDUnit]:
    return units.filter(func(unit): return unit.grid_position == pos)
