extends Node2D

signal start_game


func _input(event):
    if event.is_action_pressed("action"):
        start_game.emit()


func set_loss_text(floor: int):
    $Control/Label.text = """Summoner's Dilemma
__________________


You made it to
floor """ + str(LDState.floor + 1) + """ then
ran out of mana.


Press [Space]
to try again."""
