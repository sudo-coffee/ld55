extends Node

var _mana: float = 100.0
var mana: float:
    set(value): _mana = min(value, max_mana)
    get: return _mana
var time: float # In hours.
var max_mana: float = 100.0
var floor: int = 0


