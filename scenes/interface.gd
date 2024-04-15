extends Control

var _infobox_scene: Resource = preload("res://scenes/infobox.tscn")


func _init():
    LDState.interface = self


func update_info_boxes(units: Array[LDUnit]):
    for child in $VBoxContainer.get_children().filter(func(child): return child.name != "Header"):
        $VBoxContainer.remove_child(child)
        child.queue_free()
    units.sort_custom(func(a, b): return a.unit_layer > b.unit_layer)
    for unit in units:
        var infobox = _infobox_scene.instantiate()
        infobox.get_child(1).text = unit.UIName
        infobox.get_child(2).text = unit.UIHelp
        $VBoxContainer.add_child(infobox)
