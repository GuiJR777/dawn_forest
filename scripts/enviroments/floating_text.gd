extends Label

class_name FloatText


onready var tween: Tween = get_node("Tween")

var value: int
var mass: int = 20

var velocity: Vector2
var gravity: Vector2 = Vector2.UP

var type: String
var type_sign: String

export(Color) var xp_color
export(Color) var hp_color
export(Color) var mp_color
export(Color) var damage_color

func _ready():
	randomize()
	velocity = Vector2(
		rand_range(-10, 10),
		-30
	)
