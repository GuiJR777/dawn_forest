extends EnemyTexture

class_name CrabbyTexture

const ATTACK_EFFECT: PackedScene = preload("res://scenes/SFX/enemy/crabby/crabby_attack_effect.tscn")

var attack_sfx_played: bool = false

func animate(velocity: Vector2) -> void:
	if enemy.is_taking_damage or enemy.is_dead or enemy.can_attack:
		__action_behaviour()
	else:
		__move_behaviour(velocity.x)

func __action_behaviour():
	if enemy.is_dead:
		animation_player.play("die")
		enemy.is_taking_damage = false
		enemy.can_attack = false
	elif enemy.is_taking_damage:
		animation_player.play("take_damage")
		enemy.can_attack = false
	elif enemy.can_attack:
		animation_player.play("attack")
		if not attack_sfx_played:
			spawn_attack_effect()
			attack_sfx_played = true

func __move_behaviour(velocity: float) -> void:
	if velocity != STOP_VALUE:
		animation_player.play("run")
	else:
		animation_player.play("idle")

func spawn_attack_effect() -> void:
	var effect = ATTACK_EFFECT.instance()
	get_tree().root.call_deferred("add_child", effect)
	effect.global_position = global_position
	effect.play_sfx()


func _on_AnimationPlayer_animation_finished(animation_name: String) -> void:
	match animation_name:
		"take_damage":
			enemy.is_taking_damage = false
			enemy.set_physics_process(true)
		"die":
			enemy.kill_enemy()
		"kill":
			enemy.queue_free()
		"attack":
			enemy.can_attack = false
			attack_sfx_played = false
