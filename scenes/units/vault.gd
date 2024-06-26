extends LDUnit

@export var spawn_interval: float = 4.0 # In hours.
@onready var time_created: float = LDState.time
var bloom_instance_offset: int = 0


func _process(_delta):
    var bloom_instance: int = 3 * instance + bloom_instance_offset + 12 * int(was_summoned)
    var spawn_time: float = spawn_interval * float(bloom_instance_offset) + time_created
    if LDState.time >= spawn_time:
        bloom_instance_offset += 1
        if grid.get_units_in_cell(grid_position).size() < 2:
            var bloom: LDUnit = grid.create_unit(&"bloom", bloom_instance, grid_position)
