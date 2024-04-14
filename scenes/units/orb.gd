extends LDUnit

@export var multiplier: float = 2.0


func on_create():
    LDState.drain_multiplier *= 1.0 / multiplier


func on_delete():
    LDState.drain_multiplier *= multiplier
