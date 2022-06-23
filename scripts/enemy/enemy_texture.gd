extends Sprite

class_name EnemyTexture

const STOP_VALUE: int = 0

export(NodePath) onready var animation_player = get_node(animation_player) as AnimationPlayer
export(NodePath) onready var enemy = get_node(enemy) as EnemyTemplate
export(NodePath) onready var attack_area = get_node(attack_area) as CollisionShape2D


func animate(_direction: Vector2) -> void:
	pass


func _on_AnimationPlayer_animation_finished(_animation_name: String) -> void:
	pass # Replace with function body.
