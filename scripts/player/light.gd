extends Light2D

class_name PlayerLight

export(NodePath) onready var player = get_node(player) as KinematicBody2D
export(NodePath) onready var animation_player = get_node("Animation")


func _process(delta):
	if player.is_dead:
		animation_player.play("dead")


func _on_Animation_animation_finished(animation_name):
	match animation_name:
		"dead": queue_free()
