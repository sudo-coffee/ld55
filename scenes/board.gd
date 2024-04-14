extends LDGrid

var _player_scene: Resource = preload("res://scenes/units/player.tscn")
var _altar_scene: Resource = preload("res://scenes/units/altar.tscn")
var _stand_scene: Resource = preload("res://scenes/units/stand.tscn")
var _pot_scene: Resource = preload("res://scenes/units/pot.tscn")
var _orb_scene: Resource = preload("res://scenes/units/orb.tscn")
var _vault_scene: Resource = preload("res://scenes/units/vault.tscn")
var _clock_scene: Resource = preload("res://scenes/units/clock.tscn")
var _bloom_scene: Resource = preload("res://scenes/units/bloom.tscn")
var _spout_scene: Resource = preload("res://scenes/units/spout.tscn")
var player: LDUnit


func _init():
    player = create_unit("player", 0, Vector2i(4, 4))
    create_unit("pot", 0, Vector2i(1, 0))
    create_unit("pot", 1, Vector2i(7, 0))
    create_unit("pot", 2, Vector2i(0, 1))
    create_unit("pot", 3, Vector2i(8, 1))
    create_unit("pot", 4, Vector2i(0, 7))
    create_unit("pot", 5, Vector2i(8, 7))
    create_unit("pot", 6, Vector2i(1, 8))
    create_unit("pot", 7, Vector2i(7, 8))
    create_unit("spout", 0, Vector2i(0, 0))
    create_unit("spout", 1, Vector2i(0, 8))
    create_unit("spout", 2, Vector2i(8, 0))
    create_unit("spout", 3, Vector2i(8, 8))
    create_unit("vault", 0, Vector2i(0, 3))
    create_unit("vault", 1, Vector2i(0, 5))
    create_unit("vault", 2, Vector2i(8, 3))
    create_unit("vault", 3, Vector2i(8, 5))
    create_unit("orb", 0, Vector2i(3, 0))
    create_unit("orb", 1, Vector2i(5, 0))
    create_unit("clock", 0, Vector2i(3, 8))
    create_unit("clock", 1, Vector2i(5, 8))
    create_unit("stand", 0, Vector2i(6, 4))
    create_unit("altar", 0, Vector2i(2, 4))


func create_unit(unit_type: StringName, instance: int, pos: Vector2i) -> LDUnit:
    var unit: LDUnit
    match unit_type:
        &"altar": unit = _altar_scene.instantiate()
        &"stand": unit = _stand_scene.instantiate()
        &"player": unit = _player_scene.instantiate()
        &"pot": unit = _pot_scene.instantiate()
        &"orb": unit = _orb_scene.instantiate()
        &"vault": unit = _vault_scene.instantiate()
        &"clock": unit = _clock_scene.instantiate()
        &"spout": unit = _spout_scene.instantiate()
        &"bloom": unit = _bloom_scene.instantiate()
    assert(unit, "No matching unit types for unit_type " + str(unit_type))
    add_unit(unit, instance, pos)
    return unit
