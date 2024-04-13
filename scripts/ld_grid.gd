class_name LDGrid extends Node2D

@export var grid_size: Vector2i
@export var cell_size: Vector2i

var _units: Array[LDUnit]
var _tools: Array[LDTool]


func add_unit(unit: LDUnit, pos: Vector2i) -> void:
    await ready
    unit.grid = self
    unit.grid_position = pos
    add_child(unit)
    _units.append(unit)
    if unit is LDTool:
        _tools.append(unit)


func remove_unit(unit: LDUnit):
    _units.remove_at(_units.find(unit))
    if unit is LDTool:
        _tools.remove_at(_units.find(unit))


func cell_in_wall(pos: Vector2i) -> bool:
    if pos.x < 0 or pos.x >= grid_size.x or pos.y < 0 or pos.y >= grid_size.y:
        return true
    return false


func get_units_in_cell(pos: Vector2i) -> Array[LDUnit]:
    return _units.filter(func(unit): return unit.grid_position == pos)


func get_tools_in_cell(pos: Vector2i) -> Array[LDTool]:
    print(_tools)
    return _tools.filter(func(tool): return tool.grid_position == pos)
