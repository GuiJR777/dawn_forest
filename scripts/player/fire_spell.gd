extends Area2D

class_name FireSpell


var damage: int


func _ready() -> void:
	for child in get_children():
		if child is Particles2D and child.name != "ExplosionParticless":
			child.emitting = true


func _on_AnimationPlayer_animation_finished(animation_name: String):
	match animation_name:
		"light_strenght":
			queue_free()
