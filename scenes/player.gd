extends LDUnit

@onready var _sprite: Sprite2D = $Sprite2D
var _move_time: float = 0.1
var _cooldown_time: float = 0.02
var _direction := Vector2i(0, 1)
var _sprite_direction := Vector2i(0, 1)
var _buffer_direction := Vector2i(0, 0)
var _held_unit: LDUnit


func _process(_delta):
    _process_movement()


func _input(event):
    if event.is_action_pressed("hold_unit") and not _held_unit:
        var units_in_direction: Array[LDUnit] = grid.get_units_in_cell(grid_position + _sprite_direction)
        print(units_in_direction)
        units_in_direction = units_in_direction.filter(func(unit): return unit.can_be_held)
        units_in_direction.sort_custom(func(a, b): return a.layer > b.layer)
        if units_in_direction.size() > 0:
            _held_unit = units_in_direction[0]
    
    if event.is_action_released("hold_unit") and _held_unit:
        _held_unit = null


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


func _move_player(direction: Vector2i) -> void:
    _direction = direction
    var units_in_direction: Array[LDUnit] = grid.get_units_in_cell(grid_position + _direction)
    
    # Do not move into wall.
    if grid.cell_in_wall(grid_position + _direction):
        return
    if _held_unit and grid.cell_in_wall(_held_unit.grid_position + _direction):
        return
    
    # Do not move into layer 0 or 1 units.
    if grid.get_units_in_cell(grid_position + _direction).filter(func(unit): return unit.layer <= 1 and unit != _held_unit).size() > 0:
        return
    
    # Do not move held unit into other units in the same layer.
    if _held_unit and grid.get_units_in_cell(_held_unit.grid_position + _direction).filter(func(unit): return _held_unit.layer == unit.layer).size() > 0:
        return
    
    _buffer_direction = Vector2i(0, 0)
    move(_direction, _move_time)
    if _held_unit:
        _held_unit.move(_direction, _move_time)
