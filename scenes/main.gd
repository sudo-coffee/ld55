extends Node2D

@export var seconds_per_hour: float = 10.0
@export var mana_loss_per_hour: float = 5.0
@onready var _board: Node2D = $Board
var _board_scene: Resource = preload("res://scenes/board.tscn")


func _process(delta):
    LDState.mana -= delta / seconds_per_hour * mana_loss_per_hour
    LDState.time += delta / seconds_per_hour
    if LDState.time >= 12.0:
        LDState.time = 0.0
        LDState.floor += 1
        _board.queue_free()
        _board = _board_scene.instantiate()
        _board.position = Vector2(16.0, 16.0)
        add_child(_board)
