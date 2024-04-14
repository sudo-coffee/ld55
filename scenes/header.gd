extends HBoxContainer

@onready var clock: Label = $Clock
@onready var mana: Label = $Mana
@onready var floor: Label = $Floor


func _process(_delta):
    clock.text = "Time\n" \
        + "%02d" % (int(floor(LDState.time + 5)) % 12 + 1) \
        + ":" \
        + "%02d" % floor(fmod(LDState.time, 1.0) * 60)
    mana.text = "Mana\n" + "%03d" % floor(LDState.mana)
    floor.text = "Floor\n" + "%02d" % (LDState.floor + 1)
