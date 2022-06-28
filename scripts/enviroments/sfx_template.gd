extends AnimatedSprite

class_name SFXTemplate

func play_sfx() -> void:
	play()


func _on_SFX_template_animation_finished() -> void:
	queue_free()
