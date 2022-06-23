extends ParallaxBackground

class_name Background

export(bool) var can_process
export(Array, int) var layer_speed


func _ready():
	set_physics_process(can_process)

func _physics_process(delta):
	for index in get_child_count():
		if get_child(index) is ParallaxLayer:
			get_child(index).motion_offset.x -= delta * layer_speed[index]
