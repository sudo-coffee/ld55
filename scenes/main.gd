extends Node2D

@export var seconds_per_hour: float = 7.5
@export var drain_per_hour: float = 5.0
@export var floor_multiplier: float = 1.3
@onready var _world: Node2D
@onready var _board: Node2D
@onready var _menu: Node2D
var _world_scene: Resource = preload("res://scenes/world.tscn")
var _board_scene: Resource = preload("res://scenes/board.tscn")
var _menu_scene: Resource = preload("res://scenes/menu.tscn")
var _pop_scene: Resource = preload("res://scenes/pop.tscn")


func _init():
    if not is_node_ready():
        await ready
    _reset_game()


func _reset_game():
    _menu = _menu_scene.instantiate()
    if not LDState.first_menu:
        _menu.set_loss_text(LDState.floor)
    LDState.game_started = false
    LDState.mana = 100
    LDState.time = 0
    LDState.unit_time = 0
    LDState.floor = 0
    LDState.drain_multiplier = 1.0
    LDState.time_multiplier = 1.0
    _menu.position.y = -240.0
    add_child(_menu)
    var menu_tween := get_tree().create_tween()
    menu_tween.set_ease(Tween.EASE_OUT)
    menu_tween.set_trans(Tween.TRANS_EXPO)
    if LDState.first_menu:
        menu_tween.tween_interval(0.5)
    else:
        menu_tween.tween_interval(1)
    menu_tween.tween_property(_menu, "position", Vector2(0.0, 0.0), 1)
    _menu.start_game.connect(_start_game)


func _start_game():
    var menu_tween := get_tree().create_tween()
    menu_tween.set_ease(Tween.EASE_IN)
    menu_tween.set_trans(Tween.TRANS_EXPO)
    menu_tween.tween_property(_menu, "position", Vector2(0.0, 240.0), 1)
    menu_tween.tween_callback(_menu.queue_free)
    LDState.first_menu = false
    
    # First floor.
    _world = _world_scene.instantiate()
    _board = _world.get_child(0)
    _world.position.y = -240.0
    add_child(_world)
    var new_world_tween := get_tree().create_tween()
    new_world_tween.set_ease(Tween.EASE_OUT)
    new_world_tween.set_trans(Tween.TRANS_EXPO)
    new_world_tween.tween_interval(1)
    new_world_tween.tween_property(_world, "position", Vector2(0.0, 0.0), 1)
    LDState.game_started = true


func _process(delta):
    _process_background()
    if LDState.game_started:
        _process_game_state(delta)
        _process_summon_queue()
        _process_lose_condition()


func _process_background():
    $Background.modulate.v = 0.15 + sin(LDState.time / 12.0 * PI) ** 0.6 / 2.5
    $Background.modulate.s = 0.50 - sin(LDState.time / 12.0 * PI) ** 0.6 / 6.0
    $Background.modulate.h = 0.90 - sin(LDState.time / 12.0 * PI) ** 0.6 / 3.0
    pass


func _process_lose_condition():
    if LDState.mana <= 0:
        var blank_array: Array[LDUnit]
        $Interface.update_info_boxes(blank_array)
        # Old floor.
        var old_world = _world
        var old_board = _board
        old_board.remove_unit(_board.player)
        old_board.player.queue_free()
        var old_world_tween := get_tree().create_tween()
        old_world_tween.set_ease(Tween.EASE_IN)
        old_world_tween.set_trans(Tween.TRANS_EXPO)
        old_world_tween.tween_property(old_world, "position", Vector2(0.0, 240.0), 1)
        old_world_tween.tween_callback(old_world.queue_free)
        _reset_game()
        


func _process_game_state(delta):
    LDState.mana -= delta / seconds_per_hour * drain_per_hour * LDState.time_multiplier * LDState.drain_multiplier * (pow(floor_multiplier, LDState.floor))
    LDState.time += delta / seconds_per_hour * LDState.time_multiplier
    LDState.unit_time += delta / seconds_per_hour
    if LDState.time >= 12.0:
        LDState.time = 0.0
        LDState.unit_time = 0.0
        LDState.drain_multiplier = 1.0
        LDState.time_multiplier = 1.0
        LDState.floor += 1
        var blank_array: Array[LDUnit]
        $Interface.update_info_boxes(blank_array)
        
        # Old floor.
        var old_world = _world
        var old_board = _board
        old_board.remove_unit(_board.player)
        old_board.player.queue_free()
        var old_world_tween := get_tree().create_tween()
        old_world_tween.set_ease(Tween.EASE_IN)
        old_world_tween.set_trans(Tween.TRANS_EXPO)
        old_world_tween.tween_property(old_world, "position", Vector2(0.0, 240.0), 1)
        old_world_tween.tween_callback(old_world.queue_free)
        
        # New floor.
        _world = _world_scene.instantiate()
        _board = _world.get_child(0)
        _world.position.y = -240.0
        add_child(_world)
        var new_world_tween := get_tree().create_tween()
        new_world_tween.set_ease(Tween.EASE_OUT)
        new_world_tween.set_trans(Tween.TRANS_EXPO)
        new_world_tween.tween_interval(1)
        new_world_tween.tween_property(_world, "position", Vector2(0.0, 0.0), 1)


func _process_summon_queue():
    # Spaghetti code to remove summoned object.
    if LDState.summon_queue.size() > 0 and LDState.summon_queue[0].time <= LDState.time and LDState.summon_queue[0].floor == LDState.floor:
        var summon_units: Array[LDUnit] = _board.units.filter(_unit_has_been_summoned.bind(LDState.summon_queue[0]))
        LDState.summon_queue.remove_at(0)
        for unit in summon_units:
            unit.on_delete()
            _board.remove_unit(unit)
            var pop = _pop_scene.instantiate()
            add_child(pop)
            pop.global_position = unit.global_position + Vector2(16.0, 16.0)
            var pop_twine := get_tree().create_tween()
            pop_twine.tween_interval(0.2)
            pop_twine.tween_callback(pop.queue_free)
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
    
