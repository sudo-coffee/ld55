extends LDUnit

@export var _move_time: float = 0.1
@export var _animation_time: float = 1.0
@onready var _sprite: Sprite2D = $Sprite2D
var _direction := Vector2i(0, 1)
var _sprite_direction := Vector2i(0, 1)
var _buffer_direction := Vector2i(0, 0)
var _held_unit: LDUnit
var held_unit: LDUnit:
    set(value): _held_unit = value
    get: return _held_unit

signal looking_at(units: LDUnit)


func _init():
    _start_animation()


func _start_animation():
    if not is_node_ready():
        await ready
    var animation_tween := get_tree().create_tween()
    animation_tween.set_loops()
    animation_tween.tween_interval(_animation_time)
    animation_tween.tween_callback(_update_animation)


func _update_animation():
    _sprite.texture.region.position.y = int(_sprite.texture.region.position.y + 32) % 128


func _process(_delta):
    _process_movement()


func _input(event):
    if event.is_action_pressed("action") and not _held_unit:
        var units_in_direction: Array[LDUnit] = grid.get_units_in_cell(grid_position + _sprite_direction)
        units_in_direction.sort_custom(func(a, b): return a.unit_layer > b.unit_layer)
        if units_in_direction.size() > 0:
            _process_action(units_in_direction[0])
    
    if event.is_action_released("action") and _held_unit:
        _held_unit.is_held = false
        _held_unit.on_release()
        _held_unit = null


func _process_action(unit: LDUnit) -> void:
    # Summon unit.
    if unit.unit_type == &"stand":
        var altar: LDUnit = grid.units.filter(func(unit): return unit.unit_type == &"altar")[0]
        var altar_units: Array[LDUnit] = grid.get_units_in_cell(altar.grid_position).filter(func(unit): return unit.unit_layer > 0)
        altar_units.sort_custom(func(a, b): return a.unit_layer > b.unit_layer)
        if altar_units.size() > 0 and not altar_units[0].was_copied and not altar_units[0].was_summoned:
            var new_unit: LDUnit = grid.create_unit(altar_units[0].unit_type, altar_units[0].instance, unit.grid_position)
            new_unit.was_summoned = true
            new_unit.on_create()
            altar_units[0].was_copied = true
            _held_unit = new_unit
            _held_unit.on_hold()
            LDState.add_summon(altar_units[0].unit_type, altar_units[0].instance)
            if new_unit.unit_type == &"bloom":
                new_unit.stage = altar_units[0].stage
                new_unit.growth = altar_units[0].growth
                new_unit.update_sprite()
        elif unit.can_be_held:
            _held_unit = unit
            _held_unit.is_held = true
            _held_unit.on_hold()
    
    # Grab unit.
    elif unit.can_be_held:
        _held_unit = unit
        _held_unit.is_held = true
        _held_unit.on_hold()



func _process_movement() -> void:
    var new_direction := Vector2i(0, 0)
    if Input.is_action_pressed("move_up"):
        new_direction += Vector2i(0, -1)
    if Input.is_action_pressed("move_down"):
        new_direction += Vector2i(0, 1)
    if Input.is_action_pressed("move_left"):
        new_direction += Vector2i(-1, 0)
    if Input.is_action_pressed("move_right"):
        new_direction += Vector2i(1, 0)
    
    # Set player sprites.
    if not _held_unit and new_direction == Vector2i(0, -1):
        _sprite.texture.region.position.x = 0
        _sprite_direction = Vector2i(0, -1)
    if not _held_unit and new_direction == Vector2i(0, 1):
        _sprite.texture.region.position.x = 16
        _sprite_direction = Vector2i(0, 1)
    if not _held_unit and new_direction == Vector2i(-1, 0):
        _sprite.texture.region.position.x = 32
        _sprite_direction = Vector2i(-1, 0)
    if not _held_unit and new_direction == Vector2i(1, 0):
        _sprite.texture.region.position.x = 48
        _sprite_direction = Vector2i(1, 0)
    
    # If moving vertically, prefer moving vertically.
    if _direction.x == 0 and new_direction.x != 0 and new_direction.y != 0:
        new_direction.x = 0
    
    # If moving horizontally, prefer moving horizontally.
    if _direction.y == 0 and new_direction.x != 0 and new_direction.y != 0:
        new_direction.y = 0
    
    # Input direction movement.
    if not is_moving and new_direction != Vector2i(0, 0):
        _move_player(new_direction)
    
    # Buffer direction movement.
    elif not is_moving and _buffer_direction != Vector2i(0, 0):
        _move_player(_buffer_direction)
    
    # If currently moving, and input is different than current movement, then
    # store the new direction for later.
    elif is_moving and new_direction != Vector2i(0, 0) and new_direction != _direction:
        _buffer_direction = new_direction
    
    # Update info boxes.
    LDState.interface.update_info_boxes(grid.get_units_in_cell(grid_position + _sprite_direction))


func _move_player(direction: Vector2i) -> void:
    _direction = direction
    looking_at.emit(grid.get_units_in_cell(grid_position + _direction))
    
    # Do not move into wall.
    if grid.cell_in_wall(grid_position + _direction):
        return
    if _held_unit and grid.cell_in_wall(_held_unit.grid_position + _direction):
        return
    
    # Do not move into layer other units.
    if grid.get_units_in_cell(grid_position + _direction).filter(func(unit): return unit.unit_layer <= 2 and unit != _held_unit).size() > 0:
        return
    
    # Do not move held unit into other units in the same layer.
    if _held_unit and grid.get_units_in_cell(_held_unit.grid_position + _direction).filter(func(unit): return _held_unit.unit_layer == unit.unit_layer).size() > 0:
        return
    
    _buffer_direction = Vector2i(0, 0)
    move(_direction, _move_time)
    if _held_unit:
        _held_unit.move(_direction, _move_time)
    
