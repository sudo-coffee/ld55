class_name LDUnit extends Node2D

@export var can_be_held: bool = false
@export var unit_layer: int = 0
@export var unit_type: StringName
@export var atlas_sprite: Sprite2D
@export var UIName: String = ""
@export_multiline  var UIHelp: String = ""
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


func _init():
    if not is_node_ready():
        await ready
    z_index = grid_position.y * 10 + 10 + unit_layer
    if atlas_sprite and atlas_sprite.texture is AtlasTexture:
        atlas_sprite.texture.region.position.x = instance * 16


func move(direction: Vector2i, move_time: float) -> void:
    is_moving = true
    position = Vector2(grid_position * grid.cell_size)
    _grid_position += direction
    var tween := get_tree().create_tween()
    if direction.y == 1:
        tween.tween_property(self, "z_index", grid_position.y * 10 + 10 + unit_layer, 0)
    tween.tween_property(self, "position", Vector2(grid_position * grid.cell_size), move_time)
    if direction.y == -1:
        tween.tween_property(self, "z_index", grid_position.y * 10 + 10 + unit_layer, 0)
    tween.tween_property(self, "is_moving", false, 0)


func _set_grid_position(value) -> void:
    _grid_position = value
    position = Vector2(_grid_position * grid.cell_size)


# Override. Called from player.gd.
func on_hold():
    if atlas_sprite:
        atlas_sprite.offset.y = -17


# Override. Called from player.gd.
func on_release():
    if atlas_sprite:
        atlas_sprite.offset.y = -16


# Override. Called from player.gd.
func on_create():
    pass


# Override. Called from main.gd.
func on_delete():
    pass
