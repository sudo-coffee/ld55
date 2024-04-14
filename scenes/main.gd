extends Node2D

@export var seconds_per_hour: float = 5.0
@export var drain_per_hour: float = 5.0
@export var floor_multiplier: float = 1.2
@onready var _board: Node2D = $Board
var _board_scene: Resource = preload("res://scenes/board.tscn")


func _process(delta):
    _process_game_state(delta)
    _process_summon_queue()


func _process_game_state(delta):    
    LDState.mana -= delta / seconds_per_hour * drain_per_hour * LDState.drain_multiplier * (pow(floor_multiplier, LDState.floor))
    LDState.time += delta / seconds_per_hour * LDState.time_multiplier
    LDState.unit_time += delta / seconds_per_hour
    if LDState.time >= 12.0:
        LDState.time = 0.0
        LDState.unit_time = 0.0
        LDState.drain_multiplier = 1.0
        LDState.time_multiplier = 1.0
        LDState.floor += 1
        _board.queue_free()
        _board = _board_scene.instantiate()
        _board.position = Vector2(16.0, 16.0)
        add_child(_board)


func _process_summon_queue():
    # Spaghetti code to remove summoned object.
    if LDState.summon_queue.size() > 0 and LDState.summon_queue[0].time <= LDState.time and LDState.summon_queue[0].floor == LDState.floor:
        var summon_units: Array[LDUnit] = _board.units.filter(_unit_has_been_summoned.bind(LDState.summon_queue[0]))
        LDState.summon_queue.remove_at(0)
        for unit in summon_units:
            _board.remove_unit(unit)
            if _board.player.held_unit == unit:
                _board.player.held_unit = null


func _unit_has_been_summoned(unit: LDUnit, summon_queue_item) -> bool:
    if unit.unit_type != summon_queue_item.unit_type:
        return false
    if unit.instance != summon_queue_item.instance:
        return false
    if unit.was_summoned:
        return false
    return true
    
