extends LDGrid

var _player_scene: Resource = preload("res://scenes/player.tscn")
var _altar_scene: Resource = preload("res://scenes/altar.tscn")
var _tool_pot_a_scene: Resource = preload("res://scenes/tool_pot_a.tscn")


func _init():
    add_unit(_player_scene.instantiate(), Vector2i(0, 0))
    add_unit(_tool_pot_a_scene.instantiate(), Vector2i(4, 4))
    add_unit(_altar_scene.instantiate(), Vector2i(3, 3))

