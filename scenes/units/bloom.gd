extends LDUnit

@export var growth_interval: float = 3.0 # In hours.
@export var mana_gain: float = 10.0
@export var spout_multiplier: float = 2.0
@onready var last_unit_time: float = LDState.unit_time
var stage: int = 0
var growth: float = 0.0
var growth_multiplier: float = 0.0


func _process(_delta):
    growth += (LDState.unit_time - last_unit_time) / growth_interval * growth_multiplier
    last_unit_time = LDState.unit_time
    if growth >= 1.0 and stage < 4:
        growth = 0.0
        stage += 1
        $Sprite2D.texture.region.position.y = stage * 32


func on_release():
    reset_growth_multiplier()


func on_hold():
    growth_multiplier = 0.0
    if stage == 4:
        LDState.mana += mana_gain
        grid.units.filter(func(unit): return unit.unit_type == &"player")[0].held_unit = null
        grid.remove_unit(self)


func reset_growth_multiplier():
    if grid.get_units_in_cell(grid_position).filter(func(unit): return unit.unit_type == &"pot" and unit.is_held == false).size() > 0:
        growth_multiplier = 1.0
    if grid.get_units_in_cell(grid_position + Vector2i(1, 0)).filter(func(unit): return unit.unit_type == &"spout" and unit.is_held == false).size() > 0:
        growth_multiplier *= spout_multiplier
    if grid.get_units_in_cell(grid_position + Vector2i(0, 1)).filter(func(unit): return unit.unit_type == &"spout" and unit.is_held == false).size() > 0:
        growth_multiplier *= spout_multiplier
    if grid.get_units_in_cell(grid_position + Vector2i(-1, 0)).filter(func(unit): return unit.unit_type == &"spout" and unit.is_held == false).size() > 0:
        growth_multiplier *= spout_multiplier
    if grid.get_units_in_cell(grid_position + Vector2i(0, -1)).filter(func(unit): return unit.unit_type == &"spout" and unit.is_held == false).size() > 0:
        growth_multiplier *= spout_multiplier
