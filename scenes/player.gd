extends LDUnit

@onready var _sprite: Sprite2D = $Sprite2D
var _move_speed: float = 0.1
var _direction := Vector2i(0, 1)
var _buffer_direction := Vector2i(0, 0)
var _held_tool: LDTool
var _player_up_texture: Resource = preload("res://assets/player_up.png")
var _player_down_texture: Resource = preload("res://assets/player_down.png")
var _player_left_texture: Resource = preload("res://assets/player_left.png")
var _player_right_texture: Resource = preload("res://assets/player_right.png")


func _process(_delta):
    _process_movement()


func _input(event):
    if event.is_action_pressed("hold_tool") and not _held_tool:
        var tools_in_direction: Array[LDTool] = grid.get_tools_in_cell(grid_position + _direction)
        print(_direction)
        print(tools_in_direction)
        if tools_in_direction.size() > 0:
            tools_in_direction.sort_custom(func(a, b): return a.hold_priority > b.hold_priority)
            _held_tool = tools_in_direction[0]
    
    if event.is_action_released("hold_tool"):
        _held_tool = null


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
    if not _held_tool and new_direction == Vector2i(0, -1):
        _sprite.texture = _player_up_texture
    if not _held_tool and new_direction == Vector2i(0, 1):
        _sprite.texture = _player_down_texture
    if not _held_tool and new_direction == Vector2i(-1, 0):
        _sprite.texture = _player_left_texture
    if not _held_tool and new_direction == Vector2i(1, 0):
        _sprite.texture = _player_right_texture
    
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
    if _held_tool and grid.cell_in_wall(_held_tool.grid_position + _direction):
        return
    
    # Do not move into other units.
    if grid.get_units_in_cell(grid_position + _direction).filter(func(unit): return unit != _held_tool).size() > 0:
        return
    if _held_tool and grid.get_units_in_cell(_held_tool.grid_position + _direction).filter(func(unit): return unit != self).size() > 0:
        return
    
    _buffer_direction = Vector2i(0, 0)
    move(_direction, _move_speed)
    if _held_tool:
        _held_tool.move(_direction, _move_speed)
