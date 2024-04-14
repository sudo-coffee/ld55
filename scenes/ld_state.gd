extends Node

var _mana: float = 100.999
var mana: float:
    set(value): _mana = min(value, max_mana)
    get: return _mana
var time: float = 0.0 # In hours.
var unit_time: float = 0.0 # In hours, .
var max_mana: float = 100.999
var floor: int = 0
var summon_queue: Array[_SummonQueueItem] = []
var time_multiplier = 1.0
var drain_multiplier = 1.0

class _SummonQueueItem:
    var unit_type: String
    var floor: int
    var time: float
    var instance: int


func add_summon(unit_type: String, instance: int) -> void:
    var summon := _SummonQueueItem.new()
    summon.unit_type = unit_type
    summon.floor = floor + 1
    summon.time = time
    summon.instance = instance
    summon_queue.append(summon)
