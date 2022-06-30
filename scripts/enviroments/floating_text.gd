	extends Label

class_name FloatingText


onready var tween: Tween = get_node("Tween")

var value: int
var mass: int = 20

var velocity: Vector2
var gravity: Vector2 = Vector2.UP

var type: String = ""
var type_sign: String = ""

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
	floating_text()

func floating_text() -> void:
	text = type_sign + str(value)
	match type:
		"XP":
			modulate = xp_color
		"HP":
			modulate = hp_color
		"MP":
			modulate = mp_color
		"DAMAGE":
			modulate = damage_color
	interpolate()

func interpolate() -> void:
	var _interpolate_text_size_up: bool = tween.interpolate_property(
		self,
		"rect_scale",
		Vector2.ZERO,
		Vector2.ONE,
		0.3,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	
	var _interpolate_text_size_down: bool = tween.interpolate_property(
		self,
		"rect_scale",
		Vector2.ONE,
		Vector2(0.4, 0.4),
		1.0,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT,
		0.6
	)
	
	var _interpolate_text_color: bool = tween.interpolate_property(
		self, # Objeto
		"modulate:a", # Propriedade
		1.0, # Valor inicial
		0.0, # Valor final
		3.0, # Tempo de transição
		Tween.TRANS_LINEAR, # Tipo de transição
		Tween.EASE_OUT, # Fim de transição
		0.7 # Tempo de inicio da interpolação
	)
	
	var _init_tween: bool = tween.start()
	yield(tween, "tween_all_completed")
	queue_free()

func _process(delta):
	velocity += gravity * mass * delta
	rect_position += velocity * delta
