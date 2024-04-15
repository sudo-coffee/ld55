extends LDUnit


func on_release():
    super()
    for unit in grid.units:
        if unit.unit_type == &"bloom":
            unit.reset_growth_multiplier()


func on_hold():
    super()
    for unit in grid.units:
        if unit.unit_type == &"bloom":
            unit.reset_growth_multiplier()
