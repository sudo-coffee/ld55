extends LDUnit


func on_release():
    for unit in grid.units:
        if unit.unit_type == &"bloom":
            unit.reset_growth_multiplier()


func on_hold():
    for unit in grid.units:
        if unit.unit_type == &"bloom":
            unit.reset_growth_multiplier()
