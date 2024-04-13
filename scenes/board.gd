extends LDGrid

var player_scene: Resource = preload("res://scenes/player.tscn")
var tool_pot_a_scene: Resource = preload("res://scenes/tool_pot_a.tscn")


func _init():
    add_unit(player_scene.instantiate(), Vector2i(0, 0))
    add_unit(tool_pot_a_scene.instantiate(), Vector2i(4, 4))

